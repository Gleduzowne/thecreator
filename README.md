# TheCreator

A powerful CLI animation tool using Flutter's rendering engine with AI capabilities.

## Features

- Create 2D animations with Flutter's powerful rendering engine
- Generate animations from AI prompts using Ollama or OpenAI-compatible models
- Export to various video formats using FFmpeg
- Design mathematical, physical, cartoon, and other animations from the command line

## Getting Started

### Installation

```bash
dart pub global activate --source path .
```

### Creating a new animation project

```bash
thecreator create --name my_animation
```

### Rendering an animation

```bash
thecreator render --project my_animation
```

### Exporting to video

```bash
thecreator export --project my_animation --format mp4
```

### Using AI to generate animations

```bash
thecreator ai --prompt "A circle transforming into a square" --model llama3
```

## Project Structure
