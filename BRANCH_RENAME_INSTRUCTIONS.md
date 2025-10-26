# Branch Rename Instructions

## Task: Rename `develop` to `main` and Make it Default

Since branch renaming and changing the default branch require repository administrator permissions, here are the steps to complete this task:

### Option 1: Using GitHub Web Interface (Recommended)

1. **Navigate to Repository Settings**
   - Go to https://github.com/antoinesd/antoinesd.github.io
   - Click on **Settings** tab
   
2. **Rename the Branch**
   - In the left sidebar, click **Branches**
   - Find the "Default branch" section
   - Click the pencil icon next to `develop` (or current default)
   - In the dialog, click **Rename branch**
   - Enter new name: `main`
   - Click **Rename branch** to confirm

3. **Verify Default Branch**
   - The newly renamed `main` branch should now be the default
   - If not, use the dropdown in "Default branch" section to select `main`
   - Click **Update** to save

### Option 2: Using GitHub CLI (from local machine with admin rights)

```bash
# Ensure you're on the develop branch
git checkout develop

# Rename the local branch
git branch -m main

# Delete the old remote branch and push the new one
git push origin -u main
git push origin --delete develop

# Update default branch (requires admin permissions)
gh repo edit --default-branch main
```

### Option 3: Using Git Commands + Manual GitHub Setting

```bash
# Rename local branch
git checkout develop
git branch -m main
git push -u origin main

# Then manually set default branch in GitHub Settings > Branches
```

## Post-Rename Tasks

After renaming the branch:

1. **Update Local Clones**
   - Team members need to run:
     ```bash
     git branch -m develop main
     git fetch origin
     git branch -u origin/main main
     git remote set-head origin -a
     ```

2. **Update CI/CD**
   - The GitHub Actions workflows in this PR are already configured for `main`
   - They will automatically work once the branch is renamed

3. **Update Documentation**
   - Update any references to `develop` branch in README files
   - Update contribution guidelines if they reference `develop`

## Status

- ✅ GitHub Actions workflows created and configured for `main` branch
- ⏳ Branch rename pending (requires admin permissions)
- ⏳ Default branch update pending (requires admin permissions)

## Verification

After completing the rename, verify:
- [ ] `main` branch exists
- [ ] `main` is set as default branch in repository settings
- [ ] Old `develop` branch is deleted
- [ ] GitHub Actions workflows trigger correctly on PRs to `main`
- [ ] Deployment workflow triggers on pushes to `main`
