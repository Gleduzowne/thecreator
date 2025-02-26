import 'package:flutter/widgets.dart';

/// Base class for animation scenes
abstract class AnimationScene {
  /// Build the scene at progress t (0.0 to 1.0)
  Widget build(BuildContext context, double t);

  /// Optional method to perform setup before animation starts
  void setup() {}

  /// Optional method to clean up after animation completes
  void cleanup() {}
}
