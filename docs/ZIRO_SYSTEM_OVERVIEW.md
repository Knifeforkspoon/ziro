# Ziro System Overview

Ziro is a zero-friction spec-driven development system built for SvelteKit-based applications. It adapts Amazon's Kiro methodology with customized templates and workflows for systematic feature development.

## System Philosophy

**Zero friction. Zero ambiguity. Zero wasted effort.**

Instead of jumping to code, Ziro guides you through three explicit phases:

1. **Requirements** - What needs to be built (user stories, acceptance criteria)
2. **Design** - How it will be built (architecture, components, data flow)
3. **Tasks** - Step-by-step implementation plan (actionable coding tasks)

Each phase requires explicit approval before moving to the next.

## What You Get

### Complete Spec System

- **3-Phase Workflow** - Requirements → Design → Tasks → Implementation
- **Frontend-Focused Templates** - Customized for SvelteKit and Svelte 5
- **Traceability** - Every task links to requirements
- **Incremental Development** - Build in small, testable pieces
- **Documentation** - Complete guides for using the system

### Directory Structure

```
ziro/
├── README.md                           # System overview
├── ZIRO_SYSTEM_OVERVIEW.md            # This file
├── .ziro/
│   ├── GETTING_STARTED.md             # Quick start guide
│   ├── specs/                         # Feature specifications
│   │   └── {feature-name}/           # Individual features
│   │       ├── requirements.md
│   │       ├── design.md
│   │       └── tasks.md
│   └── templates/
│       ├── FRONTEND_TEMPLATES_GUIDE.md
│       └── front-end-templates/
│           ├── requirements_template_frontend.md
│           ├── design_template_sveltekit.md
│           ├── tasks_template_frontend.md
│           ├── requirements_template.md (generic)
│           ├── design_template.md (generic)
│           └── tasks_template.md (generic)
└── claude_agnostic.md                 # Generic Kiro integration guide
```

## The Three Templates

### Frontend Requirements Template

**File**: `.ziro/templates/front-end-templates/requirements_template_frontend.md`

**Purpose**: Document what needs to be built from user perspective

**Covers**:
- User stories (frontend users, accessibility, mobile)
- EARS acceptance criteria (WHEN → THEN format)
- Feature specifications (components, routes, data ops)
- Technical architecture (data flow, state management)
- Non-functional requirements (performance, accessibility, mobile)
- Dependencies and risks

**Output**: Clear understanding of feature scope and user needs

### SvelteKit Design Template

**File**: `.ziro/templates/front-end-templates/design_template_sveltekit.md`

**Purpose**: Define technical architecture and implementation approach

**Covers**:
- Data flow (Remote Functions → Services → API Client)
- Component architecture (pages, blocks, components)
- File structure and organization
- State management (Svelte stores, context)
- Zod schemas and validation
- Authentication flow (Auth.js + Keycloak)
- Forms (Superforms + Zod)
- Mapping & geolocation (MapLibre GL, Turf.js)
- Error handling strategy
- Testing approach (unit, component, integration)
- Performance and security considerations

**Output**: Technical blueprint for implementation

### Frontend Tasks Template

**File**: `.ziro/templates/front-end-templates/tasks_template_frontend.md`

**Purpose**: Break design into actionable coding tasks

**Covers**:
- 7 implementation phases:
  1. Project Structure & Setup
  2. State Management & Store Setup
  3. Core UI Components
  4. Feature Block Assembly
  5. Testing & Validation
  6. Performance & Optimization
  7. Documentation & Polish

**Format**: Each task has:
- Clear description
- Specific deliverables (files to create)
- Requirement references
- Task dependencies
- Effort estimate

**Output**: Ready-to-implement task checklist

## Tech Stack

Ziro is customized for:

- **SvelteKit 2.x** - Full-stack framework
- **Svelte 5** - Component framework with reactive primitives
- **TypeScript** - Type safety across the stack
- **Tailwind CSS v4** - Utility-first styling
- **Flowbite Svelte** - Pre-built UI components
- **MapLibre GL** - Interactive mapping
- **Auth.js + Keycloak** - OpenID Connect authentication
- **Zod** - Runtime schema validation
- **SvelteKit Superforms** - Progressive form handling
- **Orval** - OpenAPI client code generation
- **Vitest** - Testing framework
- **Bun** - Package manager

## How to Use Ziro

### 1. Read the Documentation

Start with: `.ziro/GETTING_STARTED.md`

This guide walks through the entire process:
- What each phase is
- How to fill out each template
- Approval process
- Tips for success

### 2. Review Template Guide

Read: `.ziro/templates/FRONTEND_TEMPLATES_GUIDE.md`

Explains:
- What each template covers
- When to use each template
- How to customize for your project
- Common patterns and customizations

### 3. Create a New Feature

```bash
mkdir -p .ziro/specs/{feature-name}
```

Copy templates:
```bash
cp .ziro/templates/front-end-templates/requirements_template_frontend.md \
   .ziro/specs/{feature-name}/requirements.md
cp .ziro/templates/front-end-templates/design_template_sveltekit.md \
   .ziro/specs/{feature-name}/design.md
cp .ziro/templates/front-end-templates/tasks_template_frontend.md \
   .ziro/specs/{feature-name}/tasks.md
```

### 4. Phase 1: Requirements

- Fill out `requirements.md`
- Document user stories and acceptance criteria
- Get approval from product owner
- Mark as "Approved"

### 5. Phase 2: Design

- Fill out `design.md`
- Create technical architecture
- Show data flow and components
- Get approval from tech lead
- Mark as "Approved"

### 6. Phase 3: Tasks

- Fill out `tasks.md`
- Create numbered tasks for each phase
- Reference requirements
- Get approval from team
- Mark as "Approved"

### 7. Phase 4: Implementation

- Execute tasks one by one
- Create deliverables
- Write tests
- Run linting: `bun run lint && bun run format`
- Mark tasks complete
- Move to next task

## Key Features

### Structured Phases

Clear progression:
```
Requirements (Draft)
    ↓ feedback
Requirements (Approved) ✓
    ↓
Design (Draft)
    ↓ feedback
Design (Approved) ✓
    ↓
Tasks (Draft)
    ↓ feedback
Tasks (Approved) ✓
    ↓
Implementation
    ↓ incremental
Complete ✓
```

### Requirement Traceability

Every task references requirements:
- Task 1.1 → REQ-01, REQ-02
- Task 3.2 → REQ-05, REQ-06
- Easy to validate implementation against requirements

### Incremental Implementation

7 phases keep implementation focused:
1. Infrastructure (routes, schemas, services)
2. State management
3. UI components
4. Feature assembly
5. Testing
6. Optimization
7. Documentation

Each phase builds on previous phases.

### Complete Documentation

Everything is documented:
- What needs to be built (requirements)
- How to build it (design)
- Step-by-step (tasks)
- Why each decision (references)

## Customization

### For Different Projects

- Different UI libraries? Update component examples
- Different styling? Update CSS approach
- Different state management? Update store patterns
- Different API client? Update API integration sections

### For Team Conventions

- Different file structure? Update paths in examples
- Different naming? Update in code examples
- Different patterns? Document your patterns

### For Special Features

- Map features? Add geospatial sections
- Complex forms? Add form-specific sections
- Real-time data? Add WebSocket sections

See `.ziro/templates/FRONTEND_TEMPLATES_GUIDE.md` for customization examples.

## Benefits

### For Developers

- Clear requirements before coding
- Technical design to follow
- Specific tasks to implement
- Tests built in from the start
- Documentation happens naturally

### For Teams

- Consistent approach across features
- Clear communication via specs
- Traceability from requirements to code
- Less rework through upfront planning
- Knowledge transfer through documentation

### For Products

- Features thoroughly planned before coding
- Fewer surprises during development
- Clear acceptance criteria
- Measurable success criteria
- Documented architecture

## Quick Commands

```bash
# Start development server
bun run dev

# Build for production
bun run build

# Run tests
bun run test
bun run test:unit
bun run test:browser

# Code quality
bun run lint
bun run format
bun run type-check

# API (regenerate from OpenAPI)
bun run refresh-api-client
```

## File Locations

- **Features**: `.ziro/specs/{feature-name}/`
- **Frontend Templates**: `.ziro/templates/front-end-templates/`
- **Getting Started**: `.ziro/GETTING_STARTED.md`
- **Template Guide**: `.ziro/templates/FRONTEND_TEMPLATES_GUIDE.md`
- **This Overview**: `ZIRO_SYSTEM_OVERVIEW.md`
- **Main README**: `README.md`

## Next Steps

1. **Read**: `.ziro/GETTING_STARTED.md` (5 min read)
2. **Understand**: `.ziro/templates/FRONTEND_TEMPLATES_GUIDE.md` (10 min read)
3. **Create**: First feature in `.ziro/specs/{feature-name}/`
4. **Follow**: Phase 1 → Phase 2 → Phase 3 → The Wiggum Loop

## Example Feature Spec

After creating a feature, structure looks like:

```
.ziro/specs/tower-search/
├── requirements.md  ← What to build
├── design.md       ← How to build it
└── tasks.md        ← Step by step implementation
```

Then implementation creates:

```
src/
├── routes/towers/
│   ├── +page.svelte
│   └── +page.ts
├── lib/
│   ├── blocks/TowerSearch.svelte
│   ├── components/
│   │   ├── TowerList.svelte
│   │   ├── TowerFilters.svelte
│   │   ├── TowerDetail.svelte
│   │   └── [...more components]
│   ├── api/tower.remote.ts
│   ├── services/tower.service.ts
│   ├── stores/tower.store.ts
│   ├── schemas/tower.schema.ts
│   └── utils/tower.utils.ts
```

## System Status

✅ **Core System**
- 3-phase workflow established
- Requirements template (frontend)
- Design template (SvelteKit-specific)
- Tasks template (frontend)

✅ **Documentation**
- Getting started guide
- Frontend templates guide
- System overview (this file)
- Main README

✅ **Directory Structure**
- `.ziro/specs/` for features
- `.ziro/templates/` for templates
- Organized by frontend specialization

🔄 **Future**
- Back-end templates (`.ziro/templates/back-end-templates/`)
- Database schema templates
- API design templates
- Testing pattern templates

## Support

For questions about:
- **Getting started**: Read `.ziro/GETTING_STARTED.md`
- **Templates**: Read `.ziro/templates/FRONTEND_TEMPLATES_GUIDE.md`
- **System**: Read this overview document
- **Generic Kiro**: Read `claude_agnostic.md`

---

**Ziro**: Zero-friction spec-driven development through spec-driven planning and templated implementation.

Built on Amazon's Kiro methodology, customized for SvelteKit.
