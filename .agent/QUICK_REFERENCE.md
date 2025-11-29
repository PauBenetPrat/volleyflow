# Clean Code Quick Reference

Quick reference card for AI agents - thresholds that trigger consent requests.

## 🚦 Automatic Thresholds

### File & Class Size
| Metric | ✅ Good | ⚠️ Warning | 🚨 Requires Consent |
|--------|---------|------------|---------------------|
| File length | < 300 lines | 300-500 lines | > 500 lines |
| Class length | < 200 lines | 200-400 lines | > 400 lines |
| Function length | < 20 lines | 20-30 lines | > 30 lines |

### Code Complexity
| Metric | ✅ Good | 🚨 Requires Consent |
|--------|---------|---------------------|
| Function parameters | ≤ 3 | > 4 |
| Nested depth | ≤ 3 levels | > 3 levels |
| Cyclomatic complexity | ≤ 10 | > 10 |

### Code Quality
| Practice | Status |
|----------|--------|
| Code duplication | 🚨 Always requires consent if intentional |
| Commented-out code | ❌ Never allowed (use git instead) |
| Missing tests for new logic | 🚨 Requires consent |
| Breaking existing APIs | 🚨 Always requires consent |

## 📋 Consent Request Checklist

Before requesting consent, ensure you've:
- [ ] Explained the situation clearly
- [ ] Identified which clean code principle is violated
- [ ] Provided a clear reason why clean code can't be followed
- [ ] Described the proposed alternative
- [ ] Outlined technical debt implications
- [ ] Listed at least 2 alternatives considered
- [ ] Used the consent request template

## 🎯 Common Scenarios

### Scenario: Large Widget
**Threshold:** Widget > 200 lines  
**Action:** Propose breaking into smaller widgets  
**If not possible:** Request consent with refactoring plan

### Scenario: Complex Business Logic
**Threshold:** Function > 30 lines or > 4 parameters  
**Action:** Extract into smaller functions or use parameter objects  
**If not possible:** Request consent with explanation

### Scenario: Code Duplication
**Threshold:** Any intentional duplication  
**Action:** Extract into reusable component  
**If not possible:** Request consent with decoupling rationale

### Scenario: New Dependency
**Threshold:** Adding any new package  
**Action:** Check if functionality can be implemented without dependency  
**If needed:** Request consent with justification

### Scenario: Performance Optimization
**Threshold:** Optimization reduces readability  
**Action:** Measure performance impact first  
**If significant:** Request consent with benchmarks

## 🔄 Default Response

When in doubt, the AI agent should:
1. **Default to clean code** - Always try the clean approach first
2. **Explain the situation** - Be transparent about constraints
3. **Request consent** - Let the user decide on trade-offs
4. **Document decisions** - Add comments explaining why

## 📚 Full Documentation

For complete guidelines, see [CLEAN_CODE_GUIDE.md](CLEAN_CODE_GUIDE.md)
