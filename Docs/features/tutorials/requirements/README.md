---
phase: requirements
title: Tutorial System Requirements
description: Interactive tutorial system for teaching VNRacing controls, mechanics, and features to new players
---

# Tutorial System Requirements

## Problem Statement
**What problem are we solving?**

- **Core Problem**: New players struggle to learn VNRacing's racing controls (steering, drifting, NOS) and game features (map navigation, car upgrades, shop) without structured guidance, leading to poor first-time user experience and potential early abandonment.
- **Who is affected**: 
  - New players experiencing VNRacing for the first time
  - Returning players encountering new features (upgrades, customization)
  - Players unfamiliar with mobile racing game controls
- **Current situation**: No systematic tutorial system exists. Players must learn through trial-and-error during actual races, resulting in frustration and suboptimal gameplay understanding.

## Goals & Objectives
**What do we want to achieve?**

### Primary Goals
1. **Teach Core Controls**: Ensure 100% of new players understand basic racing controls (steering, drifting, NOS) before their second race
2. **Guide Feature Discovery**: Introduce players to VNTour map navigation, car upgrades, and shop systems at appropriate progression milestones
3. **Minimize Disruption**: Deliver tutorials without breaking immersion or frustrating experienced players

### Secondary Goals
4. **Reduce Support Requests**: Decrease "how do I...?" support tickets by 80% through proactive in-game guidance
5. **Improve Retention**: Increase Day-1 retention by 25% through better onboarding experience
6. **Contextual Help**: Provide just-in-time tooltips for important game state changes (out of fuel, new upgrades available)

### Non-Goals (Out of Scope)
- Advanced racing techniques tutorial (racing lines, optimal drift angles) - deferred to post-MVP
- Multiplayer-specific tutorials - deferred until multiplayer features are implemented
- Tutorial replay system - players can reset progress via debug commands only
- Localization - deferred to future phase
- Tutorial analytics/telemetry - deferred to monitoring phase (explicitly excluded per user request)

## User Stories & Use Cases

### Primary User Stories

**US-1: New Player Learning Basic Controls**
> As a **new player** launching VNRacing for the first time,  
> I want to **learn steering and drifting controls through interactive step-by-step guidance**,  
> So that **I can confidently control my car before competing in races**.

**US-2: Player Learning NOS Mechanic**
> As a **player** who has completed the first race,  
> I want to **understand how drifting fills NOS and how to activate speed boost**,  
> So that **I can use advanced mechanics to improve my race performance**.

**US-3: Player Navigating VNTour Map**
> As a **player** who has completed the first race and created a UserProfile,  
> I want to **learn how to navigate the VNTour map and select races**,  
> So that **I can progress through the game's campaign without confusion**.

**US-4: Player Receiving Upgrade Notification**
> As a **player** whose car meets upgrade requirements,  
> I want to **receive a non-intrusive notification about available upgrades**,  
> So that **I don't miss opportunities to improve my car's performance**.

**US-5: Player Handling Out-of-Fuel State**
> As a **player** who has depleted fuel,  
> I want to **understand why I can't race and how to refuel**,  
> So that **I can resume playing without frustration**.

### Key Workflows

**Workflow 1: First-Time Player Onboarding**
```
1. Player launches game → Main Menu
2. Player starts first race (Sơn Trà Sprint) → Race countdown begins
3. Countdown ends → Player approaches first curve
4. TRIGGER: Basic Controls 1 tutorial activates
5. Game enters slow motion, highlights steering controls
6. Player completes 8 tutorial steps (steering, drifting)
7. Tutorial ends, game returns to normal speed
8. Player completes first race
9. TRIGGER: VnTourMap tutorial activates
10. Player learns map navigation (5 steps)
11. Player selects second race (Sơn Trà Circuit)
12. TRIGGER: Basic Controls 2 tutorial activates (NOS mechanics)
13. Player completes NOS tutorial (2 steps)
14. Core onboarding complete
```

**Workflow 2: Contextual Tooltip Display**
```
1. Game detects trigger condition (e.g., fuel depleted)
2. System checks if tooltip already displayed in current session
3. If not displayed, show tooltip widget
4. Start 10-second auto-dismiss timer
5. Player either:
   a. Waits 10 seconds → Tooltip auto-dismisses
   b. Changes screen → Tooltip dismisses immediately
   c. Resolves condition (e.g., refuels) → Tooltip dismisses
```

### Edge Cases to Consider

**EC-1: Tutorial Interruption**
- Player force-closes app during tutorial → Resume tutorial on next launch OR skip if race already completed
- Player pauses game during tutorial → Tutorial pauses, resumes when unpaused

**EC-2: Tutorial Failure/Retry**
- Player performs wrong action repeatedly (>5 times) → Re-highlight control, show reminder panel
- Player ignores tutorial for extended period (>60s) → Show skip option (with warning)

**EC-3: Tooltip Spam Prevention**
- Multiple tooltip conditions trigger simultaneously → Queue tooltips, show one at a time with 2s gap
- Same tooltip triggers repeatedly → Show maximum once per game session

**EC-4: Save System Integration**
- Tutorial completion must persist across sessions
- Tutorial progress must survive app crashes
- Tutorial reset must be available via debug commands

## Success Criteria
**How will we know when we're done?**

### Functional Acceptance Criteria

**AC-1: Scripts Tutorials Implementation**
- [ ] Basic Controls 1 tutorial (8 steps) triggers on first race, first curve approach
- [ ] Basic Controls 2 tutorial (2 steps) triggers on second race after first drift
- [ ] VnTourMap tutorial (5 steps) triggers after first race completion + UserProfile creation
- [ ] All tutorial steps display correct panel text matching Figma designs
- [ ] Slow motion (time dilation) activates during script tutorials
- [ ] Controls lock correctly, only highlighted control remains interactive
- [ ] Screen masking (black overlay) covers non-interactive areas
- [ ] Auto-dismiss panels close after 2 seconds OR specified condition
- [ ] Tutorial completion state persists across game sessions

**AC-2: On-Screen Tooltips Implementation**
- [ ] "New Car Upgrade Available" tooltip displays when any upgrade slot meets requirements
- [ ] "You Are Out Of Fuel" tooltip displays when fuel reaches zero
- [ ] "New Items Available In Shop" tooltip displays when new items unlock
- [ ] All tooltips auto-dismiss after 10 seconds
- [ ] Tooltips dismiss immediately when player changes screens
- [ ] Tooltips show maximum once per game session (no spam)

**AC-3: Mobile Performance**
- [ ] Tutorial system maintains 60 FPS on target mobile devices during slow motion
- [ ] Widget creation/destruction causes no visible frame drops
- [ ] Tutorial widgets use object pooling (no runtime allocation spikes)

**AC-4: UX Quality**
- [ ] Tutorial text matches Figma designs exactly
- [ ] Control highlighting is clearly visible against game background
- [ ] Screen masking provides sufficient contrast (black overlay 80% opacity)
- [ ] Slow motion feels smooth (time dilation 0.3x, not choppy)
- [ ] Tutorial skip option available after 60 seconds of inactivity

### Measurable Outcomes
- **Tutorial Completion Rate**: ≥95% of new players complete Basic Controls 1 tutorial
- **Time to Complete**: Basic Controls 1 tutorial completes in <90 seconds average
- **Player Understanding**: ≥90% of players successfully use drift and NOS in second race (indicates tutorial effectiveness)
- **Support Ticket Reduction**: "How do I control the car?" tickets decrease by ≥80%
- **Retention Impact**: Day-1 retention increases by ≥25% compared to pre-tutorial baseline

### Performance Benchmarks
- **Frame Rate**: Maintain ≥60 FPS during tutorials on target mobile devices (Android/iOS)
- **Load Time**: Tutorial widget creation <100ms
- **Responsiveness**: Input response time <16ms during slow motion (1 frame @ 60 FPS)

## Functional Requirements (EARS Notation)

### Scripts Tutorial Requirements

**REQ-ST-001: Tutorial Activation**
> WHEN the player approaches the first curve in their first race (Sơn Trà Sprint) after countdown ends,
> THE SYSTEM SHALL activate the Basic Controls 1 tutorial and apply time dilation (0.3x speed).

**REQ-ST-002: Control Locking**
> WHEN a tutorial step is active,
> THE SYSTEM SHALL disable all input controls except the currently highlighted control.

**REQ-ST-003: Screen Masking**
> WHEN a tutorial step is active,
> THE SYSTEM SHALL display a black overlay (80% opacity) covering all screen areas except the interactive control region.

**REQ-ST-004: Panel Display**
> WHEN a tutorial step activates,
> THE SYSTEM SHALL display the step's panel text matching the Figma design specification.

**REQ-ST-005: Auto-Dismiss Panels**
> WHEN a tutorial panel has an auto-dismiss timer configured,
> THE SYSTEM SHALL automatically close the panel after the specified duration (default 2 seconds).

**REQ-ST-006: Step Progression**
> WHEN the player completes the current tutorial step's required action,
> THE SYSTEM SHALL advance to the next step OR end the tutorial if no steps remain.

**REQ-ST-007: Tutorial Completion Persistence**
> WHEN a tutorial is completed,
> THE SYSTEM SHALL save the completion state to prevent re-triggering in future game sessions.

**REQ-ST-008: Basic Controls 1 Trigger**
> WHEN the player enters their first race AND approaches the first curve,
> THE SYSTEM SHALL activate the Basic Controls 1 tutorial (8 steps: auto-acceleration, steering, drifting).

**REQ-ST-009: Basic Controls 2 Trigger**
> WHEN the player starts their second race (Sơn Trà Circuit) AND performs their first drift action,
> THE SYSTEM SHALL activate the Basic Controls 2 tutorial (2 steps: NOS fill, NOS activation).

**REQ-ST-010: VnTourMap Tutorial Trigger**
> WHEN the player completes their first race AND a UserProfile has been created,
> THE SYSTEM SHALL activate the VnTourMap tutorial (5 steps: map navigation, area selection, race selection).

**REQ-ST-011: Time Dilation Restoration**
> WHEN a script tutorial ends (completion or skip),
> THE SYSTEM SHALL restore normal time dilation (1.0x speed) within 0.5 seconds.

**REQ-ST-012: Tutorial Retry on Failure**
> WHEN the player performs an incorrect action more than 5 times during a tutorial step,
> THE SYSTEM SHALL re-highlight the correct control and display a reminder panel.

**REQ-ST-013: Tutorial Skip Option**
> WHEN a tutorial has been active for more than 60 seconds without player progress,
> THE SYSTEM SHALL display a skip button with a warning message.

### On-Screen Tooltip Requirements

**REQ-TT-001: Upgrade Available Tooltip**
> WHEN any car upgrade slot meets the requirements for upgrade AND the tooltip has not been shown in the current session,
> THE SYSTEM SHALL display the "New Car Upgrade Available" tooltip.

**REQ-TT-002: Out of Fuel Tooltip**
> WHEN the player's fuel reaches zero AND the tooltip has not been shown in the current session,
> THE SYSTEM SHALL display the "You Are Out Of Fuel" tooltip.

**REQ-TT-003: New Shop Items Tooltip**
> WHEN new items are unlocked in the shop AND the tooltip has not been shown in the current session,
> THE SYSTEM SHALL display the "New Items Available In Shop" tooltip.

**REQ-TT-004: Tooltip Auto-Dismiss**
> WHEN a tooltip is displayed,
> THE SYSTEM SHALL automatically dismiss the tooltip after 10 seconds.

**REQ-TT-005: Tooltip Screen Change Dismiss**
> WHEN a tooltip is displayed AND the player navigates to a different screen,
> THE SYSTEM SHALL immediately dismiss the tooltip.

**REQ-TT-006: Tooltip Condition Resolution Dismiss**
> WHEN a tooltip is displayed AND the triggering condition is resolved (e.g., player refuels, completes upgrade),
> THE SYSTEM SHALL immediately dismiss the tooltip.

**REQ-TT-007: Tooltip Spam Prevention**
> WHEN a tooltip condition triggers AND the same tooltip has already been shown in the current game session,
> THE SYSTEM SHALL NOT display the tooltip again.

**REQ-TT-008: Tooltip Queue Management**
> WHEN multiple tooltip conditions trigger simultaneously,
> THE SYSTEM SHALL queue the tooltips and display them sequentially with a 2-second gap between each.

### System Requirements

**REQ-SYS-001: Save System Integration**
> WHEN a tutorial is completed,
> THE SYSTEM SHALL persist the completion state using the existing UCarSaveGameManager pattern.

**REQ-SYS-002: Save Data Loading**
> WHEN the game loads,
> THE SYSTEM SHALL load tutorial completion states from the save file to prevent re-triggering completed tutorials.

**REQ-SYS-003: Debug Reset Command**
> WHEN the developer executes the "ResetTutorials" console command,
> THE SYSTEM SHALL clear all tutorial completion flags and allow tutorials to re-trigger.

**REQ-SYS-004: Debug Trigger Command**
> WHEN the developer executes the "TriggerTutorial [name]" console command,
> THE SYSTEM SHALL immediately activate the specified tutorial regardless of normal trigger conditions.

**REQ-SYS-005: Widget Pooling**
> WHEN the tutorial system initializes,
> THE SYSTEM SHALL pre-create a pool of 3 tooltip widgets to avoid runtime allocation.

**REQ-SYS-006: Event-Driven Updates**
> WHEN implementing tutorial UI updates,
> THE SYSTEM SHALL use event dispatchers and SHALL NOT use Tick-based updates (mobile performance requirement).

**REQ-SYS-007: Crash Recovery**
> WHEN the game crashes during an active tutorial,
> THE SYSTEM SHALL resume the tutorial on next launch IF the triggering race has not been completed.

## Constraints & Assumptions

### Technical Constraints
- **Mobile Performance**: Must maintain 60 FPS on target mobile devices (Android/iOS) during slow motion
- **UE5 Version**: Implementation must be compatible with Unreal Engine 5.x (project's current version)
- **Existing Systems**: Must integrate with existing ARaceTrackManager, UPrototypeRacingUI, and save system without breaking changes
- **No Tick Usage**: All UI updates must be event-driven (no Tick functions) per project's mobile optimization standards

### Business Constraints
- **Tutorial Length**: Each script tutorial must complete in <2 minutes to avoid player frustration
- **Skip Option**: Must provide skip option after 60 seconds to respect player agency
- **No Forced Replays**: Completed tutorials must never re-trigger (except via debug commands)

### Platform Constraints
- **Touch Controls Only**: Tutorials designed for mobile touch input (no keyboard/gamepad support required)
- **Screen Sizes**: Must support aspect ratios from 16:9 to 21:9 (modern mobile devices)
- **Offline Support**: Tutorials must work without internet connection

### Assumptions
- **Player Literacy**: Players can read Vietnamese or English at a basic level
- **Device Capabilities**: Target devices support UE5 mobile rendering (OpenGL ES 3.1 or Vulkan)
- **First Race Completion**: Players will complete the first race (tutorial doesn't handle race abandonment)
- **Save System Reliability**: Existing save system correctly persists data across sessions
- **Figma Accuracy**: Figma designs represent final approved UI (no design changes expected)

## Questions & Open Items

### Unresolved Questions
1. **Q1**: Should tutorials be skippable from the first step, or only after 60 seconds of inactivity?
   - **Impact**: Affects player agency vs. ensuring proper onboarding
   - **Stakeholder**: Game Designer

2. **Q2**: What happens if a player skips Basic Controls 1 tutorial? Should we re-trigger it later or mark as "skipped permanently"?
   - **Impact**: Affects tutorial completion tracking and player experience
   - **Stakeholder**: Product Owner

3. **Q3**: For "Basic Car Upgrade" tutorial (pending details), should it trigger on first upgrade opportunity or after multiple races?
   - **Impact**: Affects tutorial pacing and player progression
   - **Stakeholder**: Game Designer

4. **Q4**: Should tooltip display be affected by game pause state?
   - **Impact**: Affects tooltip auto-dismiss timer behavior
   - **Stakeholder**: UX Designer

### Items Requiring Stakeholder Input
- **Pending Tutorial Details**: Basic Car Upgrade, Advanced Car Upgrade, Basic Car Customize tutorials need complete step-by-step specifications
- **Analytics Requirements**: Confirm monitoring/analytics phase is deferred (user explicitly excluded deployment phase)

### Research Needed
- **Time Dilation Value**: Validate 0.3x time dilation feels "slow but playable" through user testing
- **Panel Auto-Dismiss Duration**: Validate 2-second auto-dismiss is sufficient for players to read panel text
- **Tooltip Duration**: Validate 10-second tooltip display is appropriate (not too short, not too long)
- **Mobile Performance**: Benchmark slow motion performance on lower-end devices (Android/iOS)

---

## References
- **Figma Designs**: [VNRacing_UX](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX)
  - Basic Controls 1: [Step Details](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11578-2214)
  - Basic Controls 2: [Step Details](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11578-2213)
  - VnTourMap Tutorial: [Step Details](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=13048-65623)
  - Tooltips: [UI Design](https://www.figma.com/design/j0UmML9tgnH8EK792k9Mbb/VNRacing_UX?node-id=11578-1571)
- **Original Requirements**: `VN-Racing-Tutorials-V2.md` (Vietnamese specification)
- **Documentation Standards**: `Docs/_standards/documentation-standards.md`
- **Existing Feature Reference**: `Docs/features/racer-ai/` (architecture patterns)

