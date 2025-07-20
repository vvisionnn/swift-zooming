# Contributing to SwiftUI Zooming

Thank you for your interest in contributing to SwiftUI Zooming! This document outlines the process for contributing to this project.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct. Please be respectful and constructive in all interactions.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, please include:

- **Clear description** of the issue
- **Steps to reproduce** the behavior
- **Expected behavior**
- **Actual behavior**
- **Screenshots or code samples** (if applicable)
- **Environment details** (iOS version, Xcode version, etc.)

Use the bug report template when creating issues.

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:

- **Clear description** of the enhancement
- **Use case** and motivation
- **Detailed proposal** of how it should work
- **Alternatives considered**

### Pull Requests

1. **Fork** the repository
2. **Create a feature branch** from `main`
3. **Make your changes** following our coding standards
4. **Add tests** for new functionality
5. **Update documentation** if needed
6. **Ensure all tests pass**
7. **Create a pull request**

#### Pull Request Process

1. Ensure your code follows the project's style guidelines
2. Update the README.md with details of changes (if applicable)
3. Add appropriate tests for your changes
4. Ensure all existing tests continue to pass
5. Your PR will be reviewed by maintainers

## Development Setup

### Prerequisites

- Xcode 15.0+
- Swift 6.1+
- iOS 16.0+ target
- SwiftLint (for code formatting)

### Getting Started

1. **Clone your fork**:
   ```bash
   git clone https://github.com/yourusername/swiftui-zooming.git
   cd swiftui-zooming
   ```

2. **Install SwiftLint**:
   ```bash
   brew install swiftlint
   ```

3. **Open in Xcode**:
   ```bash
   open Package.swift
   ```

4. **Build and test**:
   ```bash
   swift build
   swift test
   ```

## Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and use SwiftLint for consistency.

### Key Principles

- **Clarity over brevity**: Code should be self-documenting
- **Performance**: Prioritize efficient implementations
- **SwiftUI conventions**: Follow SwiftUI patterns and naming
- **Type safety**: Leverage Swift's type system
- **No force unwrapping**: Use safe unwrapping patterns

### Code Organization

- **One class/struct per file** (unless closely related)
- **Group related functionality** using extensions
- **Use MARK comments** for organization
- **Keep functions focused** and single-purpose

### Documentation

- **Public APIs** must be documented
- **Use Swift doc comments** (`///`) for public members
- **Include examples** in documentation when helpful
- **Update README** for user-facing changes

## Testing

### Test Requirements

- **Unit tests** for all public APIs
- **Integration tests** for complex interactions
- **Performance tests** for critical paths
- **Edge case coverage** for boundary conditions

### Running Tests

```bash
# Run all tests
swift test

# Run tests with coverage
swift test --enable-code-coverage

# Run specific test
swift test --filter testName
```

### Test Guidelines

- **Descriptive test names** that explain what is being tested
- **Arrange-Act-Assert** pattern
- **Test edge cases** and error conditions
- **Use meaningful assertions**
- **Mock external dependencies**

## Performance Guidelines

- **Profile before optimizing**
- **Measure performance impact** of changes
- **Avoid premature optimization**
- **Consider memory usage** alongside speed
- **Test on various devices** and iOS versions

## Git Workflow

### Branching Strategy

- `main`: Stable, release-ready code
- `develop`: Integration branch for features
- `feature/description`: Feature development
- `fix/description`: Bug fixes
- `hotfix/description`: Critical fixes for main

### Commit Messages

Follow conventional commit format:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/changes
- `chore`: Maintenance tasks

Examples:
```
feat(zoom): add double-tap to zoom functionality
fix(container): resolve memory leak in hosting controller
docs(readme): update installation instructions
```

## Release Process

1. **Version bump** in appropriate files
2. **Update CHANGELOG.md** with new features and fixes
3. **Create release PR** to main
4. **Tag release** after merge
5. **Update documentation** if needed

## Getting Help

- **GitHub Issues**: For bug reports and feature requests
- **GitHub Discussions**: For questions and general discussion
- **Code Review**: Request feedback on your pull requests

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- Project documentation

Thank you for contributing to SwiftUI Zooming! 🚀