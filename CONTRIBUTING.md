# Contributing to Katomaran Hackathon - TODO List App

First off, thank you for considering contributing to our project! It's people like you that make the open source community such a great place to learn, inspire, and create.

## Getting Started

1. **Fork** the repository on GitHub
2. **Clone** your fork locally
   ```bash
   git clone https://github.com/your-username/Katomaran_hackathon_TODO-LIST.git
   cd Katomaran_hackathon_TODO-LIST
   ```
3. **Set up** the development environment
   ```bash
   flutter pub get
   ```
4. **Create a new branch** for your changes
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Security Guidelines

1. **Never commit sensitive information**
   - API keys
   - OAuth credentials
   - Database credentials
   - Any other secrets

2. **Use environment variables** for configuration
   - Copy `.env.example` to `.env`
   - Add your configuration to `.env`
   - Never commit `.env` to version control

3. **Keep your fork in sync**
   ```bash
   git remote add upstream https://github.com/KarthigeyanT/Katomaran_hackathon_TODO-LIST.git
   git fetch upstream
   git pull upstream main
   ```

## Making Changes

1. **Code Style**
   - Follow the existing code style
   - Use meaningful commit messages
   - Keep commits small and focused

2. **Testing**
   - Write tests for new features
   - Run existing tests before submitting a PR
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
