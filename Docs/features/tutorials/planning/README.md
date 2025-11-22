---
phase: planning
title: Tutorial System Implementation Planning
description: Task breakdown, dependencies, timeline, and risk mitigation for tutorial system development
---

# Tutorial System Implementation Planning

## Milestones

### M1: Foundation - Core Infrastructure
**Goal**: Establish tutorial system foundation with subsystem, data structures, and save/load functionality

**Deliverables**:
- [ ] UTutorialManagerSubsystem implemented and tested
- [ ] FTutorialStepData and FTutorialSaveData structs defined
- [ ] ETutorialID and ETooltipType enums created
- [ ] Save/load integration with UCarSaveGameManager complete
- [ ] Debug console commands functional (ResetTutorials, TriggerTutorial)

**Success Criteria**: Can trigger and save tutorial completion state programmatically

**Estimated Effort**: 5 developer-days

**Team Allocation**: 1 C++ Developer

---

### M2: Core Features - Widget Implementation
**Goal**: Implement interactive tutorial widgets and tooltip system

**Deliverables**:
- [ ] UScriptTutorialWidget C++ base class complete
- [ ] Blueprint child class WBP_ScriptTutorial with UI from Figma
- [ ] Time dilation (slow motion) working smoothly
- [ ] Input control locking functional
- [ ] Screen masking (black overlay) implemented
- [ ] Auto-dismiss timer system working
- [ ] UTooltipTutorialWidget with pooling (3 instances)
- [ ] Blueprint child class WBP_Tooltip with UI from Figma

**Success Criteria**: Can display tutorial steps with slow motion, control locking, and auto-dismiss

**Estimated Effort**: 10 developer-days

**Team Allocation**:
- 1 C++ Developer - Widget base classes (4 days)
- 1 Blueprint Developer - UI implementation (4 days)
- Work in parallel after C++ base classes complete

---

### M3: Integration - Game Event Hooks
**Goal**: Connect tutorial system to game events and progression triggers

**Deliverables**:
- [ ] Basic Controls 1 tutorial triggers on first race, first curve
- [ ] Basic Controls 2 tutorial triggers on second race, first drift
- [ ] VnTourMap tutorial triggers after first race + UserProfile creation
- [ ] "New Car Upgrade Available" tooltip triggers correctly
- [ ] "You Are Out Of Fuel" tooltip triggers correctly
- [ ] "New Items Available In Shop" tooltip triggers correctly
- [ ] Tutorial completion prevents re-triggering

**Success Criteria**: All 3 script tutorials and 3 tooltips trigger at correct game moments

**Estimated Effort**: 5 developer-days

**Team Allocation**:
- 1 C++ Developer - Race/vehicle event hooks (2 days)
- 1 Blueprint Developer - Progression/UI hooks (2 days)
- Work in parallel

---

### M4: Testing & Polish
**Goal**: Testing, bug fixes, and performance optimization

**Deliverables**:
- [ ] Unit tests for UTutorialManagerSubsystem (100% coverage)
- [ ] Integration tests for all tutorial triggers
- [ ] Manual testing on target platforms (Android/iOS)
- [ ] Performance benchmarks (60 FPS maintained during slow motion)
- [ ] Bug fixes and edge case handling

**Success Criteria**: All tests pass, performance targets met, ready for production

**Estimated Effort**: 3 developer-days

**Team Allocation**:
- 1 C++ Developer - Testing, bug fixes and optimization (2 days)
- 1 Blueprint Developer - Manual testing and polish (1 day)
- Work in parallel

## Task Breakdown

### Phase 1: Foundation
**Estimated Duration**: 5 days (with 1 developer) or **3 days (with parallel work)**

**C++ Developer**:
- [ ] **Task 1.1**: Create UTutorialManagerSubsystem (2 days)
  - Implement C++ subsystem for tutorial state management
  - Add `TMap<ETutorialID, bool> CompletedTutorials` for state tracking
  - Implement `CheckAndTriggerTutorial()`, `IsTutorialCompleted()`, `MarkTutorialCompleted()`

- [ ] **Task 1.2**: Define Data Structures (1 day)
  - Create `TutorialTypes.h` with `ETutorialID`, `ETooltipType`, `EControlType` enums
  - Create `FTutorialStepData` struct (PanelText, PanelImage, HighlightedControl, AutoDismissTime)
  - Create `FTutorialSaveData` struct (CompletedTutorials array)

- [ ] **Task 1.3**: Implement Save/Load Integration (1 day)
  - Add `FTutorialSaveData` to existing save game class
  - Implement `SaveTutorialProgress()` and `LoadTutorialProgress()`

- [ ] **Task 1.4**: Implement Debug Commands (0.5 days)
  - `ResetTutorials()`, `TriggerTutorial(FString)`, `ShowTutorialDebug()`

- [ ] **Task 1.5**: Unit Tests for Subsystem (0.5 days)
  - Test state management, save/load, tooltip spam prevention

**Parallel Work Opportunity**: Tasks 1.2-1.5 can be done by a second developer if available

---

### Phase 2: Core Features
**Estimated Duration**: 10 days (sequential) or **4 days (with 2 developers in parallel)**

**C++ Developer** - Widget Base Classes:
- [ ] **Task 2.1**: Create UScriptTutorialWidget C++ Base (2 days)
  - Core widget logic, time dilation, control locking
- [ ] **Task 2.6**: Create UTooltipTutorialWidget C++ Base (1 day)
  - Tooltip logic, pooling system
- [ ] **Task 2.3**: Implement Control Locking System (1 day)
  - Enhanced Input integration

**Blueprint Developer** - UI Implementation (can start after base classes):
- [ ] **Task 2.2**: Create WBP_ScriptTutorial Blueprint (2 days)
  - UI layout from Figma, animations
- [ ] **Task 2.7**: Create WBP_Tooltip Blueprint (1 day)
  - Tooltip UI, fade in/out animations
- [ ] **Task 2.4**: Implement Screen Masking (1 day)
  - Black overlay material, cutout system

**Either Developer** - Final Integration:
- [ ] **Task 2.5**: Implement Auto-Dismiss Timer (0.5 days)
- [ ] **Task 2.8**: Implement Tooltip Pooling (0.5 days)
- [ ] **Task 2.9**: Integration Tests for Widgets (1 day)

**Parallel Work**: C++ and Blueprint developers work simultaneously after base classes complete

---

### Phase 3: Integration
**Estimated Duration**: 5 days (sequential) or **2 days (with 2 developers in parallel)**

**C++ Developer** - Core Game Hooks:
- [ ] **Task 3.1**: Hook ARaceTrackManager Events (1 day)
  - OnRaceStart, OnCheckpointPassed, OnRaceCompleted
- [ ] **Task 3.2**: Hook ASimulatePhysicsCar Events (0.5 days)
  - OnDriftStarted, OnFuelDepleted
- [ ] **Task 3.7**: Implement Tutorial Completion Persistence (0.5 days)

**Blueprint Developer** - Progression Hooks:
- [ ] **Task 3.3**: Hook UFanServiceSubsystem Events (1 day)
  - OnUpgradeAvailable, OnShopItemUnlocked
- [ ] **Task 3.4-3.6**: Configure Tutorial Triggers (1 day)
  - Set up trigger conditions for all 6 tutorials and 3 tooltips
- [ ] **Task 3.8**: Integration Testing (1 day)
  - Test all trigger conditions, verify no re-triggering

**Parallel Work**: Both developers work simultaneously

---

### Phase 4: Testing & Polish
**Estimated Duration**: 3 days (sequential) or **2 days (with parallel work)**

**C++ Developer**:
- [ ] **Task 4.1**: Unit Tests for Subsystem (0.5 days)
  - Test state management, save/load, tooltip spam prevention
- [ ] **Task 4.2**: Integration Tests (0.5 days)
  - Test all trigger conditions, widget flows
- [ ] **Task 4.3**: Performance Benchmarking (0.5 days)
  - Verify 60 FPS, <100ms load time
- [ ] **Task 4.4**: Bug Fixes and Optimization (0.5 days)
  - Fix issues, optimize performance

**Blueprint Developer**:
- [ ] **Task 4.5**: Manual Testing (1 day)
  - Test all tutorials on target platforms (Android/iOS)
  - Document bugs and edge cases
- [ ] **Task 4.6**: Final Polish (0.5 days)
  - UI tweaks, animation timing
- [ ] **Task 4.7**: Documentation (0.5 days)
  - Update design docs with final implementation notes

**Parallel Work**: Both developers work simultaneously

## Dependencies

**Critical Path**: Foundation (M1) → Core Features (M2) → Integration (M3) → Testing (M4)

**Blocking Dependencies**:
- M1 must complete before M2 can start (subsystem required for widgets)
- M2 C++ base classes must complete before Blueprint UI work can start
- M2 must complete before M3 (widgets must exist before hooking)
- M3 must complete before M4 (integration must work before testing)

**Parallel Work Opportunities**:
- **M1**: Tasks 1.2-1.5 can be done by second developer if available
- **M2**: C++ Developer and Blueprint Developer work simultaneously after base classes
- **M3**: C++ Developer and Blueprint Developer work simultaneously
- **M4**: C++ Developer and Blueprint Developer work simultaneously

## Timeline & Estimates

### Scenario 1: Sequential Development (1 Developer)
**Total Duration**: ~23 calendar days

| Phase | Duration | Developer-Days | Notes |
|-------|----------|----------------|-------|
| M1: Foundation | 5 days | 5 | 1 C++ Developer |
| M2: Core Features | 10 days | 10 | 1 Developer (C++ then Blueprint) |
| M3: Integration | 5 days | 5 | 1 Developer |
| M4: Testing & Polish | 3 days | 3 | 1 Developer |
| **Total** | **23 days** | **23** | Single developer workflow |

### Scenario 2: Optimized Parallel Development (Recommended)
**Total Duration**: ~10 calendar days

| Phase | Duration | Developer-Days | Team Size | Notes |
|-------|----------|----------------|-----------|-------|
| M1: Foundation | 3 days | 5 | 2 developers | Parallel work on tasks 1.2-1.5 |
| M2: Core Features | 4 days | 10 | 2 developers | C++ + Blueprint in parallel |
| M3: Integration | 2 days | 5 | 2 developers | C++ + Blueprint in parallel |
| M4: Testing & Polish | 2 days | 3 | 2 developers | C++ + Blueprint in parallel |
| **Total** | **10 days** | **23** | **2 developers** | Optimized parallel workflow |

### Scenario 3: Aggressive Timeline (Maximum Parallelization)
**Total Duration**: ~8 calendar days

| Phase | Duration | Developer-Days | Team Size | Notes |
|-------|----------|----------------|-----------|-------|
| M1: Foundation | 2 days | 5 | 3 developers | Maximum parallel work |
| M2: Core Features | 3 days | 10 | 3 developers | C++ + Blueprint + additional dev |
| M3: Integration | 2 days | 5 | 3 developers | All hands on deck |
| M4: Testing & Polish | 1 day | 3 | 3 developers | Intensive testing + fixes |
| **Total** | **8 days** | **23** | **3 developers** | Aggressive timeline, higher risk |

**Recommendation**: Use **Scenario 2 (Optimized Parallel Development)** for best balance of speed and quality.

## Risks & Mitigation

**RISK-T1: Time Dilation Side Effects**
- **Impact**: High | **Probability**: Medium
- **Mitigation**: Test early, use `CustomTimeDilation` if global dilation causes issues
- **Contingency**: Implement tutorial pause instead of slow motion

**RISK-T2: Input Locking Complexity**
- **Impact**: Medium | **Probability**: Medium
- **Mitigation**: Research Enhanced Input API early, prototype in Task 2.3
- **Contingency**: Simplify to full input lock with visual-only highlighting

**RISK-T3: Mobile Performance During Slow Motion**
- **Impact**: High | **Probability**: Low
- **Mitigation**: Profile early, optimize widget complexity, no Tick usage
- **Contingency**: Increase time dilation value (0.5x instead of 0.3x)

**RISK-UX1: Player Frustration with Forced Tutorials**
- **Impact**: Medium | **Probability**: Medium
- **Mitigation**: Keep tutorials short (<2 min), provide skip after 60s, trigger only once
- **Contingency**: Add "Disable Tutorials" option in settings (post-MVP)

## Resources Needed

### Team Composition (Scenario 2 - Recommended)

**Core Team**:
- **C++ Developer** - 11 days full-time
  - M1: Foundation (3 days)
  - M2: Widget base classes (4 days)
  - M3: Game event hooks (2 days)
  - M4: Testing, bug fixes and optimization (2 days)

- **Blueprint Developer** - 10 days full-time
  - M2: UI implementation (4 days)
  - M3: Progression hooks, configuration and integration testing (3 days)
  - M4: Manual testing, final polish and documentation (2 days)
  - Can start after M1 completes

**Total Team Size**: 2 developers

**Total Effort**: 23 person-days (11 + 10 + 2)

### Tools & Equipment

**Software**:
- Unreal Engine 5.4
- Enhanced Input Plugin (already integrated)
- Figma (for UI design reference)
- Unreal Insights (performance profiling)

**Hardware**:
- Development PCs (already available)
- Android test devices (for testing)
- iOS test devices (for testing)

**Assets**:
- Figma UI designs (already available)
- Tutorial panel images (to be created)
- Icon assets for tooltips (to be created)

