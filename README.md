# Agent System Template

An AI orchestration system for solo developers or small teams. It structures collaboration between a human and multiple AI agents (Claude Code, Codex, Cursor) around a shared protocol, a Figma-synced design system, and strict decision control.

---

## How it works

```
Level 0 : Human
Level 1 : AGENTS.md  <-  single orchestrator, read by all agents
Level 2 : Skills     <-  atomic actions triggered by AGENTS.md
```

**`AGENTS.md`** is the only file every agent reads first. It defines the session protocol, decision rules, available skills, and guardrails. Each AI tool (Claude Code, Cursor, Codex) has a minimal adapter that points to it.

**Skills** (`skills/`) are atomic actions: starting a session, auditing a component, syncing Figma, committing. A skill never delegates to another skill — all orchestration flows back through `AGENTS.md`.

**System files** (`system/`) store durable decisions: governance, tokens, trade-off memory, access control. No agent modifies them freely — each file has an authorized editor defined in `system/access-control.md`.

---

## Setup after fork

### 1. Configure the project

Fill in the stack and conventions in `system/governance.md`:
- **Tech stack** section: chosen technologies
- **Naming conventions** section: adjust as needed
- **Scope** section: what is in and out of scope

### 2. Create a specs folder

Create a folder for feature specifications (e.g. `specs/`). For each feature, a Markdown file describing expected behavior, business rules, and UI states.

Update the reference in `system/governance.md` → **Reference files** section → *Feature specs* line.

Update `AGENTS.md` → Phase 3a → replace *"specs folder defined in `system/governance.md`"* with the actual path.

### 3. Connect Figma (optional)

If the project has a Figma file:
- Add the file URL in `system/governance.md`
- Run `skills/figma-sync.md` to populate `system/tokens.md` and `design-system/`

If no Figma, manually fill in tokens in `system/tokens.md` and disable references to `figma-sync.md` in `AGENTS.md`.

### 4. Create the first tasks

Write freely in `TODO.md` — one idea per line, no required format:

```
Create homepage
Setup authentication
Define user data model
```

At the next session, the agent reads `TODO.md`, classifies each entry (category, priority, difficulty) and adds it to `roadmap.md`. `TODO.md` is then cleared.

### 5. Start a session

Open a conversation with Claude Code (or Cursor, Codex). The agent automatically runs `skills/session-start.md`, which:
1. Syncs `TODO.md` → `roadmap.md`
2. Proposes the highest-priority task
3. Waits for validation before acting

---

## File structure

```
AGENTS.md                        <- single protocol, read by all agents
CLAUDE.md                        <- Claude Code adapter
.cursor/rules/protocol.mdc       <- Cursor adapter
TODO.md                          <- free-form task dump (human -> agents)
roadmap.md                       <- structured backlog (managed by agents)
later.md                         <- temporary decisions to revisit later

system/
  governance.md                  <- stack, conventions, non-negotiable rules
  tokens.md                      <- design tokens (synced from Figma)
  memory.md                      <- decision and trade-off log
  access-control.md              <- who can write what and through which path
  session-state-claude.md        <- live session state (injected via hook)

design-system/
  component-catalog.md           <- component index
  flows-catalog.md               <- flow/journey index
  components/                    <- per-component documentation
  flows/                         <- per-flow documentation

skills/
  session-start.md               <- session startup (TODO sync + task proposal)
  product-challenge.md           <- product thinking phase (M+ tasks)
  design-audit.md                <- component + token audit before implementation
  scaffold-feature.md            <- feature file stub creation
  unit-tests.md                  <- unit test generation after implementation
  compliance.md                  <- post-implementation audit before commit
  figma-sync.md                  <- Figma -> tokens.md + design-system/ sync
  commit-protocol.md             <- verification + commit + session close
  update-system.md               <- system file update after human decision
  create-skill.md                <- new skill creation

scripts/
  migrate-to-project.ps1         <- apply system updates to existing projects
```

---

## Core rules

- **Never decide alone**: any product, architecture, or governance decision is proposed to the human with a recommendation. The agent waits for validation.
- **Never hardcode values**: all visual values come from `system/tokens.md`.
- **Never commit without compliance**: commit only happens after explicit human validation of the compliance report.
- **Figma is the source of truth**: specs are a starting point, not the final reference.
- **No nesting**: skills never call each other.
