# GANTT CHART - MULTIPLAYER DEMO (TIMELINE TỐI ƯU)
## Dự án: PrototypeRacing - Multiplayer Module

**Timeline**: 12-15 ngày làm việc (2.5-3 tuần)  
**Team**: 5 developers  
**Công cụ tracking**: YouTrack  
**Version Control**: Perforce  
**CI/CD**: Jenkins  

---

## TIMELINE TỐI ƯU - CHỦ CHỐT

### Tối ưu hóa so với timeline gốc (10 ngày):
- **Original**: 10 ngày (quá lạc quan)
- **V1**: 15-20 ngày (conservative)
- **V2 (Optimized)**: 12-15 ngày (realistic + đã có UI design)

### Lý do tối ưu được:
1. ✅ **UI Design đã có sẵn** → Giảm 3-4 ngày
2. ✅ **Perforce + Jenkins setup sẵn** → Giảm 1 ngày
3. ✅ **Team có exp UE5** → Workflow nhanh hơn
4. ✅ **Parallel work streams** → Tối ưu dependencies

---

## GANTT CHART VISUAL

### WEEK 1: Foundation & Matchmaking Start (Days 1-5)

```
Day 1
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Architecture Design
Backend      ▓▓▓▓ Nakama Research & Setup
Core Dev     ▓▓▓▓ Perforce Branch + Base Classes
UI Dev       ▓▓▓▓ Import Design Assets
UI Integ     ▓▓▓▓ BP Communication Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Perforce Workflow + Data Schema
Backend      ▓▓▓▓ Nakama Project + PostgreSQL
Core Dev     ▓▓▓▓ Network Config + Test Map
UI Dev       ▓▓▓▓ Base Widgets Implementation
UI Integ     ▓▓▓▓ Mock Data Service
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 3
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Jenkins CI/CD Setup
Backend      ▓▓▓▓ Edgegap Research + DB Schema
Core Dev     ▓▓▓▓ Test Map Polish
UI Dev       ▓▓▓▓ Mode Selection Screen
UI Integ     ▓▓▓▓ State Management System
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 4
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Matchmaking Flow Design
Backend      ▓▓▓▓▓▓▓▓ Nakama Authentication [START MM]
Core Dev     ▓▓▓▓▓▓▓▓ Nakama SDK Integration
UI Dev       ▓▓▓▓▓▓▓▓ Queue Screen (Design Import)
UI Integ     ---- (Waiting for BE-006)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 5
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ---- (Planning Week 2)
Backend      ▓▓▓▓▓▓▓▓ Queue System [CRITICAL]
Core Dev     ▓▓▓▓▓▓▓▓ Auth Client Flow
UI Dev       ▓▓▓▓▓▓▓▓ Queue Screen Polish
UI Integ     ▓▓▓▓ Queue Integration Prep
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MILESTONE 1 ✓: Foundation Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### WEEK 2: Matchmaking Core (Days 6-10)

```
Day 6
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Code Review Setup
Backend      ▓▓▓▓▓▓▓▓ Queue System [CRITICAL] Day 2
Core Dev     ▓▓▓▓▓▓▓▓ MM Client Logic
UI Dev       ▓▓▓▓ Match Found Notification
UI Integ     ▓▓▓▓▓▓▓▓ Queue Screen Integration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 7
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ---- (Support team)
Backend      ▓▓▓▓▓▓▓▓ Match Creation Logic
Core Dev     ▓▓▓▓▓▓▓▓ MM Client Polish
UI Dev       ▓▓▓▓▓▓▓▓ Loading Screen
UI Integ     ▓▓▓▓ Match Found Integration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 8
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Backend Code Review
Backend      ▓▓▓▓▓▓▓▓ Edgegap Integration [CRITICAL]
Core Dev     ▓▓▓▓▓▓▓▓ Server Connection Handler
UI Dev       ▓▓▓▓ UI Polish
UI Integ     ▓▓▓▓▓▓▓▓ Loading Screen Integration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 9
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ---- (Testing prep)
Backend      ▓▓▓▓▓▓▓▓ Edgegap Integration Day 2
Core Dev     ▓▓▓▓▓▓▓▓ Connection Handler Polish
UI Dev       ---- (Ready for next phase)
UI Integ     ▓▓▓▓ Error Handling System
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 10
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓▓▓▓▓ Multi-Client Testing [START]
Backend      ▓▓▓▓▓▓▓▓ Match Lifecycle Manager
Core Dev     ▓▓▓▓▓▓▓▓ Server Build Config [START MP]
UI Dev       ▓▓▓▓ HUD Design Import
UI Integ     ▓▓▓▓ Error Handling Polish
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MILESTONE 2 ✓: Matchmaking Working
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### WEEK 3: Multiplayer Racing (Days 11-15)

```
Day 11
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓▓▓▓▓ Multi-Client Testing [CONT]
Backend      ▓▓▓▓ Match End Notification
Core Dev     ▓▓▓▓▓▓▓▓ Vehicle Replication [CRITICAL] Day 1
UI Dev       ▓▓▓▓▓▓▓▓ Multiplayer HUD Implementation
UI Integ     ---- (Waiting for CD-010)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 12
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Network Code Review
Backend      ▓▓▓▓▓▓▓▓ Server Health Monitoring
Core Dev     ▓▓▓▓▓▓▓▓ Vehicle Replication [CRITICAL] Day 2
UI Dev       ▓▓▓▓ Player List Widget
UI Integ     ---- (Waiting for CD-010)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 13
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ---- (Testing support)
Backend      ▓▓▓▓▓▓▓▓ Disconnect Handling
Core Dev     ▓▓▓▓▓▓▓▓ Client Prediction [CRITICAL]
UI Dev       ▓▓▓▓▓▓▓▓ Position Indicators
UI Integ     ▓▓▓▓▓▓▓▓ Player List Integration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 14
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓▓▓▓▓ 4-Client Integration Test
Backend      ▓▓▓▓ Logging & Debug Tools
Core Dev     ▓▓▓▓▓▓▓▓ Client Prediction Polish + VN_Tour
UI Dev       ▓▓▓▓▓▓▓▓ Results Screen
UI Integ     ▓▓▓▓ Position Sync
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 15
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓▓▓▓▓ Bandwidth Optimization
Backend      ---- (Ready for deploy prep)
Core Dev     ▓▓▓▓▓▓▓▓ Debug Viz + Collision Config
UI Dev       ---- (UI Complete)
UI Integ     ▓▓▓▓▓▓▓▓ Results Integration + Systems
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MILESTONE 3 ✓: Multiplayer Racing Working
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### DAYS 16-18: Integration & Polish (Optional Buffer)

```
Day 16-17 (If needed)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓▓▓▓▓ Integration Testing + Profiling
Backend      ▓▓▓▓▓▓▓▓ Staging Deployment + Config
Core Dev     ▓▓▓▓▓▓▓▓ Bug Fixes + Optimization
UI Dev       ▓▓▓▓▓▓▓▓ Bug Fixes + Polish
UI Integ     ▓▓▓▓▓▓▓▓ E2E Testing + Edge Cases
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Day 18 (Buffer)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Team Lead    ▓▓▓▓ Final Review + Documentation
Backend      ▓▓▓▓▓▓▓▓ Production Deploy + Dashboard
Core Dev     ▓▓▓▓ Telemetry + Final Fixes
UI Dev       ▓▓▓▓ Performance Optimization + Docs
UI Integ     ▓▓▓▓▓▓▓▓ Integration Test Suite
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

MILESTONE 4 ✓: Production Ready
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## CRITICAL PATH ANALYSIS

### Critical Path (Must finish on time):

```
Day 1-3:  Foundation Setup (All parallel) ✓
Day 4-9:  Backend Matchmaking Chain ⚠️ CRITICAL
          BE-006 → BE-007 → BE-008 → BE-009 → BE-010
          (5 days critical path)

Day 10-14: Core Dev Replication Chain ⚠️ CRITICAL
           CD-009 → CD-010 → CD-011 → CD-013
           (5 days critical path)

Day 15-17: Integration Testing ⚠️ ALL HANDS
           (3 days all team)
```

**Total Critical Path**: 13-15 days

---

## DEPENDENCIES MAP

### Day 4-5 Dependencies:
```
TL-005 ←── BE-005 (DB Schema done)
BE-006 ←── BE-003 (PostgreSQL ready)
CD-005 ←── BE-006 (Auth API ready)
```

### Day 6-9 Dependencies:
```
BE-007 ←── BE-006 + TL-005 (Auth + Flow design)
CD-007 ←── CD-006 + BE-007 (Client auth + Queue API)
BE-009 ←── BE-004 + BE-008 (Edgegap ready + Match created)
CD-008 ←── CD-007 + BE-010 (MM client + Lifecycle)
```

### Day 10-14 Dependencies:
```
CD-010 ←── CD-008 + CD-009 (Connection + Server build)
INT-008 ←── UI-007 + CD-010 (UI ready + Replication)
CD-011 ←── CD-010 (Replication working)
INT-010 ←── UI-009 + BE-011 (UI ready + Match end API)
```

---

## PARALLEL WORK STREAMS

### Stream 1: Backend (Critical Path)
```
Days 1-3:  Setup
Days 4-9:  Matchmaking [CRITICAL]
Days 10-14: Support Core Dev
Days 15-17: Deployment
```

### Stream 2: Core Dev (Critical Path)
```
Days 1-3:  Setup
Days 4-9:  Client Integration
Days 10-14: Replication [CRITICAL]
Days 15-17: Bug Fixes
```

### Stream 3: UI (Parallel, can work ahead)
```
Days 1-3:  Base Widgets (Design import)
Days 4-9:  Screens Implementation
Days 10-14: HUD + Results
Days 15-17: Polish
```

### Stream 4: UI Integration (Depends on all)
```
Days 1-3:  Foundation
Days 4-9:  Connect UI to Backend
Days 10-14: Connect to Game State
Days 15-17: E2E Testing
```

### Stream 5: Team Lead (Oversight + Unblocking)
```
Days 1-3:  Architecture + Setup
Days 4-9:  Code Review + Testing
Days 10-14: Integration Testing
Days 15-17: Final QA
```

---

## RISK HOTSPOTS

### Week 2 (Days 6-9): Backend Bottleneck ⚠️
**Risk**: Backend Engineer on critical path với nhiều complex tasks
**Mitigation**: 
- Pair programming với Team Lead
- Simplify scope nếu cần
- Prepare fallback solutions

### Week 3 (Days 11-13): Replication Complexity ⚠️
**Risk**: Vehicle replication phức tạp, có thể vượt estimate
**Mitigation**:
- Start simple (position only)
- Iterate gradually
- Có debug tools sẵn

### Week 3 (Days 14-15): Integration Dependencies ⚠️
**Risk**: Nhiều tasks depend on nhau, blocking có thể cascade
**Mitigation**:
- Daily sync meetings
- Mock data fallbacks
- Parallel testing với mocks

---

## RESOURCE ALLOCATION

### Developer Workload (Story Points)

```
                  Week 1    Week 2    Week 3    Total
Team Lead         15 pts    15 pts    25 pts    55 pts
Backend           20 pts    50 pts    20 pts    90 pts ⚠️ HIGH
Core Dev          20 pts    35 pts    60 pts    115 pts ⚠️ HIGHEST
UI Dev            18 pts    20 pts    15 pts    53 pts
UI Integration    18 pts    25 pts    20 pts    63 pts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL            91 pts    145 pts   140 pts   376 pts
```

### Workload Balance:
- **Core Dev**: Most loaded (115 pts) - **Monitor closely**
- **Backend**: High load (90 pts) - **Critical path**
- **UI Dev**: Balanced (53 pts) - **Can help integration**
- **UI Integration**: Moderate (63 pts) - **Flexible**
- **Team Lead**: Moderate (55 pts) - **Available for support**

---

## DAILY STANDUP FORMAT

### Daily Questions:
1. **What did I complete yesterday?**
2. **What will I work on today?**
3. **Any blockers or dependencies?**
4. **Integration points with other devs?**

### Check Critical Path:
- **Days 1-3**: Everyone on track?
- **Days 4-9**: Backend on schedule?
- **Days 10-14**: Core Dev replication progressing?
- **Days 15-17**: All integration issues resolved?

---

## MILESTONE DEMOS

### Demo 1 (End of Day 3):
**Time**: 30 minutes  
**Content**:
- Architecture walkthrough
- Development environment tour
- UI design preview (imported assets)
- Q&A

### Demo 2 (End of Day 10):
**Time**: 45 minutes  
**Content**:
- Live matchmaking demo (queue → match found)
- Backend architecture review
- Network setup demonstration
- Q&A

### Demo 3 (End of Day 15):
**Time**: 60 minutes  
**Content**:
- Full multiplayer race (4 players)
- All features working end-to-end
- Performance metrics
- Known issues và plan
- Q&A

### Final Demo (Day 18):
**Time**: 90 minutes  
**Content**:
- Production-quality demo
- Full feature showcase
- Integration với existing systems (VN_Tour, Shop)
- Performance report
- Next steps và roadmap
- Extended Q&A

---

## OPTIMIZATIONS APPLIED

### Original Plan (20 days) → Optimized Plan (12-15 days)

#### Savings Breakdown:
1. **UI Design Ready** → Saved 3-4 days
   - No wireframe phase
   - No design iteration
   - Direct implementation từ design specs

2. **Perforce + Jenkins Pre-existing** → Saved 1 day
   - No VCS setup
   - CI/CD already configured
   - Just need pipeline adjustments

3. **Parallel Work Optimization** → Saved 2 days
   - UI can work fully ahead with mock data
   - Backend và Core Dev overlap reduced
   - Integration testing während development

4. **Simplified Scope** → Saved 1-2 days
   - No private rooms
   - No friend invites  
   - No ranking system in v1
   - Focus on core multiplayer only

**Total Savings**: 7-9 days
**Original**: 20 days → **Optimized**: 12-15 days

---

## REALISTIC TIMELINE SCENARIOS

### Best Case (12 days):
- No major blockers
- Backend completes matchmaking Day 8
- Replication works first try Day 12
- Minimal bug fixing needed
- **Ship Date**: Day 12

### Expected Case (13-14 days):
- Minor blockers resolved quickly
- Backend matchmaking done Day 9
- Replication needs 1 iteration
- Standard bug fixing
- **Ship Date**: Day 14

### Worst Case (15-18 days):
- Significant replication issues
- Edgegap integration delays
- Multiple bug fix cycles
- Need full integration buffer
- **Ship Date**: Day 17-18

**Recommended Commitment**: **15 days** (safe estimate)

---

## YOUTRACK GANTT SETUP

### Step 1: Import Tasks
1. Import all 72 tasks từ YouTrack_Tasks_Import.md
2. Set story points và time estimates
3. Link dependencies

### Step 2: Generate Gantt
1. YouTrack → Reports → Gantt Chart
2. Group by: Epic
3. Color by: Assignee
4. Show: Dependencies, Critical Path
5. Date range: Start date + 15 days

### Step 3: Track Progress
1. Update task status daily
2. Gantt auto-adjusts timeline
3. Monitor critical path delays
4. Re-baseline nếu cần

### Step 4: Export và Share
1. Export PNG cho stakeholders
2. Weekly progress screenshots
3. Share link cho team

---

## TOOLING INTEGRATION

### Perforce Integration:
```
Branch Structure:
//PrototypeRacing/Main
//PrototypeRacing/Multiplayer (working branch)
//PrototypeRacing/Multiplayer/Dev/* (developer branches)
```

### Jenkins Integration:
```
Pipelines:
1. Server Build: Trigger on commit to //Multiplayer/Server
2. Client Build: Trigger on commit to //Multiplayer/Client
3. Integration Tests: Nightly
4. Deploy to Edgegap: Manual trigger
```

### YouTrack Integration:
```
Commit Messages:
MP-XXX: Task description
Example: MP-BE-007: Implement matchmaking queue system

Auto-link commits to YouTrack tasks
```

---

**Document Version**: 2.0  
**Timeline**: Optimized 12-15 days  
**Last Updated**: 14/10/2025  
**Status**: Ready for YouTrack Import

