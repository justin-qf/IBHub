import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math' as math;

class ImageFilters {
  ui.Image? _originalImage;
  ui.Image? _filteredImage;
  String _currentFilter = 'None';
  bool _isOriginalImageValid = false;
  bool _isFilteredImageValid = false;

  // Getter for the filtered image
  ui.Image? get filteredImage => _filteredImage;

  // Getter for the current filter name
  String get currentFilter => _currentFilter;

  // List of 10 professional filters
  static const List<String> filters = [
    'None',
    'Vibrance',
    'Clarity',
    'Vintage',
    'Cinematic',
    'Lomo',
    'Moody',
    'Faded',
    'Bold',
    'Warm',
    'Cool',
  ];

  // Load image from Uint8List (e.g., from gallery)
  Future<void> loadImageFromBytes(Uint8List bytes) async {
    if (bytes.isEmpty) {
      print('ImageFilters: Empty image data');
      return;
    }
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      // Dispose existing images safely
      _safeDisposeImage('_originalImage', _originalImage, '_isOriginalImageValid');
      _safeDisposeImage('_filteredImage', _filteredImage, '_isFilteredImageValid');
      _originalImage = frame.image;
      _filteredImage = frame.image; // Initially same as original
      _isOriginalImageValid = true;
      _isFilteredImageValid = true;
      _currentFilter = 'None';
      codec.dispose();
    } catch (e) {
      print('ImageFilters: Failed to load image: $e');
      _isOriginalImageValid = false;
      _isFilteredImageValid = false;
      rethrow;
    }
  }

  Future<void> applyFilter(String filterType,
      {Map<String, dynamic>? params}) async {
    if (_originalImage == null || !_isOriginalImageValid) {
      print('ImageFilters: No valid original image to apply filter $filterType');
      return;
    }

    if (filterType == 'None') {
      // For 'None', reset _filteredImage to original
      _safeDisposeImage('_filteredImage', _filteredImage, '_isFilteredImageValid');
      // Use existing _originalImage instead of reloading
      _filteredImage = _originalImage;
      _isFilteredImageValid = true;
      _currentFilter = 'None';
      return;
    }

    final width = _originalImage!.width;
    final height = _originalImage!.height;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint();

    try {
      canvas.save();
      switch (filterType) {
        case 'Vibrance':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            1.2, 0.1, 0.1, 0, 0,
            0.1, 1.2, 0.1, 0, 0,
            0.1, 0.1, 1.2, 0, 0,
            0, 0, 0, 1, 0,
          ]);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;

        case 'Clarity':
          final blurPaint = ui.Paint()
            ..imageFilter = ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0);
          canvas.drawImage(_originalImage!, ui.Offset.zero, blurPaint);
          final overlayPaint = ui.Paint()
            ..blendMode = ui.BlendMode.overlay
            ..color = ui.Color.fromARGB(128, 255, 255, 255);
          canvas.drawImage(_originalImage!, ui.Offset.zero, overlayPaint);
          break;

        case 'Vintage':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            0.9, 0.5, 0.1, 0, 20,
            0.3, 0.8, 0.1, 0, 20,
            0.1, 0.2, 0.7, 0, 10,
            0, 0, 0, 1, 0,
          ]);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          final vignettePaint = ui.Paint()
            ..shader = ui.Gradient.radial(
              ui.Offset(width / 2, height / 2),
              math.min(width, height) * 0.5,
              [ui.Color.fromARGB(0, 0, 0, 0), ui.Color.fromARGB(100, 0, 0, 0)],
              [0.4, 1.0],
            )
            ..blendMode = ui.BlendMode.darken;
          canvas.drawRect(
              ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
              vignettePaint);
          break;

        case 'Cinematic':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            0.8, 0.2, 0.1, 0, 10,
            0.1, 0.9, 0.2, 0, 10,
            0.1, 0.3, 1.1, 0, 20,
            0, 0, 0, 1, 0,
          ]);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          final noise = await _generateNoiseTexture(width, height);
          final noisePaint = ui.Paint()..blendMode = ui.BlendMode.overlay;
          canvas.drawImage(noise, ui.Offset.zero, noisePaint);
          noise.dispose();
          break;

        case 'Lomo':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            1.3, 0.0, 0.0, 0, -10,
            0.0, 1.3, 0.0, 0, -10,
            0.0, 0.0, 1.3, 0, -10,
            0, 0, 0, 1, 0,
          ]);
          paint.imageFilter = ui.ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;

        case 'Moody':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            0.7, 0.2, 0.1, 0, -20,
            0.1, 0.7, 0.2, 0, -20,
            0.1, 0.2, 0.8, 0, -10,
            0, 0, 0, 1, 0,
          ]);
          paint.imageFilter = ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;

        case 'Faded':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            0.6, 0.2, 0.1, 0, 30,
            0.2, 0.6, 0.2, 0, 30,
            0.1, 0.2, 0.6, 0, 30,
            0, 0, 0, 1, 0,
          ]);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;

        case 'Bold':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            1.5, 0.0, 0.0, 0, -20,
            0.0, 1.5, 0.0, 0, -20,
            0.0, 0.0, 1.5, 0, -20,
            0, 0, 0, 1, 0,
          ]);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;

        case 'Warm':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            1.2, 0.3, 0.1, 0, 20,
            0.2, 1.1, 0.1, 0, 20,
            0.1, 0.1, 0.8, 0, 10,
            0, 0, 0, 1, 0,
          ]);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;

        case 'Cool':
          paint.colorFilter = const ui.ColorFilter.matrix(<double>[
            0.8, 0.2, 0.3, 0, 10,
            0.2, 0.9, 0.3, 0, 10,
            0.3, 0.3, 1.2, 0, 20,
            0, 0, 0, 1, 0,
          ]);
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;

        default:
          canvas.drawImage(_originalImage!, ui.Offset.zero, paint);
          break;
      }

      canvas.restore();
      final picture = recorder.endRecording();
      final newImage = await picture.toImage(width, height);

      // Dispose old filtered image safely
      _safeDisposeImage('_filteredImage', _filteredImage, '_isFilteredImageValid');
      _filteredImage = newImage;
      _isFilteredImageValid = true;
      _currentFilter = filterType;
    } catch (e) {
      print('ImageFilters: Failed to apply filter $filterType: $e');
      _isFilteredImageValid = false;
      rethrow;
    }
  }

  // Generate noise texture for Cinematic filter
  Future<ui.Image> _generateNoiseTexture(int width, int height) async {
    final random = math.Random();
    final pixels = Uint8List(width * height * 4);
    for (int i = 0; i < pixels.length; i += 4) {
      final noise = random.nextInt(50);
      pixels[i] = noise;
      pixels[i + 1] = noise;
      pixels[i + 2] = noise;
      pixels[i + 3] = 128;
    }

    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image image) {
        completer.complete(image);
      },
      rowBytes: width * 4,
    );
    return completer.future;
  }

  // Safely dispose an image with error handling
  void _safeDisposeImage(String imageName, ui.Image? image, String validFlagName) {
    if (image != null) {
      try {
        image.dispose();
        print('ImageFilters: Disposed $imageName');
      } catch (e) {
        print('ImageFilters: Error disposing $imageName: $e');
      }
      // Update the corresponding validity flag
      if (validFlagName == '_isOriginalImageValid') {
        _isOriginalImageValid = false;
      } else if (validFlagName == '_isFilteredImageValid') {
        _isFilteredImageValid = false;
      }
    }
  }

  // Dispose images to prevent memory leaks
  void dispose() {
    _safeDisposeImage('_originalImage', _originalImage, '_isOriginalImageValid');
    _safeDisposeImage('_filteredImage', _filteredImage, '_isFilteredImageValid');
    _originalImage = null;
    _filteredImage = null;
  }
}