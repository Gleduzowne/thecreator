import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:thecreator/commands/create_command.dart';
import 'package:thecreator/commands/render_command.dart';
import 'package:thecreator/commands/export_command.dart';
import 'package:thecreator/commands/ai_prompt_command.dart';
import 'package:thecreator/core/engine.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  // Initialize the Flutter engine
  final engine = AnimationEngine();
  await engine.initialize();

  try {
    // No command provided - show global help
    if (arguments.isEmpty) {
      printUsage();
      await engine.shutdown();
      exit(0);
    }

    // Handle global flags
    if (arguments.contains('--version')) {
      print('thecreator version: $version');
      await engine.shutdown();
      exit(0);
    }

    // Handle commands
    final command = arguments[0];
    final commandArgs = arguments.length > 1 ? arguments.sublist(1) : [];

    switch (command) {
      case 'create':
        final exitCode = await handleCreateCommand(engine, commandArgs);
        await engine.shutdown();
        exit(exitCode);
      case 'render':
        final exitCode = await handleRenderCommand(engine, commandArgs);
        await engine.shutdown();
        exit(exitCode);
      case 'export':
        final exitCode = await handleExportCommand(engine, commandArgs);
        await engine.shutdown();
        exit(exitCode);
      case 'ai':
        final exitCode = await handleAICommand(engine, commandArgs);
        await engine.shutdown();
        exit(exitCode);
      case '--help':
      case '-h':
        printUsage();
        await engine.shutdown();
        exit(0);
      default:
        print('Unknown command: $command');
        printUsage();
        await engine.shutdown();
        exit(64);
    }
  } catch (e) {
    print('Error: $e');
    await engine.shutdown();
    exit(1);
  }
}

void printUsage() {
  print('Usage: thecreator <command> [options]');
  print('');
  print('Commands:');
  print('  create     Create a new animation project');
  print('  render     Render animation frames from a project');
  print('  export     Export rendered frames to video format');
  print('  ai         Generate animations from AI prompts');
  print('');
  print('Global Options:');
  print('  --help     Display this help message');
  print('  --version  Display version information');
  print('');
  print('For command-specific help:');
  print('  thecreator <command> --help');
}

Future<int> handleCreateCommand(
  AnimationEngine engine,
  List<String> arguments,
) async {
  final command = CreateCommand(engine);

  // Handle help flag first
  if (arguments.contains('--help') || arguments.contains('-h')) {
    print('Usage: thecreator create [options] <project-name>');
    print('');
    print(
      'Creates a new animation project directory with the specified name and configuration.',
    );
    print('');
    print('Options:');
    print(
      '  --name, -n       Name of the animation project (if not provided as argument)',
    );
    print(
      '  --width          Width of the animation in pixels (default: 1920)',
    );
    print(
      '  --height         Height of the animation in pixels (default: 1080)',
    );
    print('  --fps            Frames per second (default: 60)');
    print('  --duration       Duration in seconds (default: 5)');
    print('  --help, -h       Display this help information');
    return 0;
  }

  // Parse arguments
  final parser =
      ArgParser()
        ..addOption('name', abbr: 'n', help: 'Name of the animation project')
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

  ArgResults results;
  String projectName;

  try {
    results = parser.parse(arguments);

    // Get project name from arguments or --name option
    if (results.rest.isNotEmpty) {
      projectName = results.rest[0];
    } else if (results['name'] != null) {
      projectName = results['name'];
    } else {
      print('Error: Project name is required');
      return 64;
    }

    final width = int.parse(results['width']);
    final height = int.parse(results['height']);
    final fps = int.parse(results['fps']);
    final duration = double.parse(results['duration']);

    return await command.createProject(
      projectName,
      width,
      height,
      fps,
      duration,
    );
  } catch (e) {
    print('Error parsing arguments: $e');
    return 64;
  }
}

// Similar handlers for other commands
Future<int> handleRenderCommand(
  AnimationEngine engine,
  List<String> arguments,
) async {
  print('Render command not yet implemented');
  return 0;
}

Future<int> handleExportCommand(
  AnimationEngine engine,
  List<String> arguments,
) async {
  print('Export command not yet implemented');
  return 0;
}

Future<int> handleAICommand(
  AnimationEngine engine,
  List<String> arguments,
) async {
  print('AI prompt command not yet implemented');
  return 0;
}
