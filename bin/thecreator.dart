import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:thecreator/commands/commands.dart';
import 'package:thecreator/core/engine.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  // Initialize the Flutter engine
  final engine = AnimationEngine();
  await engine.initialize();
  
  // Set up the command runner with all available commands
  final runner = CommandRunner<int>(
    'thecreator',
    'Flutter-powered animation generation CLI with AI integration'
  )
    ..addCommand(CreateCommand(engine))
    ..addCommand(RenderCommand(engine))
    ..addCommand(ExportCommand(engine))
    ..addCommand(AIPromptCommand(engine))
    ..addOption('verbose', abbr: 'v', help: 'Show additional command output')
    ..addFlag('version', negatable: false, help: 'Print the tool version');

  try {
    // Parse global options first
    final argResults = runner.argParser.parse(arguments);
    
    if (argResults['version']) {
      print('thecreator version: $version');
      await engine.shutdown();
      exit(0);
    }
    
    // Run the command
    await runner.run(arguments);
    await engine.shutdown();
    exit(0);
  } catch (e) {
    print('Error: $e');
    await engine.shutdown();
    exit(1);
  }
}
