# Task Completion Guidelines

## After Editing Lua Files (Neovim)
1. **Format the code**:
   ```bash
   stylua nvim/
   # Or for specific files:
   stylua <file.lua>
   ```

2. **Validate syntax** (optional):
   ```bash
   lua -c nvim/init.lua
   # Or for custom files:
   lua -c nvim/lua/custom/<file>.lua
   ```

3. **Test in Neovim** (if applicable):
   - Restart Neovim to test changes
   - Run `:checkhealth` if changing plugin configs
   - Check for any errors in the command line

## After Editing Shell Scripts
1. **Make executable** (if new file):
   ```bash
   chmod +x scripts/<script>.sh
   ```

2. **Check syntax** (optional):
   ```bash
   bash -n <script>.sh    # For bash scripts
   zsh -n <script>.zsh    # For zsh scripts
   ```

3. **Test the script**:
   - Run the script to ensure it works as expected

## After Editing Hyprland Configs
1. **Reload Hyprland**:
   ```bash
   hyprctl reload
   # Or restart Hyprland session if major changes
   ```

2. **Verify changes**:
   - Check that the configuration applied correctly
   - Look for any error messages in Hyprland logs

## After Editing Configuration Files
1. **Validate formatting**:
   - Ensure .editorconfig rules are followed
   - Check for trailing whitespace
   - Verify proper indentation

2. **Test the application**:
   - Restart the affected application
   - Verify configuration loaded correctly

## Git Workflow
After making any changes:
1. **Check what changed**:
   ```bash
   git status
   git diff
   ```

2. **Stage changes**:
   ```bash
   git add <files>
   ```

3. **Commit with descriptive message**:
   ```bash
   git commit -m "Brief description of changes"
   ```

4. **Push to remote**:
   ```bash
   git push
   ```

## No Automated Testing
- This is a dotfiles repository without automated test suites
- Testing is manual and application-specific
- Focus on:
  - Syntax validation where applicable
  - Manual testing of changed configurations
  - Ensuring changes don't break existing setups

## No Linting (Except StyLua)
- Only Lua files have automated formatting via StyLua
- Other files rely on .editorconfig settings in your editor
- Manual code review is the primary quality control method

## Deployment
- Changes take effect when configurations are reloaded/applications restart
- No build or deployment process required
- Symlinks via GNU Stow make changes immediately available
