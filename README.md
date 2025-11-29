# VolleyFlow

A Flutter application for visualizing and managing volleyball team rotations and positions.

**Live Demo**: [volleyflow.net](https://volleyflow.net)

**Developer**: [Pau Benet Prat](https://www.linkedin.com/in/pau-benet-prat-9a747692/)

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

- **Web**: Automatically deployed to GitHub Pages using GitHub Actions (100% free, no credit limits). See [DEPLOYMENT.md](DEPLOYMENT.md) for setup instructions.
- **Android**: See [ANDROID_DEPLOYMENT.md](ANDROID_DEPLOYMENT.md) for instructions on building and distributing the Android app.

## Contributing

Contributions are welcome! 🎉 

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on how to contribute.

**Quick start:**
- 🐛 **Found a bug?** Open an [issue](https://github.com/PauBenetPrat/volleyflow/issues) using the bug report template
- 💡 **Have an idea?** Open an [issue](https://github.com/PauBenetPrat/volleyflow/issues) using the feature request template
- 🔧 **Want to code?** Fork the repo, make your changes, and submit a pull request

## AI Agent Guidelines

This project includes comprehensive guidelines for AI coding assistants to ensure code quality and maintainability.

**For AI Agents:** See [`.agent/CLEAN_CODE_GUIDE.md`](.agent/CLEAN_CODE_GUIDE.md) for detailed clean code standards and requirements.

**Key Principles:**
- ✅ AI agents must prioritize clean, maintainable code
- ⚠️ AI agents must request user consent before deviating from clean code standards
- 📏 Clear thresholds for file length, function complexity, and code quality
- 🤝 User maintains control over code quality trade-offs

## Future Enhancements

- Player names assignment
- Multiple rotation patterns
- Position-specific strategies
- Team management
- Game statistics

## Links

- **Website**: [volleyflow.net](https://volleyflow.net)
- **GitHub Repository**: [github.com/PauBenetPrat/volleyflow](https://github.com/PauBenetPrat/volleyflow)
- **Developer LinkedIn**: [Pau Benet Prat](https://www.linkedin.com/in/pau-benet-prat-9a747692/)

## License

This project is open source and available for educational purposes.

