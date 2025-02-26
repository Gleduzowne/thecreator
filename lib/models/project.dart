import 'dart:convert';

/// Represents an animation project configuration
class AnimationProject {
  final String name;
  final int width;
  final int height;
  final int fps;
  final double duration;
  final List<String> scenes;

  AnimationProject({
    required this.name,
    required this.width,
    required this.height,
    required this.fps,
    required this.duration,
    List<String>? scenes,
  }) : scenes = scenes ?? ['main_scene'];

  /// Total number of frames in the animation
  int get totalFrames => (fps * duration).round();

  /// Convert project configuration to JSON string
  String toJson() {
    return jsonEncode({
      'name': name,
      'width': width,
      'height': height,
      'fps': fps,
      'duration': duration,
      'scenes': scenes,
    });
  }

  /// Create project from JSON string
  factory AnimationProject.fromJson(String jsonStr) {
    final Map<String, dynamic> data = jsonDecode(jsonStr);

    return AnimationProject(
      name: data['name'],
      width: data['width'],
      height: data['height'],
      fps: data['fps'],
      duration: data['duration'],
      scenes: List<String>.from(data['scenes']),
    );
  }
}
