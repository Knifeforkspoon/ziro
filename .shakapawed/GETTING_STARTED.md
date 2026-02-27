# Getting Started with Shakapawd

Welcome to Shakapawd - the spec-driven development system for building features systematically.

## What is Shakapawd?

Shakapawd is a structured approach to building frontend features using three phases:

1. **Requirements** - Document what needs to be built
2. **Design** - Plan how to build it
3. **Tasks** - Break design into actionable coding tasks

Each phase requires approval before moving to the next, ensuring quality and clarity.

## Directory Structure

```
.shakapawed/
├── specs/                              # Your feature specifications
│   └── {feature-name}/                 # Individual features
│       ├── requirements.md             # Phase 1: What to build
│       ├── design.md                   # Phase 2: How to build it
│       └── tasks.md                    # Phase 3: Implementation tasks
└── templates/
    └── front-end-templates/            # Frontend development templates
        ├── requirements_template_frontend.md
        ├── design_template_sveltekit.md
        ├── tasks_template_frontend.md
        └── FRONTEND_TEMPLATES_GUIDE.md # Read this first!
```

## Quick Start: Building Your First Feature

### 1. Read the Frontend Templates Guide

Start here: `.shakapawed/templates/FRONTEND_TEMPLATES_GUIDE.md`

This explains:
- What each template is for
- How to customize for your project
- Common patterns and customizations

### 2. Create a Feature Directory

```bash
mkdir -p .shakapawed/specs/my-feature
cd .shakapawed/specs/my-feature
```

### 3. Copy the Templates

```bash
cp ../../templates/front-end-templates/requirements_template_frontend.md requirements.md
cp ../../templates/front-end-templates/design_template_sveltekit.md design.md
cp ../../templates/front-end-templates/tasks_template_frontend.md tasks.md
```

### 4. Fill Out Requirements (Phase 1)

Edit `requirements.md`:

1. **Introduction section**
   - What is this feature?
   - What problem does it solve?
   - How does it fit in the app?

2. **User Stories section**
   - Who are the users?
   - What do they want to do?
   - What do they get out of it?

3. **Acceptance Criteria**
   - What specific behaviors must work?
   - Use EARS format: "WHEN X, THEN Y"
   - Include error cases

4. **Feature Specifications**
   - What components/pages are needed?
   - What data operations?
   - What state management?

5. **Technical Architecture**
   - Which API endpoints?
   - How will data flow?
   - Any special requirements?

6. **Constraints and Dependencies**
   - What's limited?
   - What external dependencies?

### 5. Get Requirements Approval

Share `requirements.md` with:
- Product owner or stakeholder
- Design team if applicable
- Tech lead for feasibility review

Update based on feedback until approved. Mark as "Approved" when ready.

### 6. Fill Out Design (Phase 2)

Edit `design.md`:

1. **Overview**
   - Summarize the feature

2. **Architecture Diagrams**
   - Data flow from components → services → API
   - Component hierarchy diagram

3. **Technology Stack**
   - Confirm frameworks and libraries

4. **Components and Interfaces**
   - What components will you build?
   - What will each do?
   - What data do they need?

5. **Data Models**
   - What data structures?
   - Form schemas
   - State shape

6. **Error Handling**
   - What can go wrong?
   - How will you handle it?

7. **Testing Strategy**
   - What tests are needed?
   - How much coverage?

8. **Other Sections**
   - Styling approach
   - Performance considerations
   - Security notes
   - Assumptions

### 7. Get Design Approval

Share `design.md` with:
- Tech lead or architect
- Senior developer
- Team members who will review code

Update based on feedback until approved. Mark as "Approved" when ready.

### 8. Create Tasks (Phase 3)

Edit `tasks.md`:

The tasks template is already organized into 7 phases. For your feature:

1. **Customize task descriptions** based on your design
2. **Add specific deliverables** - what files to create
3. **Add requirement references** - which requirements each task satisfies
4. **Specify dependencies** - which tasks depend on others
5. **Keep consistent effort** - each task 30min to 2 hours

Task phases:
- Phase 1: Setup (routes, schemas, services, remote functions)
- Phase 2: State management
- Phase 3: UI components
- Phase 4: Feature assembly
- Phase 5: Testing
- Phase 6: Optimization
- Phase 7: Documentation

### 9. Get Tasks Approval

Share `tasks.md` with:
- Team lead
- Developers who will implement
- QA who will test

Update based on feedback until approved. Mark as "Approved" when ready.

### 10. Implement Tasks

For each task in `tasks.md`:

1. **Start task**: Begin working on it
2. **Create deliverables**: Build the specified files/components
3. **Write tests**: Follow the testing requirements
4. **Check quality**: Run linting and formatting
5. **Mark complete**: Update task checkbox
6. **Move to next task**: Continue through list

## Template Customization

The templates are generic and flexible. Customize them for your project:

### If You Use Different Tools

Example: If using a different UI library instead of Flowbite:

1. In design template:
   - Change component library references
   - Update examples to show your library

2. In tasks template:
   - Update component creation examples
   - Reference your actual components

### If You Have Different Conventions

Example: If using different file structure:

1. Update file paths in examples
2. Adjust component naming conventions
3. Reference your actual patterns

### If You Have Special Requirements

Example: If building a map feature:

1. In requirements:
   - Add mapping-specific user stories
   - Add mapping-specific acceptance criteria

2. In design:
   - Add mapping architecture section
   - Show data flow for geospatial data
   - Explain MapLibre GL integration

3. In tasks:
   - Add map component creation tasks
   - Add geospatial calculation tasks

See `FRONTEND_TEMPLATES_GUIDE.md` for more customization examples.

## Command Reference

Common commands for development:

```bash
# Development
bun run dev          # Start dev server

# Building
bun run build        # Build for production
bun run preview      # Preview the build

# Testing
bun run test         # Run all tests
bun run test:unit    # Run unit tests
bun run test:browser # Run component tests

# Code Quality
bun run lint         # Check linting
bun run format       # Format code
bun run type-check   # TypeScript check

# API
bun run refresh-api-client  # Regenerate API client from OpenAPI
```

## Approval Process

Each phase requires approval:

```
Requirements (Draft)
    ↓
    ✓ Approved by Product Owner
    ↓
Design (Draft)
    ↓
    ✓ Approved by Tech Lead
    ↓
Tasks (Draft)
    ↓
    ✓ Approved by Team
    ↓
Implementation
    ↓
    ✓ Complete
```

## Completed Features

Example structure after completing a feature:

```
.shakapawed/specs/tower-search/
├── requirements.md  ✓ Approved
├── design.md       ✓ Approved
└── tasks.md        ✓ Approved

src/
├── routes/towers/
│   ├── +page.svelte
│   └── +page.ts
├── lib/
│   ├── blocks/TowerSearch.svelte
│   ├── components/
│   │   ├── TowerList.svelte
│   │   ├── TowerFilters.svelte
│   │   └── [...other components]
│   ├── api/tower.remote.ts
│   ├── services/tower.service.ts
│   ├── stores/tower.store.ts
│   ├── schemas/tower.schema.ts
│   └── utils/tower.utils.ts
```

## Tips for Success

### 1. Be Specific in Requirements

❌ Bad: "Show towers on map"
✓ Good: "Display tower locations clustered on interactive map, clickable for details"

### 2. Reference Requirements in Tasks

Each task should reference specific requirements (REQ-01, etc.) so implementation can validate against them.

### 3. Keep Tasks Focused

❌ Too big: "Build entire search feature"
✓ Right size: "Create TowerList component to display search results"

### 4. Test as You Go

Don't save testing for the end. Each task should include tests.

### 5. Document Decisions

If you deviate from the design, document why in comments or update the spec.

### 6. Iterate on Specs

Specs aren't final. If you discover issues during implementation, update the spec and discuss with team.

## Common Patterns

### Maps Feature

Requirements:
- Add map viewing user stories
- Add location accuracy requirements
- Specify interaction patterns (zoom, click, etc.)

Design:
- MapLibre GL architecture
- Data clustering with Turf.js
- Geospatial calculations
- Map data loading and refresh

Tasks:
- Map component creation
- Clustering implementation
- Popup component for details
- Performance optimization

### Complex Forms

Requirements:
- Multi-step or single-page form?
- Field dependencies?
- Dynamic field visibility?

Design:
- Superforms + Zod setup
- Form state structure
- Validation flow (client, server, both?)
- Error message strategy

Tasks:
- Form component for each step/section
- Validation schema setup
- Error handling
- Accessibility (labels, ARIA)

### Data Grid/List

Requirements:
- Sorting? Filtering? Pagination?
- Columns or cards?
- Selection/bulk actions?

Design:
- Data fetching strategy
- Virtual scrolling for large lists?
- Filter/sort state management
- Responsive behavior

Tasks:
- List component
- Filter component
- Pagination component
- Column customization

## Getting Help

### Understanding Sections

Read `FRONTEND_TEMPLATES_GUIDE.md` for:
- What each template section means
- When to use each template
- How to customize for your project

### When Stuck

1. Check if requirements are clear
2. Simplify design if too complex
3. Break tasks into smaller pieces
4. Ask team for input

### Real Examples

Look for existing specs in `.shakapawed/specs/` to see:
- How other features documented requirements
- How design docs are organized
- How tasks are broken down

## Next Steps

1. Choose a feature to build
2. Create `.shakapawed/specs/{feature-name}/`
3. Copy templates
4. Fill in requirements.md
5. Get approval from stakeholder
6. Proceed to design.md
7. Get technical approval
8. Create tasks.md
9. Get team approval
10. Start implementing!

---

**Start with**: `.shakapawed/templates/FRONTEND_TEMPLATES_GUIDE.md`

**Then create your first feature**: `.shakapawed/specs/{your-feature-name}/`

*Shakapawd: Systematic feature development through structured specs and templates.*
