import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Core engine that interfaces with Flutter's rendering pipeline
class AnimationEngine {
  bool _initialized = false;

  /// Initialize the Flutter engine for headless rendering
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize Flutter binding for headless rendering
    WidgetsFlutterBinding.ensureInitialized();
    _initialized = true;
    print('Animation engine initialized');
  }

  /// Render a single frame with the provided scene
  Future<ui.Image> renderFrame({
    required Widget scene,
    required int width,
    required int height,
    double pixelRatio = 1.0,
  }) async {
    if (!_initialized) {
      throw StateError('Animation engine not initialized');
    }

    // Create a new PipelineOwner for this frame
    final pipelineOwner = PipelineOwner();
    final rootNode = RenderView(
      configuration: ViewConfiguration(
        size: Size(width.toDouble(), height.toDouble()),
        devicePixelRatio: pixelRatio,
      ),
      window: ui.window,
    );

    // Connect the root node to the pipeline owner
    pipelineOwner.rootNode = rootNode;

    // Create the render tree
    final renderObjectToWidgetAdapter = RenderObjectToWidgetAdapter<RenderBox>(
      container: rootNode,
      child: scene,
    );

    // Build the render tree
    final renderObjectElement = renderObjectToWidgetAdapter.attachToRenderTree(
      pipelineOwner,
    );
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    // Create a scene and render to an image
    final sceneBuilder = ui.SceneBuilder();
    rootNode.compositeFrame(sceneBuilder, true);
    final scene = sceneBuilder.build();

    final completer = Completer<ui.Image>();
    scene.toImage(width, height).then((image) {
      renderObjectElement.unmount();
      completer.complete(image);
    });

    return completer.future;
  }

  /// Clean up resources
  Future<void> shutdown() async {
    _initialized = false;
    print('Animation engine shut down');
  }
}
