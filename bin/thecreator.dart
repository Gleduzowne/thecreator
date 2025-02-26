import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:thecreator/core/engine.dart';
import 'package:thecreator/models/project.dart';

const String version = '0.0.1';

/// Main entry point for the CLI application
void main(List<String> arguments) async {
  // Initialize Flutter engine
  final engine = AnimationEngine();
  await engine.initialize();

  try {
    // Show help if no arguments
    if (arguments.isEmpty) {
      printGlobalHelp();
      await engine.shutdown();
      exit(0);
    }

    final firstArg = arguments[0];

    // Handle global flags
    if (firstArg == '--version') {
      print('thecreator version: $version');
      await engine.shutdown();
      exit(0);
    }

    if (firstArg == '--help' || firstArg == '-h') {
      printGlobalHelp();
      await engine.shutdown();
      exit(0);
    }

    // Process commands
    switch (firstArg) {
      case 'create':
        final remaining = arguments.sublist(1);
        final exitCode = await handleCreateCommand(engine, remaining);
        await engine.shutdown();
        exit(exitCode);

      case 'render':
        print('Render command not yet implemented');
        await engine.shutdown();
        exit(0);

      case 'export':
        print('Export command not yet implemented');
        await engine.shutdown();
        exit(0);

      case 'ai':
        print('AI command not yet implemented');
        await engine.shutdown();
        exit(0);

      default:
        print('Unknown command: $firstArg');
        printGlobalHelp();
        await engine.shutdown();
        exit(1);
    }
  } catch (e) {
    print('Error: $e');
    await engine.shutdown();
    exit(1);
  }
}

/// Print global help information
void printGlobalHelp() {
  print('TheCreator Animation CLI Tool v$version');
  print('');
  print('Usage: thecreator <command> [options]');
  print('');
  print('Available Commands:');
  print('  create    Create a new animation project');
  print('  render    Render animation frames');
  print('  export    Export animation to video');
  print('  ai        Generate animations using AI');
  print('');
  print('Global Options:');
  print('  --help      Show this help information');
  print('  --version   Display version information');
  print('');
  print('For command-specific help, use:');
  print('  thecreator <command> --help');
}

/// Handle the create command
Future<int> handleCreateCommand(
  AnimationEngine engine,
  List<String> args,
) async {
  // Show help for create command
  if (args.contains('--help') || args.contains('-h')) {
    printCreateHelp();
    return 0;
  }

  final parser = ArgParser();
  parser.addOption('name', abbr: 'n', help: 'Project name');
  parser.addOption('width', defaultsTo: '1920', help: 'Width in pixels');
  parser.addOption('height', defaultsTo: '1080', help: 'Height in pixels');
  parser.addOption('fps', defaultsTo: '60', help: 'Frames per second');
  parser.addOption('duration', defaultsTo: '5', help: 'Duration in seconds');

  // Parse arguments
  ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    print('Error parsing arguments: $e');
    printCreateHelp();
    return 1;
  }

  // Get project name (either from --name or first positional argument)
  String projectName;
  if (results['name'] != null) {
    projectName = results['name'];
  } else if (results.rest.isNotEmpty) {
    projectName = results.rest.first;
  } else {
    print('Error: Project name is required');
    printCreateHelp();
    return 1;
  }

  final width = int.parse(results['width']);
  final height = int.parse(results['height']);
  final fps = int.parse(results['fps']);
  final duration = double.parse(results['duration']);

  // Create the project
  return await createProject(
    projectName: projectName,
    width: width,
    height: height,
    fps: fps,
    duration: duration,
  );
}

/// Print help information for the create command
void printCreateHelp() {
  print('Create a new animation project');
  print('');
  print('Usage: thecreator create [options] [project_name]');
  print('');
  print('Options:');
  print('  --name, -n    Project name (alternative to positional argument)');
  print('  --width       Width in pixels (default: 1920)');
  print('  --height      Height in pixels (default: 1080)');
  print('  --fps         Frames per second (default: 60)');
  print('  --duration    Duration in seconds (default: 5)');
  print('  --help, -h    Show this help information');
  print('');
  print('Example:');
  print('  thecreator create --name myAnimation --width 1280 --height 720');
  print('  thecreator create myAnimation --width 1280 --height 720');
}

/// Create a new animation project with the specified parameters
Future<int> createProject({
  required String projectName,
  required int width,
  required int height,
  required int fps,
  required double duration,
}) async {
  // Create project directory
  final projectDir = Directory(path.join(Directory.current.path, projectName));
  if (await projectDir.exists()) {
    print('Error: Project "$projectName" already exists');
    return 1;
  }

  await projectDir.create();

  // Create project configuration
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

  // Create directory structure
  await Directory(path.join(projectDir.path, 'scenes')).create();
  await Directory(path.join(projectDir.path, 'assets')).create();
  await Directory(path.join(projectDir.path, 'output')).create();

  // Create main scene file
  final mainSceneFile = File(
    path.join(projectDir.path, 'scenes', 'main_scene.dart'),
  );
  await mainSceneFile.writeAsString(generateMainSceneTemplate(project));

  print('Created animation project "$projectName" successfully');
  print('Project structure:');
  print('  ${projectDir.path}/');
  print('  ├── project.json');
  print('  ├── scenes/');
  print('  │   └── main_scene.dart');
  print('  ├── assets/');
  print('  └── output/');

  return 0;
}

/// Generate the template for a main scene file
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
