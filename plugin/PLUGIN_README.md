# Shakapawd Oh-My-Zsh Plugin

Integrate Shakapawd spec-driven development into your shell for seamless feature development with human-in-the-loop automation.

## Installation

### 1. Clone the Plugin

```bash
git clone https://github.com/shakalabs/shakapawd.git \
    ~/.oh-my-zsh/custom/plugins/shakapawd
```

### 2. Add to `.zshrc`

```bash
# In ~/.zshrc, add 'shakapawd' to your plugins list:
plugins=(... shakapawd)
```

### 3. Reload Shell

```bash
source ~/.zshrc
```

## Usage

### Initialize a Repository

```bash
cd my-project
shakapawd init                    # Prompts to choose template
shakapawd init front-end          # Initialize with front-end templates directly
shakapawd init back-end           # Initialize with back-end templates
```

If you specify an invalid template:
```bash
shakapawd init invalid-template
# ❌ Template 'invalid-template' not found
#
# 📦 Select template for Shakapawd initialization
#
#   1) front-end
#   2) back-end
#
# Select template (1-2):
```

Creates `.shakapawed/` directory with:
- `specs/` - Feature specifications
- `templates/` - Spec templates
- Documentation

### Create a Feature

```bash
shakapawd feature create tower-search
```

Creates feature directory with:
- `requirements.md` - What to build
- `design.md` - How to build it
- `tasks.md` - Implementation tasks (Claude updates this with checkmarks)

### Edit Feature Specs

```bash
# Edit requirements
shakapawd feature edit tower-search    # Opens menu to choose file

# Or directly edit specific files
shakapawd design tower-search          # Edit design.md
shakapawd tasks tower-search           # Edit tasks.md
```

### List All Features

```bash
shakapawd list

# Output:
# 📋 Shakapawd Features
#
#   • tower-search           [R:✓ D:◐ T:❌] 0/25
#   • user-auth              [R:✓ D:✓ T:✓]  3/15
#
# Legend: R=Requirements D=Design T=Tasks
#         ✓=Approved  ◐=Draft  ❌=Not Started
```

### Build / Implement Feature

```bash
# Start implementation from task 1.1
shakapawd build start tower-search

# Resume from last incomplete task
shakapawd build resume tower-search

# Check implementation status
shakapawd build status tower-search

# Stop/pause implementation
shakapawd build stop tower-search
```

## Build Process

When you run `shakapawd build start [feature]`:

1. **Reads** all spec files (requirements.md, design.md, tasks.md)
2. **For each incomplete task**:
   - Sends task to Claude with full feature context
   - Claude implements the task in `./src/`
   - Claude updates `.context.md` with what it did
   - Shows results to you
   - **Pauses for approval** - you can:
     - ✓ Approve (mark task complete, continue)
     - ✗ Reject (get feedback, iterate)
     - Edit (modify implementation)
   - Updates `tasks.md` checkbox
   - Moves to next task
3. **Completes** when all tasks done

## Tab Completion

The plugin includes zsh completion:

```bash
shakapawd <TAB>                  # Shows: init, feature, design, tasks, build, list, help
shakapawd feature <TAB>          # Shows: create, edit, delete
shakapawd feature create <TAB>   # Shows existing feature names
shakapawd build start <TAB>      # Shows feature names
```

## Commands Reference

```bash
# Initialization
shakapawd init [template]                   # Initialize repo
                                            # template: front-end (default), back-end

# Feature Management
shakapawd feature create [name]             # Create new feature
shakapawd feature edit [name]               # Edit feature (choose file)
shakapawd feature delete [name]             # Delete feature

# Spec Editing
shakapawd design [name]                     # Edit design.md
shakapawd tasks [name]                      # Edit tasks.md

# Implementation
shakapawd build start [name]                # Start from task 1.1
shakapawd build resume [name]               # Resume from last task
shakapawd build stop [name]                 # Pause implementation
shakapawd build status [name]               # Show progress

# Utility
shakapawd list                              # List all features
shakapawd help                              # Show help
```

## Workflow Example

```bash
# 1. Initialize project
cd my-sveltekit-app
shakapawd init                   # Select template when prompted
# Or specify directly:
shakapawd init front-end

# 2. Create feature
shakapawd feature create tower-search

# 3. Write requirements
shakapawd design tower-search    # Opens editor for requirements.md
# ... fill in user stories, acceptance criteria, etc.
# ... get stakeholder approval
# ... mark as Approved in requirements.md

# 4. Write design
shakapawd design tower-search    # Opens editor for design.md
# ... write technical design, architecture, components
# ... get tech lead approval
# ... mark as Approved in design.md

# 5. Write tasks
shakapawd tasks tower-search     # Opens editor for tasks.md
# ... break into implementation tasks
# ... get team approval
# ... mark as Approved in tasks.md

# 6. Implement
shakapawd build start tower-search
# ... Claude implements task 1.1
# ... You review and approve
# ... Claude implements task 1.2
# ... You review and approve
# ... (repeat for all tasks)
# ... Feature complete!

# 7. Check progress
shakapawd list                   # Shows: tower-search [R:✓ D:✓ T:✓] 25/25
```

## Features

✅ **Easy Initialization** - `shakapawd init` in any repo
✅ **Template Management** - Front-end templates built-in, back-end coming
✅ **Feature Lifecycle** - Create, edit, delete features
✅ **Spec Editing** - Direct access to requirements, design, tasks
✅ **Automated Build** - Human-in-the-loop implementation with Claude
✅ **Tab Completion** - Full zsh completion support
✅ **Progress Tracking** - See spec phases and implementation status
✅ **Session Continuity** - Resume builds where you left off

## How It Works with Claude

When you run `shakapawd build`, the plugin:

1. Reads your feature specs (requirements, design, tasks)
2. Sends task description to Claude with full context
3. Claude implements the task (creates files in `./src/`)
4. Claude updates feature memory (`.context.md`) with what it did
5. Plugin shows you what was implemented
6. You approve or request changes
7. When approved, task marked complete, memory updated
8. Moves to next task

**Key**: The plugin orchestrates the Shakapawd process. Claude follows the specs you've already written.

## Requirements

- **Oh-My-Zsh** installed
- **Claude Code CLI** in PATH (for implementation)
  - Install: https://claude.com/claude-code
- **Zsh shell**

## Troubleshooting

### Plugin not loading

```bash
# Check if plugin directory exists
ls ~/.oh-my-zsh/custom/plugins/shakapawd

# Verify in ~/.zshrc
grep shakapawd ~/.zshrc

# Reload
source ~/.zshrc
```

### Tab completion not working

```bash
# Reload zsh
exec zsh
```

### Build fails with "Claude Code CLI not found"

```bash
# Ensure claude command is in PATH
which claude

# If not found, install Claude Code:
# https://claude.com/claude-code
```

## Tips

- **Keep specs focused** - One feature per spec directory
- **Complete phases before building** - Requirements → Design → Tasks approval
- **Review implementation** - Don't auto-approve, check Claude's work
- **Use `.context.md`** - Track decisions and blockers for next developer
- **Commit frequently** - After each approved task, commit to git

## Future Enhancements

- [ ] Feedback loop - resubmit tasks with corrections
- [ ] Implementation editing - edit code before approval
- [ ] Back-end templates
- [ ] Database schema templates
- [ ] API design templates
- [ ] Integration with GitHub for PR creation
- [ ] Memory context for cross-project continuity

## Questions?

See main repo: https://github.com/shakalabs/shakapawd

---

*Shakapawd Plugin: Spec-driven development automation for Oh-My-Zsh*
