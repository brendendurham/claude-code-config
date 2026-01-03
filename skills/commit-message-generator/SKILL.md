---
name: commit-message-generator
description: Generate conventional commit messages from git diff. Triggers: generate commit message, write commit, conventional commit, commit message, what should I commit, describe my changes
---

# Commit Message Generator Skill

Generate well-structured conventional commit messages by analyzing git diffs.

## When to Use

- User asks to "generate commit message" or "write commit"
- User wants help describing their changes
- User asks for conventional commit format

## Conventional Commit Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type Prefixes

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(auth): add OAuth2 login` |
| `fix` | Bug fix | `fix(api): handle null response` |
| `docs` | Documentation only | `docs(readme): update install steps` |
| `style` | Formatting, no code change | `style(lint): fix indentation` |
| `refactor` | Code change, no feature/fix | `refactor(utils): simplify date parsing` |
| `perf` | Performance improvement | `perf(db): add query indexing` |
| `test` | Adding/fixing tests | `test(auth): add login unit tests` |
| `build` | Build system changes | `build(webpack): update config` |
| `ci` | CI configuration | `ci(github): add deploy workflow` |
| `chore` | Maintenance tasks | `chore(deps): update dependencies` |
| `revert` | Revert previous commit | `revert: undo feature X` |

### Scope Detection

Analyze the changed files to determine scope:

1. **Directory-based**: `src/components/Button.tsx` -> scope: `button` or `components`
2. **Feature-based**: Changes to auth files -> scope: `auth`
3. **Layer-based**: API changes -> scope: `api`
4. **Multiple scopes**: Use comma separation `(auth,api)` or omit scope for broad changes

Common scope patterns:
- `api`, `ui`, `db`, `auth`, `config`
- Component/module names: `navbar`, `checkout`, `user`
- Layer names: `controller`, `service`, `model`

## Generation Process

### Step 1: Analyze the Diff

```bash
# Get staged changes
git diff --cached

# Or get all uncommitted changes
git diff HEAD

# Get file names only for quick overview
git diff --cached --name-only
```

### Step 2: Categorize Changes

1. **Identify primary intent**: Is this a feature, fix, refactor, etc.?
2. **Find the scope**: What area of the codebase is affected?
3. **Note breaking changes**: Any backward incompatible changes?
4. **Check for related issues**: PR numbers, issue references

### Step 3: Craft the Message

#### Subject Line Rules
- Use imperative mood ("add" not "added" or "adds")
- No period at the end
- Max 50 characters (hard limit: 72)
- Lowercase after type prefix
- Be specific but concise

Good examples:
- `feat(cart): add quantity validation on checkout`
- `fix(api): handle timeout on slow connections`
- `refactor(auth): extract token logic to service`

Bad examples:
- `feat: updated stuff` (vague)
- `Fixed the bug.` (wrong format, past tense, period)
- `feat(authentication-module): implemented new OAuth2 authentication flow` (too long)

#### Body Guidelines
- Wrap at 72 characters
- Explain WHAT and WHY, not HOW
- Leave blank line after subject
- Use bullet points for multiple changes

#### Footer Guidelines
- Reference issues: `Fixes #123`, `Closes #456`
- Note breaking changes: `BREAKING CHANGE: description`
- Co-authors: `Co-authored-by: Name <email>`

## Output Format

Provide the commit message in a code block:

```
<type>(<scope>): <subject>

<body explaining the change>

<footer with references>
```

Then explain your reasoning:

**Analysis:**
- Primary change type: {type}
- Detected scope: {scope}
- Files affected: {count}
- Breaking changes: Yes/No

## Examples

### Example 1: Simple Feature

**Diff shows:** New `validateEmail` function added to `utils/validation.js`

```
feat(validation): add email format validation utility

Add validateEmail function that checks for proper email format
using RFC 5322 compliant regex pattern. Returns boolean result.

- Supports international domains
- Handles edge cases like plus addressing
```

### Example 2: Bug Fix with Issue Reference

**Diff shows:** Fix for null pointer in `UserService.getProfile()`

```
fix(user): handle missing profile data gracefully

Return empty profile object instead of throwing when user
profile data is null. This prevents crashes on new accounts
that haven't completed onboarding.

Fixes #234
```

### Example 3: Breaking Change

**Diff shows:** Changed API response format in `api/v2/users`

```
feat(api)!: restructure user response payload

Flatten nested user object and rename fields for consistency
with API design guidelines.

Changes:
- user.profile.name -> user.name
- user.profile.email -> user.email
- user.settings.* -> user.preferences.*

BREAKING CHANGE: User API response structure changed.
Clients must update to handle new flat structure.
Migration guide: docs/migrations/user-api-v2.md

Closes #567
```

### Example 4: Multiple Small Changes

**Diff shows:** Various small updates across files

```
chore: update dependencies and fix linting

- Bump eslint to v8.50.0
- Update prettier config for new rules
- Fix auto-fixable lint warnings
- Remove unused imports in 3 files
```

## Tips

1. **One commit, one purpose**: If you struggle to write a concise message, the commit may be too large
2. **Think about git log**: Will this message make sense in 6 months?
3. **Consider reviewers**: The message is for humans, not just history
4. **Use present tense**: "add feature" not "added feature"
5. **Be atomic**: Each commit should be a complete, working change
