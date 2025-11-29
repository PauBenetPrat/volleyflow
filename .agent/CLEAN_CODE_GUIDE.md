# Clean Code Guidelines for AI Agents

## Purpose
This guide instructs AI agents working on this Flutter project to prioritize clean code principles. When clean code practices cannot be followed, the AI agent **MUST** request user consent before proceeding with the implementation.

---

## Core Principles

### 1. **Always Prioritize Clean Code**
AI agents should default to writing clean, maintainable, and well-structured code following industry best practices and Flutter/Dart conventions.

### 2. **Request User Consent for Deviations**
If a situation arises where clean code principles cannot be followed (e.g., due to time constraints, technical limitations, or specific requirements), the AI agent **MUST**:
- Clearly explain why clean code cannot be applied
- Describe the proposed alternative approach
- Outline the technical debt or maintenance implications
- Wait for explicit user approval before implementing the non-clean solution

---

## Clean Code Standards for This Project

### **Code Organization**

#### File Structure
- ✅ Follow the feature-first architecture already established in this project
- ✅ Keep files focused on a single responsibility
- ✅ Limit file length to ~300-400 lines (request consent if exceeding 500 lines)
- ✅ Group related files in appropriate feature directories

#### Naming Conventions
- ✅ Use descriptive, meaningful names for classes, methods, and variables
- ✅ Follow Dart naming conventions:
  - `UpperCamelCase` for classes and types
  - `lowerCamelCase` for variables, methods, and parameters
  - `lowercase_with_underscores` for file names
- ✅ Avoid abbreviations unless they are widely understood (e.g., `id`, `url`)
- ✅ Use verb phrases for methods (`fetchTeams`, `updatePlayer`, `validateInput`)

### **Functions and Methods**

#### Function Length
- ✅ Keep functions short and focused (ideally < 20 lines)
- ⚠️ If a function exceeds 30 lines, request user consent and explain why it cannot be broken down

#### Single Responsibility
- ✅ Each function should do one thing and do it well
- ✅ Extract complex logic into separate, well-named helper functions
- ✅ Avoid side effects when possible

#### Parameters
- ✅ Limit function parameters to 3-4 maximum
- ⚠️ If more parameters are needed, request consent and consider using:
  - Named parameters
  - Parameter objects/classes
  - Builder pattern

### **Classes and Widgets**

#### Class Size
- ✅ Keep classes focused on a single responsibility (Single Responsibility Principle)
- ✅ Limit class length to ~200-300 lines
- ⚠️ If a class exceeds 400 lines, request user consent and propose refactoring options

#### Widget Composition
- ✅ Break down large widgets into smaller, reusable components
- ✅ Extract widget builders into separate methods or widgets when they exceed 10-15 lines
- ✅ Use composition over inheritance

#### State Management
- ✅ Follow the established Riverpod pattern in this project
- ✅ Keep business logic separate from UI code
- ✅ Use appropriate state management solutions (providers, notifiers, etc.)

### **Code Duplication**

- ✅ Follow the DRY (Don't Repeat Yourself) principle
- ✅ Extract repeated code into reusable functions, classes, or widgets
- ⚠️ If duplication is intentional (e.g., for decoupling), request user consent and document the reasoning

### **Comments and Documentation**

#### When to Comment
- ✅ Write self-documenting code that doesn't need comments
- ✅ Add comments only when explaining **why**, not **what**
- ✅ Document complex algorithms or business logic
- ✅ Add doc comments (`///`) for public APIs

#### What to Avoid
- ❌ Commented-out code (remove it; use version control instead)
- ❌ Obvious comments that restate the code
- ❌ Outdated comments that don't match the current implementation

### **Error Handling**

- ✅ Handle errors gracefully and provide meaningful error messages
- ✅ Use appropriate error handling mechanisms (try-catch, Result types, etc.)
- ✅ Log errors appropriately for debugging
- ✅ Avoid silent failures

### **Testing**

- ✅ Write unit tests for business logic
- ✅ Write widget tests for UI components
- ✅ Ensure tests are readable and maintainable
- ✅ Follow the Arrange-Act-Assert pattern

### **Performance**

- ✅ Avoid premature optimization
- ✅ Use `const` constructors where possible
- ✅ Minimize widget rebuilds
- ✅ Optimize expensive operations (e.g., list operations, network calls)
- ⚠️ If performance optimizations compromise readability, request user consent

### **Dependencies**

- ✅ Minimize external dependencies
- ✅ Keep dependencies up to date
- ✅ Avoid adding dependencies for trivial functionality
- ⚠️ Request consent before adding new packages to `pubspec.yaml`

---

## When to Request User Consent

The AI agent **MUST** request user consent in the following scenarios:

### 🚨 **Critical Situations** (Always Request Consent)

1. **Large Files or Classes**
   - Any file exceeding 500 lines
   - Any class exceeding 400 lines
   - Any function exceeding 30 lines

2. **Code Duplication**
   - Intentional duplication for decoupling purposes
   - Temporary duplication with plans to refactor later

3. **Technical Debt**
   - Quick fixes or workarounds that compromise code quality
   - Temporary solutions that need future refactoring
   - Skipping tests due to time constraints

4. **Architecture Deviations**
   - Breaking established patterns in the codebase
   - Introducing new architectural patterns
   - Violating SOLID principles

5. **Performance vs. Readability Trade-offs**
   - Optimizations that make code harder to understand
   - Complex algorithms that sacrifice clarity for speed

6. **Breaking Changes**
   - Changes that affect existing APIs
   - Modifications that require updates in multiple places

### ⚠️ **Advisory Situations** (Recommend Consent)

1. **New Dependencies**
   - Adding packages to `pubspec.yaml`

2. **Complex Logic**
   - Implementing complex algorithms
   - Adding intricate business logic

3. **Experimental Features**
   - Using beta or experimental APIs
   - Implementing cutting-edge patterns

---

## Consent Request Template

When requesting user consent, the AI agent should use the following format:

```
⚠️ **Clean Code Deviation Request**

**Situation:**
[Describe what you're trying to implement]

**Clean Code Violation:**
[Explain which clean code principle cannot be followed]

**Reason:**
[Explain why the clean approach is not feasible]

**Proposed Solution:**
[Describe the alternative approach]

**Implications:**
- **Technical Debt:** [Describe maintenance implications]
- **Readability Impact:** [How it affects code understanding]
- **Future Refactoring:** [What would need to be done later]

**Alternatives Considered:**
1. [Alternative 1 and why it was rejected]
2. [Alternative 2 and why it was rejected]

**Request:**
May I proceed with the proposed solution, or would you prefer one of the alternatives?
```

---

## Examples

### ✅ **Good: Clean Code**

```dart
// Good: Short, focused function with clear purpose
Future<List<Team>> fetchActiveTeams() async {
  final teams = await _teamRepository.getAllTeams();
  return teams.where((team) => team.isActive).toList();
}

// Good: Extracted widget for better composition
class PlayerCard extends StatelessWidget {
  final Player player;
  
  const PlayerCard({required this.player, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(player.name),
        subtitle: Text(player.position),
      ),
    );
  }
}
```

### ⚠️ **Requires Consent: Clean Code Violation**

```dart
// Bad: Function too long, doing too many things
// AI should request consent before implementing this
Future<void> processMatchData(Match match) async {
  // 50+ lines of mixed responsibilities:
  // - Data validation
  // - Business logic
  // - Database operations
  // - UI updates
  // - Error handling
  // ... (would need to be broken down)
}

// Bad: Large widget with too many responsibilities
// AI should request consent or propose refactoring
class TeamDetailPage extends StatefulWidget {
  // 600+ lines of code
  // Multiple responsibilities mixed together
  // Should be broken into smaller widgets
}
```

---

## Project-Specific Guidelines

### **This Flutter Project Uses:**

1. **Architecture:** Feature-first architecture with clear separation of concerns
2. **State Management:** Riverpod
3. **Routing:** Go Router (if applicable)
4. **Localization:** ARB files for internationalization
5. **Backend:** Supabase

### **Established Patterns to Follow:**

- Repository pattern for data access
- Provider pattern for state management
- Feature-based folder structure
- Separation of presentation, domain, and data layers

---

## Enforcement

- AI agents **MUST** follow these guidelines by default
- AI agents **MUST** request consent for any deviations
- AI agents should proactively suggest refactoring opportunities
- AI agents should explain their clean code decisions when relevant

---

## Updates

This guide should be updated as the project evolves and new patterns emerge. Any team member can propose updates to maintain alignment with best practices.

---

**Last Updated:** 2025-11-29  
**Version:** 1.0
