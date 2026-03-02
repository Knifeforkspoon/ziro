# Ziro - Zero-Friction Spec-Driven Development

Ziro is a zero-friction spec-driven development system for building features systematically using structured templates and Claude Code. It's adapted from Amazon's Kiro system and customized for modern web applications.

## What is Ziro?

Ziro guides you through three phases when building features:
1. **Requirements** (req) - What needs to be built (user stories, acceptance criteria)
2. **Design** (plan) - How it will be built (architecture, components, data models)
3. **Tasks** (step) - Step-by-step implementation plan (actionable coding checklist)

Instead of jumping straight into code, you plan everything out first. Each phase requires explicit approval before moving to the next.

## Directory Structure

```
.ziro/
├── specs/                              # Feature specifications
│   └── {feature-name}/                 # Individual feature folder
│       ├── requirements.md             # What needs to be built
│       ├── design.md                   # How it will be built
│       └── tasks.md                    # Step-by-step implementation
└── templates/
    ├── front-end-templates/            # Frontend development templates
    │   ├── requirements_template.md    # Requirements template
    │   ├── design_template.md          # Design template (SvelteKit/Svelte focused)
    │   └── tasks_template.md           # Tasks template
    └── back-end-templates/             # Backend templates (future)
```

## Core Philosophy

- **Structured**: Clear phases with explicit approvals
- **Traceable**: Every task links back to requirements
- **Incremental**: Build features in small, testable steps
- **Documented**: All decisions and architecture documented upfront

## The Workflow

### Phase 1: Requirements
- Document user stories: "As a [role], I want [feature], so that [benefit]"
- Write acceptance criteria using EARS format: "WHEN [condition], THEN [behavior]"
- Define technical architecture approach
- Iterate until approved

### Phase 2: Design
- Create technical design addressing all requirements
- Define components, interfaces, and data models
- Plan error handling and testing strategy
- Iterate until approved

### Phase 3: Tasks
- Break design into numbered, actionable coding tasks
- Each task specifies deliverables and requirements
- Tasks organized into logical phases
- Ready for incremental implementation

### Phase 4: Implementation
- Execute tasks one at a time
- Stop for review between tasks
- Update specs if changes needed
- Validate against requirements

## Front-End Templates

The front-end templates are customized for **SvelteKit** projects with the following tech stack:
- **Svelte 5** - Component framework
- **SvelteKit** - Full-stack framework with server functions
- **MapLibre GL** - Interactive mapping
- **Auth.js + Keycloak** - Authentication
- **Tailwind CSS v4** - Styling
- **Flowbite Svelte** - UI components
- **Zod** - Validation
- **Vitest** - Testing

## CLI Commands

Ziro provides a streamlined CLI for spec-driven development:

```bash
ziro init [template]      # Initialize ziro in current repo
ziro req [create|edit]    # Gather/refine requirements
ziro plan [create|edit]   # Architectural design phase
ziro step [create|edit]   # Generate implementation tasks
ziro ralph [start|stop]   # Start/stop "The Wiggum Loop" (implementation)
ziro go [name]            # Resume implementation from last incomplete task
ziro status [name]        # Show current progress
ziro ls                   # List all feature specs and their status
```

See the **[Plugin Documentation](./plugin/PLUGIN_README.md)** for detailed CLI usage and examples.

## Documentation

For detailed information about Ziro, see:

- **[System Overview](./docs/ZIRO_SYSTEM_OVERVIEW.md)** - Complete system architecture, templates, and workflows
- **[How Kiro Works](./docs/how_kiro_works.md)** - Understanding the Kiro methodology that Ziro is based on
- **[Claude Code + Kiro Integration](./docs/claude_agnostic.md)** - Guide for integrating Kiro system into your project's CLAUDE.md

---

*Ziro: Zero-friction spec-driven development through structured templates and Claude Code.*
