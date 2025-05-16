import 'dart:ui' as ui;
import 'dart:typed_data';

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

    for (int i = 0; i < pixels.length; i += 4) {
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
          // Increase brightness (e.g., +50)
          newPixels[i] = (r + 50).clamp(0, 255);
          newPixels[i + 1] = (g + 50).clamp(0, 255);
          newPixels[i + 2] = (b + 50).clamp(0, 255);
          newPixels[i + 3] = a;
          break;
        case 'Contrast':
          // Adjust contrast (e.g., contrast factor = 1.5)
          const factor = 1.5;
          newPixels[i] = ((r - 128) * factor + 128).round().clamp(0, 255);
          newPixels[i + 1] = ((g - 128) * factor + 128).round().clamp(0, 255);
          newPixels[i + 2] = ((b - 128) * factor + 128).round().clamp(0, 255);
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

    // Create a new image from the modified pixels
    final codec = await ui.instantiateImageCodec(newPixels, targetWidth: width, targetHeight: height);
    final frame = await codec.getNextFrame();
    _filteredImage = frame.image;
    _currentFilter = filterType;
  }

  // Dispose images to prevent memory leaks
  void dispose() {
    _originalImage?.dispose();
    _filteredImage?.dispose();
  }
}