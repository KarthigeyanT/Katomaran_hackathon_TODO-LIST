# Contributing to Katomaran Hackathon - TODO List App

Thank you for your interest in contributing to our TODO List application! We appreciate your time and effort in helping us improve this project. Please take a moment to review these guidelines before making contributions.

## 🚀 Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
   ```bash
   git clone https://github.com/your-username/Katomaran_hackathon_TODO-LIST.git
   cd Katomaran_hackathon_TODO-LIST
   ```
3. **Set up the development environment**
   ```bash
   flutter pub get
   ```
4. **Create a new branch** for your changes
   ```bash
   git checkout -b feature/your-feature-name
   ```
5. **Set up environment variables**
   - Copy `.env.example` to `.env`
   - Update the `.env` file with your configuration

## 🛡️ Security Guidelines

1. **Never commit sensitive information**
   - API keys and secrets
   - OAuth credentials
   - Firebase configuration
   - Database connection strings
   - Any other sensitive data

2. **Environment Variables**
   - Always use `.env` for configuration
   - Never commit `.env` to version control
   - Add `.env` to your `.gitignore`

3. **Dependencies**
   - Keep dependencies up to date
   - Audit dependencies regularly for security vulnerabilities
   - Use `flutter pub outdated` to check for updates

## ✨ Making Changes

1. **Code Style**
   - Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
   - Use meaningful commit messages following [Conventional Commits](https://www.conventionalcommits.org/)
   - Keep commits atomic and focused on a single feature/fix

2. **Testing**
   - Write unit and widget tests for new features
   - Run tests before submitting a PR:
     ```bash
     flutter test
     flutter analyze
     ```

3. **Documentation**
   - Update relevant documentation when adding new features
   - Add comments for complex logic
   - Keep the README up to date

## 🔄 Submitting Changes

1. **Sync your fork**
   ```bash
   git remote add upstream https://github.com/KarthigeyanT/Katomaran_hackathon_TODO-LIST.git
   git fetch upstream
   git pull upstream main
   ```

2. **Push your changes**
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Open a Pull Request**
   - Provide a clear description of your changes
   - Reference any related issues
   - Include screenshots if applicable

## 📝 Code Review Process

1. All PRs require at least one approval
2. Maintainers will review your code and provide feedback
3. Address any feedback and update your PR
4. Once approved, your changes will be merged

## 🏆 Recognition

All contributors will be recognized in the project's contributors list. Significant contributions may be highlighted in the release notes.
   - Ensure all tests pass

3. **Documentation**
   - Update documentation when adding new features
   - Add comments for complex logic
   - Keep the README up to date

## Submitting Changes

1. **Push** your changes to your fork
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Open a Pull Request**
   - Describe your changes
   - Reference any related issues
   - Request a review from maintainers

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Need Help?

If you have questions about the contribution process, feel free to open an issue.
