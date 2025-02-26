import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:thecreator/commands/commands.dart';
import 'package:thecreator/core/engine.dart';

const String version = '0.0.1';

Future<void> main(List<String> arguments) async {
  // Initialize the Flutter engine
  final engine = AnimationEngine();
  await engine.initialize();
  
  try {
    // Create command runner
    final runner = CommandRunner<int>(
      'thecreator',
      'Flutter-powered animation generation CLI with AI integration',
    );
    
    // Add version and verbose flags
    runner.argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
    
    runner.argParser.addFlag(
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
    
    // Check for global flags first
    final globalResults = runner.argParser.parse(arguments);
    if (globalResults['version'] == true) {
      print('thecreator version: $version');
      await engine.shutdown();
      exit(0);
    }
    
    // Run the command
    final exitCode = await runner.run(arguments);
    await engine.shutdown();
    exit(exitCode ?? 0);
  } on UsageException catch (e) {
    print(e);
    await engine.shutdown();
    exit(64);
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack trace: $stackTrace');
    await engine.shutdown();
    exit(1);
  }
}
