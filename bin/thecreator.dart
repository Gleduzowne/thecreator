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
  final runner =
      CommandRunner<int>(
          'thecreator',
          'Flutter-powered animation generation CLI with AI integration',
        )
        ..argParser.addFlag(
          'version',
          negatable: false,
          help: 'Print the tool version.',
        )
        ..argParser.addFlag(
          'verbose',
          abbr: 'v',
          negatable: false,
          help: 'Show additional command output.',
        );

  // Add commands
  runner.addCommand(CreateCommand(engine));
  runner.addCommand(RenderCommand(engine));
  runner.addCommand(ExportCommand(engine));
  runner.addCommand(AIPromptCommand(engine));

  try {
    final results = await runner.run(arguments);
    await engine.shutdown();
    exit(results ?? 0);
  } on UsageException catch (e) {
    print(e);
    await engine.shutdown();
    exit(64);
  } catch (e) {
    print('Error: $e');
    await engine.shutdown();
    exit(1);
  }
}
