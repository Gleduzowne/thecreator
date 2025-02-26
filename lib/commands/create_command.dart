import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;
import 'package:thecreator/core/engine.dart';
import 'package:thecreator/models/project.dart';

/// Command to create a new animation project
class CreateCommand extends Command<int> {
  final AnimationEngine engine;

  @override
  final String name = 'create';

  @override
  final String description = 'Create a new animation project';

  CreateCommand(this.engine) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Name of the animation project',
        mandatory: true,
      )
      ..addOption(
        'width',
        help: 'Width of the animation in pixels',
        defaultsTo: '1920',
      )
      ..addOption(
        'height',
        help: 'Height of the animation in pixels',
        defaultsTo: '1080',
      )
      ..addOption('fps', help: 'Frames per second', defaultsTo: '60')
      ..addOption('duration', help: 'Duration in seconds', defaultsTo: '5');
  }

  @override
  Future<int> run() async {
    final projectName = argResults!['name'] as String;
    final width = int.parse(argResults!['width'] as String);
    final height = int.parse(argResults!['height'] as String);
    final fps = int.parse(argResults!['fps'] as String);
    final duration = double.parse(argResults!['duration'] as String);

    // Create project directory
    final projectDir = Directory(
      path.join(Directory.current.path, projectName),
    );
    if (await projectDir.exists()) {
      print('Error: Project "${projectName}" already exists');
      return 1;
    }

    await projectDir.create();

    // Create a project configuration
    final project = AnimationProject(
      name: projectName,
      width: width,
      height: height,
      fps: fps,
      duration: duration,
    );

    // Save project configuration
    final configFile = File(path.join(projectDir.path, 'project.json'));
    await configFile.writeAsString(project.toJson());

    // Create scenes directory
    final scenesDir = Directory(path.join(projectDir.path, 'scenes'));
    await scenesDir.create();

    // Create assets directory
    final assetsDir = Directory(path.join(projectDir.path, 'assets'));
    await assetsDir.create();

    // Create output directory
    final outputDir = Directory(path.join(projectDir.path, 'output'));
    await outputDir.create();

    // Create initial main scene file
    final mainSceneFile = File(path.join(scenesDir.path, 'main_scene.dart'));
    await mainSceneFile.writeAsString(generateMainSceneTemplate(project));

    print('Created animation project "${projectName}" successfully');
    print('Project structure:');
    print('  ${projectDir.path}/');
    print('  ├── project.json');
    print('  ├── scenes/');
    print('  │   └── main_scene.dart');
    print('  ├── assets/');
    print('  └── output/');

    return 0;
  }

  String generateMainSceneTemplate(AnimationProject project) {
    return '''
// Main scene for animation project "${project.name}"
import 'package:flutter/widgets.dart';
import 'package:thecreator/core/scene.dart';

class MainScene extends AnimationScene {
  @override
  Widget build(BuildContext context, double t) {
    // t ranges from 0.0 to 1.0 representing animation progress
    return Container(
      color: Color.fromRGBO(0, 0, 0, 1.0), // Black background
      child: Center(
        child: Text(
          'Hello from TheCreator!',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1.0),
            fontSize: 36.0,
          ),
        ),
      ),
    );
  }
}
''';
  }
}
