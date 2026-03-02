# Ziro Command-Line Interface

Zero-friction spec-driven development directly from your shell, with human-in-the-loop automation.

## Installation

### 1. Install Ziro CLI

```bash
# Install via your preferred method
# (installation instructions to be added)
```

### 2. Verify Installation

```bash
ziro --help
```

## Usage

### Initialize a Repository

```bash
cd my-project
ziro init                    # Prompts to choose template
ziro init front-end          # Initialize with front-end templates directly
ziro init back-end           # Initialize with back-end templates
```

If you specify an invalid template:
```bash
ziro init invalid-template
# ❌ Template 'invalid-template' not found
#
# 📦 Select template for Ziro initialization
#
#   1) front-end
#   2) back-end
#
# Select template (1-2):
```

Creates `.ziro/` directory with:
- `specs/` - Feature specifications
- `templates/` - Spec templates
- Documentation

### Gather Requirements

```bash
# Create or continue gathering requirements (transparent - no create/edit distinction)
ziro req tower-search
```

Creates feature directory and `requirements.md`:
- Automatically creates if missing (starts gathering)
- Continues if exists and not approved (refines existing)
- Errors if approved (use --force to override)

### Create Architectural Design

```bash
# Create or refine design (requires approved requirements)
ziro plan tower-search

# Force update even if already approved
ziro plan tower-search --force
```

Requirements must be approved first. Creates or continues `design.md`:
- Automatically creates if missing (starts architectural design)
- Continues if exists and not approved (refines existing)
- Errors if approved (use --force to override)

### Generate Implementation Tasks

```bash
# Create or refine tasks (requires approved design)
ziro step tower-search

# Force update even if already approved
ziro step tower-search --force
```

Design must be approved first. Creates or continues `tasks.md`:
- Automatically creates if missing (starts task generation)
- Continues if exists and not approved (refines existing)
- Errors if approved (use --force to override)

### List All Features

```bash
ziro ls

# Output:
# 📋 Ziro Features
#
#   • tower-search           [R:✓ D:◐ T:❌] 0/25
#   • user-auth              [R:✓ D:✓ T:✓]  3/15
#
# Legend: R=Requirements D=Design T=Tasks
#         ✓=Approved  ◐=Draft  ❌=Not Started
```

### Build / Implement Feature

```bash
# Start "The Wiggum Loop" (implementation) from task 1.1
ziro ralph start tower-search

# Resume from last incomplete task
ziro go tower-search

# Check implementation status
ziro status tower-search

# Stop/pause implementation
ziro ralph stop tower-search
```

## The Wiggum Loop

When you run `ziro ralph start [feature]`:

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

**"I'm helping!"** - The Wiggum Loop keeps you in control while Claude does the heavy lifting.

## Tab Completion

The CLI includes completion:

```bash
ziro <TAB>                     # Shows: init, req, plan, step, ralph, go, status, ls, help
ziro req <TAB>                 # Shows existing feature names and --force
ziro plan <TAB>                # Shows existing feature names and --force
ziro step <TAB>                # Shows existing feature names and --force
ziro ralph <TAB>               # Shows: start, stop
ziro ralph start <TAB>         # Shows feature names
ziro go <TAB>                  # Shows feature names
ziro status <TAB>              # Shows feature names
```

## Commands Reference

```bash
# Initialization
ziro init [template]            # Initialize repo (zero-config)
                                # template: front-end (default), back-end

# Requirements Phase (Zero ambiguity)
ziro req [name] [--force]       # Gather/refine requirements (transparent create/continue)

# Design Phase (The Kiro path)
ziro plan [name] [--force]      # Create/refine design (requires approved requirements)

# Tasks Phase (Zero wasted effort)
ziro step [name] [--force]      # Generate/refine tasks (requires approved design)

# Implementation (The Wiggum Loop)
ziro ralph start [name]         # "I'm helping!" - Start implementation
ziro ralph stop [name]          # Pause implementation
ziro go [name]                  # Resume from last incomplete task
ziro status [name]              # Show implementation progress

# Utility
ziro ls                                 # List all feature specs and status
ziro help                               # Show help
```

**Note**: Use `--force` to skip approval checks (e.g., edit an approved phase).

## Workflow Example

```bash
# 1. Initialize project
cd my-sveltekit-app
ziro init                        # Select template when prompted
# Or specify directly:
ziro init front-end

# 2. Gather requirements (transparently creates and continues)
ziro req tower-search
# ... Claude guides you through gathering requirements
# ... get stakeholder approval
# ... mark as Approved in requirements.md

# 3. Create architectural design (transparently creates and continues)
ziro plan tower-search
# ... Claude guides you through technical design
# ... get tech lead approval
# ... mark as Approved in design.md

# 4. Generate implementation tasks (transparently creates and continues)
ziro step tower-search
# ... Claude breaks design into implementation tasks
# ... get team approval
# ... mark as Approved in tasks.md

# 5. Start "The Wiggum Loop"
ziro ralph start tower-search
# ... Claude implements task 1.1
# ... You review and approve
# ... Claude implements task 1.2
# ... You review and approve
# ... (repeat for all tasks)
# ... Feature complete!

# 6. Check progress
ziro ls                          # Shows: tower-search [R:✓ D:✓ T:✓] 25/25

# 7. Resume later if needed
ziro go tower-search             # Pick up where you left off

# 8. Update specs with --force if needed
ziro req tower-search --force    # Override approval to refine requirements
ziro plan tower-search --force   # Override approval to refine design
```

## Features

- **Zero-Config** - `ziro init` in any repo to get started
- **Template Management** - Front-end templates built-in, back-end coming
- **Spec Lifecycle** - Create, edit, refine requirements, design, tasks
- **Claude Integration** - Gather requirements, design architecture, generate tasks
- **The Wiggum Loop** - Human-in-the-loop implementation automation
- **CLI Completion** - Full shell completion support
- **Progress Tracking** - See spec phases and implementation status at a glance
- **Session Continuity** - Resume with `ziro go` where you left off

## How It Works with Claude

When you run `ziro ralph start`, Ziro:

1. Reads your feature specs (requirements, design, tasks)
2. Sends task description to Claude with full context
3. Claude implements the task (creates files in `./src/`)
4. Claude updates feature memory (`.context.md`) with what it did
5. Ziro shows you what was implemented
6. You approve or request changes
7. When approved, task marked complete, memory updated
8. Moves to next task

**Key**: Ziro orchestrates the spec-driven process. Claude follows the specs you've already written. You stay in control.

## Requirements

- **Claude Code CLI** in PATH (for implementation)
  - Install: https://claude.com/claude-code
- **Shell support**: Zsh, Bash, or your preferred shell
- **Git** for version control

## Troubleshooting

### CLI not found

```bash
# Verify ziro command is installed
which ziro

# If not found, install Ziro:
# (installation instructions to be added)
```

### Tab completion not working

```bash
# Reload your shell
exec zsh  # or exec bash, etc.
```

### Implementation fails with "Claude Code CLI not found"

```bash
# Ensure claude command is in PATH
which claude

# If not found, install Claude Code:
# https://claude.com/claude-code
```

## Tips

- **Keep specs focused** - One feature per spec directory
- **Complete phases before the loop** - Requirements → Design → Tasks approval
- **Review implementation** - Use `ziro status` to check progress, don't auto-approve
- **Use `.context.md`** - Track decisions and blockers for next developer
- **Commit frequently** - After each approved task, commit to git
- **Resume with `ziro go`** - Pick up where you left off anytime

## Future Enhancements

- [ ] Feedback loop - resubmit tasks with corrections
- [ ] Implementation editing - edit code before approval
- [ ] Back-end templates
- [ ] Database schema templates
- [ ] API design templates
- [ ] Integration with GitHub for PR creation
- [ ] Memory context for cross-project continuity

## Questions?

See main repo: https://github.com/Knifeforkspoon/ziro

---

*Ziro: Zero-friction spec-driven development with "The Wiggum Loop"*
