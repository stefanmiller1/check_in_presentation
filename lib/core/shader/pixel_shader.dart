import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;,

//
// class PixelateFilter extends StatelessWidget {
//   final double pixelSize;
//   final Widget child;
//   final ImageProvider imageProvider;
//
//   PixelateFilter({
//     required this.pixelSize,
//     required this.child,
//     required this.imageProvider,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//         child: Container(
//           color: Colors.transparent,
//           child: CustomPaint(
//             painter: PixelatePainter(
//               pixelSize: pixelSize,
//               imageProvider: imageProvider,
//             ),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PixelatePainter extends CustomPainter {
//   final double pixelSize;
//   final ImageProvider imageProvider;
//
//   PixelatePainter({
//     required this.pixelSize,
//     required this.imageProvider,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) async {
//     final image = await _loadImage(size);
//
//     if (image != null) {
//       final paint = Paint()..isAntiAlias = false;
//
//       // Pixelate effect logic
//       for (double dy = 0; dy < size.height; dy += pixelSize) {
//         for (double dx = 0; dx < size.width; dx += pixelSize) {
//           Rect rect = Rect.fromLTWH(dx, dy, pixelSize, pixelSize);
//           Color color = _getPixelColor(image, dx.toInt(), dy.toInt());
//           paint.color = color;
//           canvas.drawRect(rect, paint);
//         }
//       }
//     }
//   }
//
//   Future<img.Image?> _loadImage(Size size) async {
//     final completer = Completer<img.Image>();
//     final imageStream = imageProvider.resolve(ImageConfiguration(size: size));
//
//     imageStream.addListener(ImageStreamListener((imageInfo, _) {
//       final byteData = imageInfo.image.toByteData();
//       final bytes = byteData.buffer.asUint8List();
//       final image = img.decodeImage(bytes);
//       completer.complete(image);
//     }));
//
//     return completer.future;
//   }
//
//   Color _getPixelColor(img.Image? image, int x, int y) {
//     if (image == null || x < 0 || x >= image.width || y < 0 || y >= image.height) {
//       return Colors.transparent;
//     }
//
//     final pixelColor = image.getPixelSafe(x, y);
//
//     // Extracting color components using bitwise operations
//     final alpha = (pixelColor >> 24) & 0xff;
//     final red = (pixelColor >> 16) & 0xff;
//     final green = (pixelColor >> 8) & 0xff;
//     final blue = pixelColor & 0xff;
//
//     return Color.fromARGB(alpha, red, green, blue);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

//
// class PixelateFilter extends StatelessWidget {
//   final double pixelSize;
//   final Widget child;
//
//   PixelateFilter({required this.pixelSize, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//         child: Container(
//           color: Colors.transparent,
//           child: CustomPaint(
//             painter: PixelatePainter(pixelSize: pixelSize),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PixelatePainter extends CustomPainter {
//   final double pixelSize;
//
//   PixelatePainter({required this.pixelSize});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..isAntiAlias = false;
//
//     // Draw the child onto the canvas
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
//
//     // Pixelate effect logic
//     for (double dy = 0; dy < size.height; dy += pixelSize) {
//       for (double dx = 0; dx < size.width; dx += pixelSize) {
//         Rect rect = Rect.fromLTWH(dx, dy, pixelSize, pixelSize);
//         _drawPixel(canvas, rect, size);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
//
//   void _drawPixel(Canvas canvas, Rect rect, Size size) {
//     // Sample colors from the region of the canvas
//     final colors = <Color>[];
//     for (double dy = rect.top; dy < rect.bottom; dy++) {
//       for (double dx = rect.left; dx < rect.right; dx++) {
//         // Simulate pixel color by sampling from the center of each rectangle
//         Offset center = Offset(dx + rect.width / 2, dy + rect.height / 2);
//         colors.add(canvas.getColor(center) ?? Colors.transparent);
//       }
//     }
//
//     // Compute the average color
//     final averageColor = _computeAverageColor(colors);
//
//     // Draw a larger rectangle with the average color
//     final paint = Paint()..color = averageColor;
//     canvas.drawRect(rect, paint);
//   }
//
//   Color _computeAverageColor(List<Color> colors) {
//     if (colors.isEmpty) {
//       return Colors.transparent;
//     }
//
//     int totalRed = 0;
//     int totalGreen = 0;
//     int totalBlue = 0;
//
//     for (final color in colors) {
//       totalRed += color.red;
//       totalGreen += color.green;
//       totalBlue += color.blue;
//     }
//
//     final averageRed = (totalRed / colors.length).round();
//     final averageGreen = (totalGreen / colors.length).round();
//     final averageBlue = (totalBlue / colors.length).round();
//
//     return Color.fromARGB(255, averageRed, averageGreen, averageBlue);
//   }
// }