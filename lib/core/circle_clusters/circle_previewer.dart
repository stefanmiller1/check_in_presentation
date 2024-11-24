import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'circle_helper.dart';

import 'dart:math';

class CircleClusterWidget extends StatefulWidget {
  final List<CircleData> circles;
  final double circlePadding;

  CircleClusterWidget({required this.circles, required this.circlePadding});

  @override
  State<CircleClusterWidget> createState() => _CircleClusterWidgetState();
}

class _CircleClusterWidgetState extends State<CircleClusterWidget> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = (Responsive.isMobile(context)) ? MediaQuery.of(context).size.width : (MediaQuery.of(context).size.width >= 1500) ? 1500 : MediaQuery.of(context).size.width - 500;
    double containerWidth = screenWidth;
    double containerHeight = 330;

    List<CircleData> limitedCircles = Responsive.isMobile(context) ? widget.circles.take(10).toList() : widget.circles;

    calculateRadii(limitedCircles, 15, 90);
    packCircles(limitedCircles, containerWidth, containerHeight, widget.circlePadding);
    centerCluster(limitedCircles, containerWidth, containerHeight);


    return Container(
      width: containerWidth,
      height: containerHeight + 20,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: limitedCircles.asMap().map((i, circle) {
          return MapEntry(i, Positioned(
              left: circle.position.dx - circle.radius,
              top: circle.position.dy - circle.radius - (circle.hovered ? 5 : 0), // Translate by -10 when hovered
              child: SlideInTransitionWidget(
                durationTime: (i > 3) ? 300 * i : (i >= 1) ? 800 : 650,
                offset: Offset(0, 0.25),
                transitionWidget: MouseRegion(
                  onEnter: (_) {
                    if (!circle.hovered && circle.isElevated) {
                      setState(() {
                        circle.hovered = true;
                      });
                    }
                  },
                  onExit: (_) {
                    if (circle.hovered && circle.isElevated) {
                      Future.delayed(const Duration(milliseconds: 400), () {
                        setState(() {
                          circle.hovered = false;
                        });
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(0, circle.hovered ? -5 : 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: (circle.isElevated) ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                                spreadRadius: 5,
                                blurRadius: 13,
                                offset: const Offset(5, 0) // Positioning of the shadow
                            ),
                          ] : null,
                        ),
                        child: CircleAvatar(
                          radius: circle.radius,
                          backgroundColor: circle.color,
                          backgroundImage: (circle.imageUrl != null && circle.isSvg == false)
                              ? CachedNetworkImageProvider(
                                    circle.imageUrl!
                                )
                              : null,
                          child: (circle.imageUrl != null && circle.isSvg == true) ? ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: SvgPicture.asset(
                          fit: BoxFit.fitWidth,
                          circle.imageUrl!,
                          height: circle.radius / 0.8,
                          ),
                        ) : null)
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).values.toList(),
      ),
    );
  }
}

void calculateRadii(List<CircleData> circles, double minRadius, double maxRadius) {
  int minScore = circles.map((c) => c.score).reduce(min);
  int maxScore = circles.map((c) => c.score).reduce(max);

  for (var circle in circles) {
    circle.radius = minRadius +
        ((circle.score - minScore) / (maxScore - minScore)) * (maxRadius - minRadius);
  }
}

void packCircles(List<CircleData> circles, double containerWidth, double containerHeight, double circlePadding) {
  circles.sort((a, b) => b.radius.compareTo(a.radius));

  List<CircleData> placedCircles = [];

  // Place the first circle at the center
  circles[0].position = Offset(containerWidth / 2, containerHeight / 2);
  placedCircles.add(circles[0]);

  for (int i = 1; i < circles.length; i++) {
    CircleData circle = circles[i];
    bool placed = false;

    // Try to place the circle near existing circles
    for (var placedCircle in placedCircles) {
      double angleIncrement = pi / 6;
      for (double angle = 0; angle < 2 * pi; angle += angleIncrement) {
        // Add circle padding to the calculated distance
        double x = placedCircle.position.dx +
            (placedCircle.radius + circle.radius + circlePadding) * cos(angle);
        double y = placedCircle.position.dy +
            (placedCircle.radius + circle.radius + circlePadding) * sin(angle);
        circle.position = Offset(x, y);

        if (x - circle.radius < 0 ||
            x + circle.radius > containerWidth ||
            y - circle.radius < 0 ||
            y + circle.radius > containerHeight) {
          continue;
        }

        if (!isOverlapping(circle, placedCircles, circlePadding)) {
          placedCircles.add(circle);
          placed = true;
          break;
        }
      }
      if (placed) break;
    }

    if (!placed) {
      // If we couldn't find a spot, place it randomly within bounds
      circle.position = Offset(
        circle.radius + Random().nextDouble() * (containerWidth - 2 * circle.radius),
        circle.radius + Random().nextDouble() * (containerHeight - 2 * circle.radius),
      );

      // Ensure the circle does not overlap with others
      if (!isOverlapping(circle, placedCircles, circlePadding)) {
        placedCircles.add(circle);
      }
    }
  }

  // Optionally, adjust positions to center the cluster
  centerCircles(placedCircles, containerWidth, containerHeight);
}

bool isOverlapping(CircleData circle, List<CircleData> others, double circlePadding) {
  for (var other in others) {
    double dx = circle.position.dx - other.position.dx;
    double dy = circle.position.dy - other.position.dy;
    double distance = sqrt(dx * dx + dy * dy);
    if (distance < circle.radius + other.radius + circlePadding) {
      return true;
    }
  }
  return false;
}

void centerCluster(List<CircleData> circles, double containerWidth, double containerHeight) {
  // Calculate the horizontal bounds of the cluster
  double minX = circles.map((c) => c.position.dx - c.radius).reduce(min);
  double maxX = circles.map((c) => c.position.dx + c.radius).reduce(max);

  double clusterWidth = maxX - minX;

  // Calculate the horizontal offset needed to center the cluster
  double offsetX = (containerWidth - clusterWidth) / 2 - minX;

  // Apply the horizontal offset to each circle's position
  for (var circle in circles) {
    circle.position = Offset(circle.position.dx - offsetX, circle.position.dy);
  }
}


void centerCircles(List<CircleData> circles, double containerWidth, double containerHeight) {
  double minX = circles.map((c) => c.position.dx - c.radius).reduce(min);
  double minY = circles.map((c) => c.position.dy - c.radius).reduce(min);
  double maxX = circles.map((c) => c.position.dx + c.radius).reduce(max);
  double maxY = circles.map((c) => c.position.dy + c.radius).reduce(max);

  double offsetX = (containerWidth - (maxX - minX)) / 2 - minX;
  double offsetY = (containerHeight - (maxY - minY)) / 2 - minY;

  for (var circle in circles) {
    circle.position = Offset(circle.position.dx + offsetX, circle.position.dy + offsetY);
  }
}

