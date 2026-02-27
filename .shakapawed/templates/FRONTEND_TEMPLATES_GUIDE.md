# SvelteKit Frontend Templates Guide

This guide explains how to use the Shakapawd frontend templates for building SvelteKit features with the structured spec-driven approach.

## What's in the Frontend Templates

The frontend templates are specifically customized for SvelteKit applications with the following tech stack:

- **SvelteKit 2.x** - Full-stack framework
- **Svelte 5** - Modern component framework
- **Tailwind CSS v4** - Styling
- **Flowbite Svelte** - UI component library
- **MapLibre GL** - Interactive maps
- **Auth.js + Keycloak** - Authentication
- **Zod** - Validation
- **Vitest** - Testing
- **Orval** - API client generation

## Three Templates

### 1. requirements_template_frontend.md

**Purpose**: Document what needs to be built from a user and business perspective.

**Key Sections**:
- User stories for different user types (frontend users, accessibility, mobile)
- Acceptance criteria using EARS format
- Feature specifications and component list
- Frontend architecture overview
- Dependency and risk assessment

**When to Use**:
- Starting a new feature
- Before any design or implementation work
- To align with product/business requirements

**Typical Content**:
- What routes/pages are needed?
- What user interactions are required?
- What data needs to be loaded?
- What forms/inputs are needed?
- What accessibility requirements exist?
- What mobile/responsive requirements exist?

### 2. design_template_sveltekit.md

**Purpose**: Define the technical architecture and implementation approach.

**Key Sections**:
- Data flow diagram (Remote Functions → Services → API Client)
- Component architecture diagram
- Technology stack details
- File structure and organization
- Component and interface definitions
- State management patterns (stores, context)
- Form handling with Superforms + Zod
- Authentication flow
- Mapping implementation (if needed)
- Error handling strategy
- Testing strategy for client & server
- Performance & security considerations

**When to Use**:
- After requirements are approved
- To plan the technical approach
- To communicate architecture to team members

**Typical Content**:
- Which components need to be built?
- How will data flow through the application?
- What routes and pages are needed?
- How will state be managed?
- What validation is needed?
- What error scenarios need handling?

### 3. tasks_template_frontend.md

**Purpose**: Break down the design into specific, actionable coding tasks.

**Key Sections**:
- 7 implementation phases with numbered tasks
- Each task has: description, deliverables, requirements reference, dependencies
- Task guidelines and completion criteria
- File organization reference
- Progress tracking and definition of done
- Command reference

**Phases**:
1. Project Structure & Setup
2. State Management & Store Setup
3. Core UI Components
4. Feature Block Assembly
5. Testing & Validation
6. Performance & Optimization
7. Documentation & Polish

**When to Use**:
- After design is approved
- Ready to start implementation
- Each task can be executed incrementally

**Task Structure Example**:
```
- [ ] **3.1** Create list/grid display component
  - **Description**: Build component to display data
  - **Deliverables**: Component file, component test
  - **Requirements**: [Ref: REQ-XX]
  - **Estimated Effort**: 1.5 hours
  - **Dependencies**: Task 2.1 (store)
```

## How to Create a New Feature Spec

### Step 1: Set Up Directory

```bash
mkdir -p .shakapawed/specs/{feature-name}
cd .shakapawed/specs/{feature-name}
```

### Step 2: Copy Templates

```bash
cp ../../templates/front-end-templates/requirements_template_frontend.md requirements.md
cp ../../templates/front-end-templates/design_template_sveltekit.md design.md
cp ../../templates/front-end-templates/tasks_template_frontend.md tasks.md
```

### Step 3: Phase 1 - Requirements

1. Open `requirements.md`
2. Replace placeholders with your feature details
3. Fill in all sections:
   - User stories for each user type
   - Acceptance criteria (EARS format)
   - Component list
   - Technical architecture approach
   - Dependencies and risks
4. Get approval from product/business stakeholder
5. Mark status as "Approved"

### Step 4: Phase 2 - Design

1. Open `design.md`
2. Replace placeholders based on requirements
3. Fill in all sections:
   - Data flow architecture (Remote Functions pattern)
   - Component structure
   - File organization
   - State management approach
   - Form and validation design
   - Error handling strategy
   - Testing approach
4. Include code examples/templates
5. Get technical approval from team lead
6. Mark status as "Approved"

### Step 5: Phase 3 - Tasks

1. Open `tasks.md`
2. Replace placeholders with specific tasks
3. Create numbered tasks organized into 7 phases
4. Each task should:
   - Have clear description
   - List specific deliverables (files to create)
   - Reference requirements
   - Specify dependencies
   - Estimate effort
5. Get implementation approval
6. Mark status as "Approved"

### Step 6: Phase 4 - Implementation

1. Start with Phase 1, Task 1.1
2. Follow the task description exactly
3. Create the specified deliverables
4. Run tests: `bun run test`
5. Run linting: `bun run lint && bun run format`
6. Move to next task
7. Stop between each task for review

## Template Customization Tips

### For Your Project

**Update Tech Stack References**:
If your project uses different libraries, customize the templates:
- Change component library if not Flowbite
- Update styling approach if not Tailwind
- Adjust API client generation tool if not Orval
- Change form library if not Superforms

**Update Patterns**:
If your project has specific patterns:
- Document your store initialization pattern
- Explain your service layer pattern
- Describe your component naming convention
- Explain your API endpoint structure

**Update File Locations**:
If your project structure is different:
- Change paths in examples (`src/routes`, `lib/blocks`, etc.)
- Update file naming conventions
- Adjust imports to match your setup

### For Consistency

**Keep Examples Real**:
Replace generic `[ComponentName]` with actual examples from your domain (e.g., `TowerListComponent`, `TowerSearchForm`).

**Match Your Conventions**:
If you use different naming (e.g., `views` instead of `pages`), update examples throughout.

**Reference Your Docs**:
Link to your project's architecture documentation and coding standards.

## File Structure for Features

When you complete a feature spec, your directory looks like:

```
.shakapawed/
└── specs/
    └── tower-search/
        ├── requirements.md      ✓ Approved
        ├── design.md           ✓ Approved
        └── tasks.md            ✓ Approved
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
│   │   └── [...other components]
│   ├── api/tower.remote.ts
│   ├── services/tower.service.ts
│   ├── stores/tower.store.ts
│   ├── schemas/tower.schema.ts
│   └── utils/tower.utils.ts
```

## Phase Descriptions

### Phase 1: Project Structure & Setup
Create the basic infrastructure:
- Routes and pages
- Validation schemas
- Service layer
- Remote functions for data loading

**Estimated**: 3-4 hours total

### Phase 2: State Management & Store Setup
Set up reactive state:
- Global Svelte stores
- Utility functions and helpers

**Estimated**: 1.5 hours total

### Phase 3: Core UI Components
Build individual components:
- List/grid display
- Form with validation
- Detail/modal view
- Error state
- Loading state

**Estimated**: 5-6 hours total

### Phase 4: Feature Block Assembly
Compose components together:
- Assemble block from components
- Connect to page and data loading
- Wire up state management

**Estimated**: 3 hours total

### Phase 5: Testing & Validation
Ensure quality:
- Unit tests for services/utils
- Component tests for UI
- Accessibility audit
- Responsive design testing

**Estimated**: 4-5 hours total

### Phase 6: Performance & Optimization
Optimize the feature:
- Bundle size analysis
- Lazy loading and code splitting

**Estimated**: 2-3 hours total

### Phase 7: Documentation & Polish
Finalize and document:
- Update project documentation
- Code review and cleanup
- Create demo and testing checklist

**Estimated**: 2-3 hours total

## Common Customizations

### For Map-Based Features

In requirements:
- Add "Map Interaction" user story section
- Specify map features needed

In design:
- Include mapping section with MapLibre details
- Show geospatial data flow
- Explain Turf.js usage for calculations

In tasks:
- Add map component creation task
- Add data clustering task
- Add geospatial calculation task

### For Complex Forms

In requirements:
- Detail form fields and validation rules
- Specify multi-step vs single page

In design:
- Show form data structure
- Explain validation flow
- Detail error messaging strategy

In tasks:
- Break form into multiple component tasks
- Add validation testing task
- Add accessibility testing for form controls

### For Real-Time Data

In requirements:
- Specify data refresh requirements
- Define polling or WebSocket strategy

In design:
- Show data refresh architecture
- Explain state synchronization
- Detail error recovery for disconnects

In tasks:
- Add refresh mechanism task
- Add error handling for stale data
- Add connection status indicator task

## Quick Reference: Template Locations

```
.shakapawed/templates/front-end-templates/
├── requirements_template_frontend.md    # What to build
├── design_template_sveltekit.md        # How to build it
└── tasks_template_frontend.md          # Step-by-step tasks
```

Each template includes:
- Detailed section explanations
- Code examples
- Mermaid diagrams (in design template)
- Task organization (in tasks template)

## Getting Help

### Understanding Sections

Each template section has:
- **[Bracketed text]** - Placeholder to replace
- **Code examples** - Show what to write
- **Explanations** - Describe why section is important

### When Requirements Aren't Clear

Iterate with stakeholders:
1. Draft requirements
2. Get feedback
3. Update based on feedback
4. Repeat until approved

### When Design Gets Complicated

Break it into pieces:
1. Start with high-level architecture
2. Detail each major component separately
3. Show data flow between components
4. Explain error handling per component

### When Tasks Are Too Big

Create subtasks:
1. Break task description into smaller steps
2. List each step in deliverables
3. Create separate test task if large
4. Keep task effort under 2-3 hours

## Next Steps

1. Choose a feature to build
2. Create `.shakapawed/specs/{feature-name}/`
3. Copy the three templates
4. Fill out requirements.md
5. Share with team for approval
6. Proceed to design.md
7. Proceed to tasks.md
8. Start implementation!

---

*Frontend Templates: SvelteKit-specific spec-driven development templates*
