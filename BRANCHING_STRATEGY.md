# Branching Strategy

## Overview
This project follows a Git Flow branching strategy with `develop` as the main integration branch and `main` for production releases.

## Branch Structure

### Main Branches

#### `main`
- **Purpose:** Production-ready code
- **Protection:** Protected branch, requires PR approval
- **Updates:** Only merged from `develop` after thorough testing
- **Deployment:** Auto-deploys to production (if configured)
- **Tags:** All releases are tagged here (v1.0.0, v1.1.0, etc.)

#### `develop`
- **Purpose:** Integration branch for features
- **Protection:** Protected branch, requires PR approval
- **Updates:** Feature branches merge here
- **Testing:** All features tested together here
- **Status:** Should always be in a working state

### Supporting Branches

#### Feature Branches
- **Naming:** `feature/<feature-name>`
- **Example:** `feature/theme-and-settings`, `feature/user-profile`
- **Created from:** `develop`
- **Merged into:** `develop`
- **Lifetime:** Until feature is complete and merged
- **Purpose:** Develop new features

#### Bugfix Branches
- **Naming:** `bugfix/<bug-name>`
- **Example:** `bugfix/login-error`, `bugfix/ui-alignment`
- **Created from:** `develop`
- **Merged into:** `develop`
- **Purpose:** Fix bugs found in development

#### Hotfix Branches
- **Naming:** `hotfix/<issue-name>`
- **Example:** `hotfix/critical-crash`, `hotfix/security-patch`
- **Created from:** `main`
- **Merged into:** Both `main` and `develop`
- **Purpose:** Emergency fixes for production issues

#### Release Branches
- **Naming:** `release/<version>`
- **Example:** `release/1.0.0`, `release/1.1.0`
- **Created from:** `develop`
- **Merged into:** Both `main` and `develop`
- **Purpose:** Prepare for production release

## Workflow

### 1. Creating a New Feature

```bash
# Make sure develop is up to date
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/my-new-feature

# Work on your feature
git add .
git commit -m "feat: Add my new feature"

# Push to remote
git push -u origin feature/my-new-feature

# Create PR to develop (not main!)
# Use GitHub to create PR with base: develop
```

### 2. Merging a Feature

```bash
# After PR approval, feature is merged to develop
# Delete feature branch
git branch -d feature/my-new-feature
git push origin --delete feature/my-new-feature
```

### 3. Creating a Release

```bash
# Create release branch from develop
git checkout develop
git pull origin develop
git checkout -b release/1.0.0

# Update version numbers, changelog, etc.
git add .
git commit -m "chore: Prepare release 1.0.0"

# Push release branch
git push -u origin release/1.0.0

# Create PR to main
# After testing, merge to main and tag
git checkout main
git merge --no-ff release/1.0.0
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main --tags

# Also merge back to develop
git checkout develop
git merge --no-ff release/1.0.0
git push origin develop

# Delete release branch
git branch -d release/1.0.0
git push origin --delete release/1.0.0
```

### 4. Hotfix Workflow

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# Fix the issue
git add .
git commit -m "fix: Critical bug in production"

# Push and create PR to main
git push -u origin hotfix/critical-bug

# After merge to main, also merge to develop
git checkout develop
git merge --no-ff hotfix/critical-bug
git push origin develop

# Tag the hotfix
git checkout main
git tag -a v1.0.1 -m "Hotfix version 1.0.1"
git push origin main --tags
```

## Pull Request Guidelines

### Base Branch
**IMPORTANT:** All feature and bugfix branches should create PRs with **`develop`** as the base branch, NOT `main`.

### PR Title Format
Follow conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation only
- `style:` Code style/formatting
- `refactor:` Code refactoring
- `perf:` Performance improvement
- `test:` Adding tests
- `chore:` Maintenance tasks

**Examples:**
- `feat: Add dark theme support`
- `fix: Resolve login authentication error`
- `docs: Update API documentation`

### PR Requirements
- [ ] PR targets `develop` branch (not `main`)
- [ ] All tests pass
- [ ] Flutter analyze shows zero issues
- [ ] Code has been self-reviewed
- [ ] Documentation updated if needed
- [ ] Descriptive title and description
- [ ] Screenshots/recordings for UI changes

## Branch Protection Rules

### For `main` Branch
- Require pull request reviews before merging
- Require status checks to pass
- Require branches to be up to date before merging
- Do not allow force pushes
- Do not allow deletions

### For `develop` Branch
- Require pull request reviews before merging
- Require status checks to pass
- Require branches to be up to date before merging
- Do not allow force pushes
- Do not allow deletions

## Best Practices

### ✅ Do
- Always create feature branches from `develop`
- Keep commits atomic and focused
- Write descriptive commit messages
- Pull latest `develop` before creating new branch
- Delete branches after merging
- Use PR templates
- Request reviews before merging
- Test thoroughly before creating PR

### ❌ Don't
- Don't commit directly to `main` or `develop`
- Don't create PRs to `main` from feature branches
- Don't force push to shared branches
- Don't merge without review
- Don't leave stale branches
- Don't ignore merge conflicts
- Don't skip testing

## Quick Reference

| Action | Command |
|--------|---------|
| Create feature | `git checkout -b feature/name` |
| Create bugfix | `git checkout -b bugfix/name` |
| Create hotfix | `git checkout -b hotfix/name` (from main) |
| Update branch | `git pull origin develop` |
| Push branch | `git push -u origin branch-name` |
| Delete local branch | `git branch -d branch-name` |
| Delete remote branch | `git push origin --delete branch-name` |

## Current Branches

### Active Branches
- `main` - Production code
- `develop` - Development integration (DEFAULT for PRs)
- `feature/auth-with-logging-and-snackbar` - Authentication feature
- `feature/theme-and-settings` - Theme system

### Branch Status
| Branch | Status | Next Action |
|--------|--------|-------------|
| main | ✅ Stable | Accept releases only |
| develop | ✅ Ready | Accept feature PRs |
| feature/auth-with-logging-and-snackbar | 🔄 In Review | Merge to develop |
| feature/theme-and-settings | 🔄 In Review | Merge to develop |

## Updating Existing PRs

If you have existing PRs targeting `main`, update them to target `develop`:

**Via GitHub:**
1. Go to the PR page
2. Click "Edit" next to the title
3. Change base branch from `main` to `develop`
4. Save changes

**Via Git (if needed):**
```bash
# Make sure your feature branch is up to date with develop
git checkout feature/my-feature
git fetch origin
git rebase origin/develop

# Force push if needed (only for unmerged branches!)
git push --force-with-lease
```

## Release Workflow

1. **Feature Development** → Merge to `develop`
2. **Testing** → Test features in `develop`
3. **Release Preparation** → Create `release/x.x.x` branch
4. **Final Testing** → Test release branch
5. **Deploy** → Merge to `main`, tag version
6. **Sync** → Merge back to `develop`

## Getting Help

If you're unsure about:
- Which branch to create from → Use `develop`
- Which branch to merge to → Use `develop`
- How to handle conflicts → Ask for help before merging
- Release process → Coordinate with team lead

## Summary

**Remember:** 
- 🌟 **`develop` is the default base** for all feature and bugfix PRs
- 🚀 **`main` is production** and only accepts releases
- 🔧 **Feature branches** are temporary and should be deleted after merge
- ✅ **Always test** before creating a PR
- 📝 **Document changes** in PR descriptions

This strategy ensures code quality, easy collaboration, and stable releases!
