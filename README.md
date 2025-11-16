# Volleyball Coaching App

A Flutter application for visualizing and managing volleyball team rotations and positions.

## Features

- **Rotations Screen**: Visualize team rotations on a standard volleyball court with 6 player positions
- **Interactive Controls**: Rotate positions clockwise or reset to default
- **Clean UI**: Modern, responsive design with dark/light theme support
- **Modular Architecture**: Clean, scalable codebase following feature-based architecture

## Architecture

The project follows a clean, modular architecture:

```
lib/
├── core/           # Core functionality (theme, routing, constants)
├── features/       # Feature modules
│   ├── home/
│   ├── rotations/
│   └── about/
└── shared/         # Shared widgets and utilities
```

## Tech Stack

- **Flutter**: UI framework
- **Riverpod**: State management
- **GoRouter**: Navigation

## Getting Started

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## MVP Features

- Home screen with navigation menu
- Volleyball court visualization with 6 player positions
- Rotation logic (clockwise rotation)
- Reset functionality
- About screen

## Deployment

- **Web**: Automatically deployed to Netlify using GitHub Actions. See [DEPLOYMENT.md](DEPLOYMENT.md) for setup instructions.
- **iOS**: See [IOS_DEPLOYMENT.md](IOS_DEPLOYMENT.md) for instructions on building and distributing the iOS app.

## Future Enhancements

- Player names assignment
- Multiple rotation patterns
- Position-specific strategies
- Team management
- Game statistics

