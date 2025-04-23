import 'dart:ui';

class ButtonData {
  final String imageAsset;
  final String label;
  final onPressed;
  final Color? color;

  ButtonData(
      {required this.imageAsset,
      required this.label,
      required this.onPressed,
      required this.color});
}
