# QUICK REFERENCE - TEAM ASSIGNMENTS & KEY TASKS

## 📋 OVERVIEW
- **Timeline**: 2.5-3 tuần (12-15 ngày) - OPTIMIZED ✨
- **Team Size**: 5 developers
- **Target**: Multiplayer Demo (4 players, no collision)
- **Tools**: YouTrack (tracking), Perforce (VCS), Jenkins (CI/CD)

### What Changed (v2.0):
- ✅ Timeline optimized từ 20 ngày → 12-15 ngày
- ✅ UI design có sẵn từ design team (save 3-4 days)
- ✅ Perforce + Jenkins already setup
- ✅ Added VN_Tour integration tasks

---

## 👥 TEAM ROLES & WORKLOAD

| Role | Total Tasks | Story Points | Critical Path? | Notes |
|------|-------------|--------------|----------------|-------|
| **Team Lead** | 15 tasks | 55 pts | ⚠️ Yes (integration) | Oversight + unblocking |
| **Backend** | 18 tasks | 90 pts | ✅ **YES** (critical) | Week 2 bottleneck |
| **Core Dev** | 17 tasks | 115 pts | ✅ **YES** (critical) | Most loaded, Week 3 |
| **UI Dev** | 13 tasks | 53 pts | No (parallel) | Has design assets ✨ |
| **UI Integration** | 9 tasks | 63 pts | ⚠️ Yes (final stage) | Ties everything together |

---

## 🎯 CRITICAL PATH (Must complete on time)

### Week 1: Foundation
```
Backend: Setup Nakama (3 days) → All parallel
Core Dev: Base classes (3 days) → All parallel
```

### Week 2: Matchmaking (CRITICAL!)
```
Backend: Auth (1d) → Queue (2d) → Match (1d) → Edgegap (1.5d) → Lifecycle (1.5d)
                                             ↓
Core Dev: SDK (1d) → Auth (1d) → MM Client (1.5d) → Connection (1.5d)
```
**Critical Chain**: 7 days + 5 days = Backend drives timeline

### Week 3: Multiplayer Racing (CRITICAL!)
```
Core Dev: Server Build (1d) → Replication (2d) → Prediction (1.5d) → Debug (1d)
```
**Critical**: Core Dev drives this week (6 days)

### Week 4: Integration (CRITICAL!)
```
Team Lead: Testing (2d) → Performance (1.5d) → Deploy (1d) → Review (1d)
All Team: Bug fixes and polish
```

---

## 📅 WEEKLY FOCUS

### WEEK 1 (Days 1-5): Setup Everything
**Goal**: Development environments ready, foundations laid

**New in v2**: Perforce workflow, Jenkins CI/CD setup

| Developer | Primary Focus | Key Deliverable |
|-----------|---------------|-----------------|
| Team Lead | Architecture & Perforce | Architecture + Perforce workflow |
| Backend | Nakama Setup | Working Nakama instance |
| Core Dev | Base Classes | Multiplayer base code |
| UI Dev | Import Design Assets & Base Widgets | Implemented screens (no design phase) ✨ |
| UI Integration | Mock Data System | Testing framework |

**Demo**: Show architecture + wireframes

---

### WEEK 2 (Days 6-10): Matchmaking System
**Goal**: Players can queue and be matched

| Developer | Primary Focus | Key Deliverable |
|-----------|---------------|-----------------|
| Team Lead | Review & Test | Flow diagrams, test reports |
| Backend | **Matchmaking Logic** ⚠️ | Working MM + Edgegap |
| Core Dev | **Client Integration** ⚠️ | Connect to Nakama |
| UI Dev | Queue Screens | Beautiful UI screens |
| UI Integration | Connect UI to Backend | Working queue flow |

**Demo**: Queue → Match Found → Waiting (working!)

---

### WEEK 3 (Days 11-15): Multiplayer Racing
**Goal**: 4 players racing together

**New in v2**: VN_Tour integration added

| Developer | Primary Focus | Key Deliverable |
|-----------|---------------|-----------------|
| Team Lead | Testing & Optimization | Test with 4 clients |
| Backend | Match Lifecycle | Match end, monitoring |
| Core Dev | **Replication + VN_Tour** ⚠️ | Racing multiplayer + system integration |
| UI Dev | In-Game HUD | Player list, positions |
| UI Integration | Bind Game State | Real-time updates |

**Demo**: Full multiplayer race!

---

### BUFFER DAYS (Days 16-18): Integration & Polish (If Needed)
**Goal**: Production-ready demo

**Note**: With optimizations, may finish by Day 12-15

| Developer | Primary Focus | Key Deliverable |
|-----------|---------------|-----------------|
| Team Lead | **Final Testing** ⚠️ | Sign-off |
| Backend | Deployment | Staging + Prod |
| Core Dev | Bug Fixes | Clean code |
| UI Dev | Polish | Beautiful animations |
| UI Integration | **Integration Tests** ⚠️ | Test suite |

**Demo**: Production quality showcase!

---

## 🚨 DEPENDENCIES TO WATCH

### Backend → Core Dev
- Backend MUST complete Auth (Day 4) before Core Dev can integrate (Day 6)
- Backend MUST complete Matchmaking (Day 8) before Core Dev can test (Day 9)
- Backend MUST deploy Edgegap (Day 9) before Core Dev can connect (Day 10)

### Core Dev → UI Integration
- Core Dev MUST finish base classes (Day 3) before Integration can start
- Core Dev MUST expose game state (Day 12) before Integration can bind UI

### UI Dev → UI Integration
- UI Dev MUST finish screens (Day 7) before Integration can connect data
- UI Dev should work ahead with mock data (NO BLOCKERS)

---

## ⚡ DAILY COORDINATION POINTS

### Days 1-3 (Setup)
- **No blockers**: Everyone works independently
- Daily standup: Share progress on setup

### Days 4-9 (Matchmaking)
- **Critical coordination**: Backend ↔ Core Dev
- **Daily sync** (30 min): API contracts, data structures
- UI works ahead with mocks

### Days 10-15 (Racing)
- **Critical coordination**: Core Dev ↔ UI Integration
- **Daily sync** (30 min): Game state, replication events
- Backend on support mode

### Days 16-20 (Integration)
- **All hands**: Everyone testing and fixing
- **Multiple check-ins**: Morning + afternoon
- Team Lead coordinates fixes

---

## 📊 TASK PRIORITY MATRIX

### P0 - MUST HAVE (Cannot ship without)
- ✅ Nakama authentication
- ✅ Basic matchmaking (4 players)
- ✅ Edgegap server spin-up
- ✅ Vehicle replication
- ✅ No collision working
- ✅ UI flow (queue → race → end)

### P1 - SHOULD HAVE (Important for demo)
- ⚠️ Error handling
- ⚠️ Loading screens
- ⚠️ Debug visualization
- ⚠️ Basic HUD

### P2 - NICE TO HAVE (If time permits)
- ❌ Reconnection
- ❌ Better animations
- ❌ Sound effects
- ❌ Analytics

---

## 🎬 DEMO CHECKPOINTS

### Demo 1 (End of Week 1)
**Audience**: Internal team  
**Duration**: 15 minutes  
**Content**:
- Architecture walkthrough (5 min)
- UI mockups (5 min)
- Setup demos (5 min)

### Demo 2 (End of Week 2)
**Audience**: Stakeholders  
**Duration**: 30 minutes  
**Content**:
- Matchmaking live demo (15 min)
- Technical walkthrough (10 min)
- Q&A (5 min)

### Demo 3 (End of Week 3)
**Audience**: QA + Stakeholders  
**Duration**: 45 minutes  
**Content**:
- Full multiplayer race (20 min)
- Edge cases demo (10 min)
- Performance metrics (10 min)
- Q&A (5 min)

### Final Demo (End of Week 4)
**Audience**: All stakeholders  
**Duration**: 60 minutes  
**Content**:
- Production demo (30 min)
- Feature showcase (15 min)
- Next steps (10 min)
- Q&A (5 min)

---

## 🔥 RISK ALERTS

### HIGH RISK ⚠️
1. **Backend overload**: Critical path Week 2 (90 story points)
   - **Mitigation**: Pair programming with Team Lead on Days 6-9
   - **Track**: Daily progress in YouTrack
   
2. **Core Dev dependency**: Everything waits for replication
   - **Mitigation**: Start simple, iterate. Don't gold-plate.
   
3. **Integration hell**: Last week all comes together
   - **Mitigation**: Daily integration builds starting Week 2

### MEDIUM RISK ⚠️
1. **Nakama learning curve**: New tech for team
   - **Mitigation**: Day 1 dedicated research, online tutorials
   
2. **Edgegap setup**: Third-party dependency
   - **Mitigation**: Early setup, have fallback (local server)

---

## 💡 PRO TIPS

### For Team Lead
- 🎯 Focus on unblocking others in Weeks 2-3
- 📊 Track critical path daily
- 🚀 Prepare demos well in advance

### For Backend
- 🏃 You're on critical path - communicate blockers ASAP
- 🤝 Pair with Core Dev on API design (Day 4-5)
- 📝 Document everything for Core Dev

### For Core Dev
- 🏃 You're on critical path Week 3 - start simple
- 🐛 Build debug tools early (Day 10-11)
- ⚡ Don't optimize prematurely

### For UI Dev
- 🎨 You have most flexibility - work ahead!
- 📱 Use mock data liberally
- ✨ Polish as you go
- 🎁 **NEW**: Design assets ready - just implement! (save time)

### For UI Integration
- 🔌 You tie everything together - stay in sync
- 🧪 Build test harnesses early
- 🛠️ Error handling is your job - don't skip it

---

## 📞 ESCALATION PATH

**Minor Issues** → Ask in Slack → Resolve in standup  
**Blockers** → Notify Team Lead immediately → Sync meeting  
**Critical Issues** → Escalate to stakeholders → Adjust timeline

---

---

## 🛠️ TOOLING QUICK REFERENCE

### YouTrack
- **Project**: Multiplayer Demo (MP)
- **Task Format**: MP-{ROLE}-{NUM} (e.g., MP-BE-007)
- **Board**: Kanban view
- **Gantt**: Track critical path daily

### Perforce
- **Branch**: //PrototypeRacing/Multiplayer
- **Commit Format**: MP-XXX: Description
- **Sync**: Daily before standup
- **Submit**: After code review

### Jenkins
- **Server Build**: Auto-trigger on //Multiplayer/Server commits
- **Client Build**: Auto-trigger on //Multiplayer/Client commits
- **Tests**: Nightly integration tests
- **Deploy**: Manual trigger to Edgegap

---

## 📈 OPTIMIZED TIMELINE HIGHLIGHTS

### Time Savings:
- **UI Design Ready**: -3-4 days (no design phase)
- **Perforce/Jenkins Setup**: -1 day (already configured)
- **Parallel Optimization**: -2 days (better workflow)
- **Simplified Scope**: -1-2 days (no private rooms, etc.)

**Total**: 7-9 days saved → **12-15 day timeline** 🎉

### Critical Path Optimized:
```
Week 1 (Days 1-5):  Foundation [Parallel] ✓
Week 2 (Days 6-10): Backend MM [Critical] ⚠️
Week 3 (Days 11-15): Core Dev Replication [Critical] ⚠️
Buffer (Days 16-18): Integration [If needed]
```

---

**Last Updated**: 14/10/2025  
**Version**: 2.0 (Optimized)  
**Status**: Ready for kickoff with optimized timeline