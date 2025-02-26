import 'dart:io';
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
    'Flutter-powered animation generation CLI with AI integration',
  );

  // Add commands
  runner.addCommand(CreateCommand(engine));

  // These commands will be implemented later
  // Uncomment when their implementation files are available
  // runner.addCommand(RenderCommand(engine));
  // runner.addCommand(ExportCommand(engine));
  // runner.addCommand(AIPromptCommand(engine));

  try {
    // Handle global flags
    final topLevelResults = runner.parse(arguments);

    if (topLevelResults['version'] == true) {
      print('thecreator version: $version');
      await engine.shutdown();
      exit(0);
    }

    // Run the command
    await runner.runCommand(topLevelResults);
    await engine.shutdown();
    exit(0);
  } on UsageException catch (e) {
    print(e);
    await engine.shutdown();
    exit(64); // Exit code 64 indicates command line usage error
  } catch (e) {
    print('Error: $e');
    await engine.shutdown();
    exit(1);
  }
}
