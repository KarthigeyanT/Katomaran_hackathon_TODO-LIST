# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |


## Reporting a Vulnerability

If you discover any security vulnerabilities, please report them by creating an issue in the issue tracker.

## Security Measures

- Sensitive credentials are stored in environment variables (`.env` file)
- API keys and secrets are never committed to version control
- Dependencies are regularly updated to patch security vulnerabilities

## Secure Development

1. Never commit sensitive information to version control
2. Always use environment variables for API keys and secrets
3. Keep dependencies up to date
4. Follow secure coding practices

## Environment Setup

1. Copy `.env.example` to `.env`
2. Fill in your API keys and secrets in `.env`
3. Never commit `.env` to version control

## Dependencies

Regularly update your dependencies using:
```bash
flutter pub outdated
dart pub upgrade
```
