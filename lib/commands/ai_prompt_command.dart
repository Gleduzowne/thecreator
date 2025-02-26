import 'package:args/command_runner.dart';
import 'package:thecreator/core/engine.dart';

/// Command to generate animations from AI prompts
class AIPromptCommand extends Command<int> {
  final AnimationEngine engine;

  @override
  final String name = 'ai';

  @override
  final String description = 'Generate animations from AI prompts';

  AIPromptCommand(this.engine) {
    argParser
      ..addOption(
        'prompt',
        help: 'Text prompt describing the desired animation',
        mandatory: true,
      )
      ..addOption(
        'model',
        help: 'AI model to use (ollama, openai, etc.)',
        defaultsTo: 'ollama',
      )
      ..addOption('model-path', help: 'Path or URL to the AI model');
  }

  @override
  Future<int> run() async {
    print('AI prompt command not yet implemented');
    return 0;
  }
}
