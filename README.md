# Shakapawd - Spec-Driven Development System

Shakapawd is a spec-driven development system for building features systematically using structured templates and Claude Code. It's adapted from Amazon's Kiro system and customized for modern web applications.

## What is Shakapawd?

Shakapawd guides you through three phases when building features:
1. **Requirements** - What needs to be built (user stories, acceptance criteria)
2. **Design** - How it will be built (architecture, components, data models)
3. **Tasks** - Step-by-step implementation plan (actionable coding checklist)

Instead of jumping straight into code, you plan everything out first. Each phase requires explicit approval before moving to the next.

## Directory Structure

```
.shakapawed/
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
- Include architecture diagrams
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

### Design Template Sections

The front-end design template includes:
1. **Architecture** - High-level system design
2. **Components** - UI component structure and interfaces
3. **Data Flow** - SvelteKit remote functions → services → API client pattern
4. **State Management** - Svelte stores and context approach
5. **Authentication** - Auth.js integration with Keycloak
6. **API Integration** - Orval-generated client usage
7. **Forms & Validation** - Superforms + Zod patterns
8. **Mapping & Geolocation** - MapLibre GL and Turf.js integration
9. **Testing** - Client and server test strategies
10. **Error Handling** - Component boundaries and error recovery
11. **Performance** - Optimization strategies for SvelteKit

## Using Shakapawd

### Starting a New Feature

1. **Create feature directory**: `.shakapawed/specs/{feature-name}/`
2. **Copy templates**: From `.shakapawed/templates/front-end-templates/`
3. **Fill requirements.md** - Document what needs to be built
4. **Get approval** - User reviews and approves requirements
5. **Fill design.md** - Create technical architecture
6. **Get approval** - User reviews and approves design
7. **Fill tasks.md** - Break into actionable tasks
8. **Get approval** - User reviews and approves tasks
9. **Implement** - Execute tasks with Claude Code

### Approval Process

Each document needs explicit approval before proceeding:
- ✅ Requirements approved → start design
- ✅ Design approved → start tasks
- ✅ Tasks approved → start implementation

No skipping phases. This ensures quality and clarity.

## Template Customization

### For Your Project

1. Review the templates in `.shakapawed/templates/front-end-templates/`
2. Customize the tech stack references to match your project
3. Update examples with your patterns and conventions
4. Keep templates in sync with actual implementation patterns

### For New Stack

When adding backend templates or other stacks:
1. Create new directory: `.shakapawed/templates/{stack-templates}/`
2. Copy and customize the base templates
3. Reference your specific tech stack and patterns
4. Document any custom behaviors

## Why This Works

Shakapawd works because:
- **Clear requirements** validate against user needs
- **Detailed design** prevents rework during implementation
- **Specific tasks** keep implementation focused
- **Traceability** connects code back to requirements
- **Structured phases** reduce decision fatigue

Claude Code can work incrementally and systematically when given:
- Complete requirements upfront
- Detailed technical design
- Specific, actionable tasks
- Clear acceptance criteria

## Documentation Files

- **requirements_template.md** - Template for documenting what to build
- **design_template.md** - Template for technical architecture (SvelteKit-focused)
- **tasks_template.md** - Template for breaking design into tasks

## Getting Started

1. Read this README
2. Check out `.shakapawed/templates/front-end-templates/`
3. Create your first feature in `.shakapawed/specs/{feature-name}/`
4. Copy templates and fill them out
5. Use Claude Code to implement with `bun --bun run` commands

---

*Shakapawd: Systematic feature development through structured specs and templates.*
