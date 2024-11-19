import 'package:flutter/material.dart';

class CircleData {
  final String? imageUrl;
  final int score;
  final Color color;
  Offset velocity;
  double radius;
  Offset position;
  bool hovered;

  CircleData({
    this.imageUrl,
    required this.score,
    required this.color,
    this.velocity = Offset.zero,
    this.radius = 0.0,
    this.position = Offset.zero,
    this.hovered = false
  });
}