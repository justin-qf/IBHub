import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math' as math; // Import with prefix

class ImageFilters {
  ui.Image? _originalImage;
  ui.Image? _filteredImage;
  String _currentFilter = 'None';

  // Getter for the filtered image
  ui.Image? get filteredImage => _filteredImage;

  // Getter for the current filter name
  String get currentFilter => _currentFilter;

  // Load image from Uint8List (e.g., from gallery)
  Future<void> loadImageFromBytes(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    _originalImage = frame.image;
    _filteredImage = frame.image;
    _currentFilter = 'None';
  }

  // Apply filter to the image
  Future<void> applyFilter(String filterType) async {
    if (_originalImage == null) return;

    final byteData = await _originalImage!.toByteData();
    if (byteData == null) return;

    final pixels = byteData.buffer.asUint8List();
    final width = _originalImage!.width;
    final height = _originalImage!.height;

    // Create a copy of the pixel data
    final newPixels = Uint8List(pixels.length);

    // Random number generator for Noise filter
    final random = math.Random();

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final i = (y * width + x) * 4;
        int r = pixels[i];
        int g = pixels[i + 1];
        int b = pixels[i + 2];
        int a = pixels[i + 3];

        switch (filterType) {
          case 'Grayscale':
            // Convert to grayscale using luminosity formula
            final gray = (0.299 * r + 0.587 * g + 0.114 * b).round();
            newPixels[i] = gray;
            newPixels[i + 1] = gray;
            newPixels[i + 2] = gray;
            newPixels[i + 3] = a;
            break;

          case 'Sepia':
            // Apply sepia tone
            newPixels[i] = (r * 0.393 + g * 0.769 + b * 0.189).round().clamp(0, 255);
            newPixels[i + 1] = (r * 0.349 + g * 0.686 + b * 0.168).round().clamp(0, 255);
            newPixels[i + 2] = (r * 0.272 + g * 0.534 + b * 0.131).round().clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          case 'Brightness':
            // Increase brightness by +50
            newPixels[i] = (r + 50).clamp(0, 255);
            newPixels[i + 1] = (g + 50).clamp(0, 255);
            newPixels[i + 2] = (b + 50).clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          case 'Contrast':
            // Adjust contrast with factor 1.5
            const factor = 1.5;
            newPixels[i] = ((r - 128) * factor + 128).round().clamp(0, 255);
            newPixels[i + 1] = ((g - 128) * factor + 128).round().clamp(0, 255);
            newPixels[i + 2] = ((b - 128) * factor + 128).round().clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          case 'Invert':
            // Invert colors
            newPixels[i] = (255 - r).clamp(0, 255);
            newPixels[i + 1] = (255 - g).clamp(0, 255);
            newPixels[i + 2] = (255 - b).clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          case 'Saturation':
            // Increase saturation by factor 1.5
            final gray = 0.299 * r + 0.587 * g + 0.114 * b;
            const satFactor = 1.5;
            newPixels[i] = (gray + satFactor * (r - gray)).round().clamp(0, 255);
            newPixels[i + 1] = (gray + satFactor * (g - gray)).round().clamp(0, 255);
            newPixels[i + 2] = (gray + satFactor * (b - gray)).round().clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          case 'HueRotation':
            // Rotate hue by 90 degrees
            final hsv = _rgbToHsv(r, g, b);
            hsv[0] = (hsv[0] + 90) % 360; // Shift hue
            final rgb = _hsvToRgb(hsv[0], hsv[1], hsv[2]);
            newPixels[i] = rgb[0].clamp(0, 255);
            newPixels[i + 1] = rgb[1].clamp(0, 255);
            newPixels[i + 2] = rgb[2].clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          case 'Blur':
            // Simple 3x3 box blur
            if (x > 0 && x < width - 1 && y > 0 && y < height - 1) {
              int sumR = 0, sumG = 0, sumB = 0, count = 0;
              for (int dy = -1; dy <= 1; dy++) {
                for (int dx = -1; dx <= 1; dx++) {
                  final ni = ((y + dy) * width + (x + dx)) * 4;
                  sumR += pixels[ni];
                  sumG += pixels[ni + 1];
                  sumB += pixels[ni + 2];
                  count++;
                }
              }
              newPixels[i] = (sumR / count).round().clamp(0, 255);
              newPixels[i + 1] = (sumG / count).round().clamp(0, 255);
              newPixels[i + 2] = (sumB / count).round().clamp(0, 255);
              newPixels[i + 3] = a;
            } else {
              newPixels[i] = r;
              newPixels[i + 1] = g;
              newPixels[i + 2] = b;
              newPixels[i + 3] = a;
            }
            break;

          case 'Vintage':
            // Combine sepia-like tones with reduced contrast
            newPixels[i] = (r * 0.353 + g * 0.729 + b * 0.169).round().clamp(0, 255);
            newPixels[i + 1] = (r * 0.309 + g * 0.646 + b * 0.148).round().clamp(0, 255);
            newPixels[i + 2] = (r * 0.232 + g * 0.494 + b * 0.111).round().clamp(0, 255);
            // Reduce contrast
            const vintageFactor = 0.8;
            newPixels[i] = ((newPixels[i] - 128) * vintageFactor + 128).round().clamp(0, 255);
            newPixels[i + 1] = ((newPixels[i + 1] - 128) * vintageFactor + 128).round().clamp(0, 255);
            newPixels[i + 2] = ((newPixels[i + 2] - 128) * vintageFactor + 128).round().clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          case 'Noise':
            // Add random noise (±20 to each channel)
            final noise = random.nextInt(41) - 20;
            newPixels[i] = (r + noise).clamp(0, 255);
            newPixels[i + 1] = (g + noise).clamp(0, 255);
            newPixels[i + 2] = (b + noise).clamp(0, 255);
            newPixels[i + 3] = a;
            break;

          default:
            // No filter, copy original pixels
            newPixels[i] = r;
            newPixels[i + 1] = g;
            newPixels[i + 2] = b;
            newPixels[i + 3] = a;
        }
      }
    }

    // Create a new image from the modified pixels
    final codec = await ui.instantiateImageCodec(
      newPixels,
      targetWidth: width,
      targetHeight: height,
    );
    final frame = await codec.getNextFrame();
    _filteredImage?.dispose(); // Dispose previous filtered image
    _filteredImage = frame.image;
    _currentFilter = filterType;
  }

  // Helper: Convert RGB to HSV
  List<double> _rgbToHsv(int r, int g, int b) {
    double rNorm = r / 255.0;
    double gNorm = g / 255.0;
    double bNorm = b / 255.0;

    final max = [rNorm, gNorm, bNorm].reduce(math.max); // Use math.max
    final min = [rNorm, gNorm, bNorm].reduce(math.min); // Use math.min
    final delta = max - min;

    double h = 0;
    if (delta != 0) {
      if (max == rNorm) {
        h = 60 * (((gNorm - bNorm) / delta) % 6);
      } else if (max == gNorm) {
        h = 60 * ((bNorm - rNorm) / delta + 2);
      } else {
        h = 60 * ((rNorm - gNorm) / delta + 4);
      }
    }
    double s = max == 0 ? 0 : delta / max;
    double v = max;

    return [h, s, v];
  }

  // Helper: Convert HSV to RGB
  List<int> _hsvToRgb(double h, double s, double v) {
    double c = v * s;
    double x = c * (1 - ((h / 60) % 2 - 1).abs());
    double m = v - c;

    double r = 0, g = 0, b = 0;
    if (h < 60) {
      r = c;
      g = x;
    } else if (h < 120) {
      r = x;
      g = c;
    } else if (h < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (h < 240) {
      g = x;
      b = c;
    } else if (h < 300) {
      r = x;
      b = c;
    } else {
      r = c;
      b = x;
    }

    return [
      ((r + m) * 255).round(),
      ((g + m) * 255).round(),
      ((b + m) * 255).round(),
    ];
  }

  // Dispose images to prevent memory leaks
  void dispose() {
    _originalImage?.dispose();
    _filteredImage?.dispose();
  }
}