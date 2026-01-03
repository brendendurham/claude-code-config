---
name: pr-review-standards
description: Review pull requests using team coding standards. Triggers: review PR, check pull request, PR review, code review standards, review my changes, check my PR
---

# PR Review Standards Skill

Review pull requests systematically using team coding standards and best practices.

## When to Use

- User asks to "review PR", "review pull request", or "check my changes"
- User wants code review feedback before merging
- User asks about coding standards compliance

## Review Process

### Step 1: Gather PR Information

1. Get the PR diff using `gh pr diff` or `git diff`
2. Identify changed files and their types
3. Determine the scope of changes (feature, bugfix, refactor, etc.)

### Step 2: Apply Review Checklist

For each changed file, evaluate against these categories:

#### Code Quality
- [ ] Code is readable and self-documenting
- [ ] Functions/methods have single responsibility
- [ ] No dead code or commented-out blocks
- [ ] Appropriate error handling
- [ ] No hardcoded values that should be configurable

#### Security
- [ ] No secrets, API keys, or credentials exposed
- [ ] Input validation present where needed
- [ ] No SQL injection or XSS vulnerabilities
- [ ] Proper authentication/authorization checks

#### Performance
- [ ] No N+1 query patterns
- [ ] Appropriate caching strategies
- [ ] No memory leaks or resource exhaustion risks
- [ ] Efficient algorithms for the use case

#### Testing
- [ ] New code has corresponding tests
- [ ] Edge cases are covered
- [ ] Tests are meaningful, not just coverage padding
- [ ] Integration tests for critical paths

#### Documentation
- [ ] Public APIs are documented
- [ ] Complex logic has explanatory comments
- [ ] README updated if needed
- [ ] Breaking changes documented

#### Style & Conventions
- [ ] Follows project naming conventions
- [ ] Consistent formatting (or auto-formatted)
- [ ] Import organization matches project style
- [ ] File structure follows project patterns

### Step 3: Classify Issues by Severity

Use these severity levels for findings:

| Level | Icon | Description | Action Required |
|-------|------|-------------|-----------------|
| **Critical** | :red_circle: | Security vulnerabilities, data loss risks, crashes | Must fix before merge |
| **Major** | :orange_circle: | Bugs, significant performance issues, missing error handling | Should fix before merge |
| **Minor** | :yellow_circle: | Code style issues, minor improvements, suggestions | Nice to have |
| **Nitpick** | :white_circle: | Personal preferences, optional optimizations | Take or leave |

### Step 4: Generate Review Output

## Output Format

Structure your review as follows:

```markdown
## PR Review Summary

**PR:** #{number} - {title}
**Files Changed:** {count}
**Lines:** +{additions} / -{deletions}
**Risk Level:** Low | Medium | High

---

### Overview

{Brief description of what the PR does and overall assessment}

---

### Findings

#### :red_circle: Critical Issues

1. **{File}:{Line}** - {Issue title}
   - Problem: {Description}
   - Suggestion: {How to fix}
   ```{language}
   {code suggestion if applicable}
   ```

#### :orange_circle: Major Issues

{Same format as above}

#### :yellow_circle: Minor Issues

{Same format as above}

#### :white_circle: Nitpicks

{Same format as above}

---

### Checklist Summary

| Category | Status | Notes |
|----------|--------|-------|
| Code Quality | :white_check_mark: / :x: | {brief note} |
| Security | :white_check_mark: / :x: | {brief note} |
| Performance | :white_check_mark: / :x: | {brief note} |
| Testing | :white_check_mark: / :x: | {brief note} |
| Documentation | :white_check_mark: / :x: | {brief note} |

---

### Recommendation

:white_check_mark: **Approve** - Ready to merge
:arrows_counterclockwise: **Request Changes** - Address critical/major issues
:eyes: **Comment** - Minor suggestions, author discretion
```

## Example Review

```markdown
## PR Review Summary

**PR:** #142 - Add user authentication middleware
**Files Changed:** 5
**Lines:** +234 / -12
**Risk Level:** High (security-related changes)

---

### Overview

This PR adds JWT-based authentication middleware. The implementation is solid overall, but there are security concerns with token handling that should be addressed before merge.

---

### Findings

#### :red_circle: Critical Issues

1. **src/middleware/auth.js:45** - Token stored in localStorage
   - Problem: Storing JWT in localStorage exposes it to XSS attacks
   - Suggestion: Use httpOnly cookies for token storage
   ```javascript
   // Instead of:
   localStorage.setItem('token', jwt);

   // Use httpOnly cookie:
   res.cookie('token', jwt, { httpOnly: true, secure: true, sameSite: 'strict' });
   ```

#### :orange_circle: Major Issues

1. **src/middleware/auth.js:23** - Missing token expiration validation
   - Problem: Expired tokens are not being rejected
   - Suggestion: Add expiration check in verification logic

---

### Recommendation

:arrows_counterclockwise: **Request Changes** - Please address the token storage security issue before merge.
```

## Tips for Effective Reviews

1. **Be constructive** - Suggest solutions, not just problems
2. **Explain the why** - Help authors learn from feedback
3. **Prioritize** - Focus on critical issues first
4. **Acknowledge good work** - Mention well-written code too
5. **Ask questions** - If something is unclear, ask rather than assume
