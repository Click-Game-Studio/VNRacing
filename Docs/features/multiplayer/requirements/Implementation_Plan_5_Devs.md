# KẾ HOẠCH TRIỂN KHAI MULTIPLAYER DEMO
## Dự án: PrototypeRacing - Module Multiplayer

**Phiên bản**: 1.0  
**Ngày tạo**: 14/10/2025  
**Cập nhật**: 14/10/2025  
**Team size**: 5 developers  
**Công cụ**: YouTrack, Perforce, Jenkins CI/CD  

---

## 1. CẤU TRÚC TEAM VÀ VAI TRÒ

### 1.1. Phân công vai trò

| Vai trò | Số lượng | Trách nhiệm chính |
|---------|----------|-------------------|
| **Team Lead** | 1 | Architecture, technical oversight, integration coordination, code review, Jenkins setup |
| **Backend Engineer** | 1 | Nakama server setup, Edgegap integration, matchmaking logic, API development |
| **Core Developer** | 1 | Unreal multiplayer implementation, replication, network code, VN_Tour integration |
| **UI Developer** | 1 | Implement UI screens từ design có sẵn, UMG widgets, animations |
| **UI Integration** | 1 | Connect UI to backend, state management, data binding, existing systems integration |

**NOTE**: Đã có team design UI riêng → UI Developer chỉ cần implement theo design specs, không cần design phase

---

## 2. PHÂN TÍCH DEPENDENCIES VÀ CRITICAL PATH

### 2.1. Dependency Graph

```
[Backend Setup] → [Matchmaking Logic] → [Integration Testing]
       ↓                    ↓                      ↑
[Core Multiplayer] → [Replication] → [Debug Tools] ─┘
       ↓                    ↓
[UI Foundation] → [UI Screens] → [UI Integration] ──┘
       ↑
[Team Lead: Architecture & Design]
```

### 2.2. Critical Path Analysis

**Critical Path** (tasks that directly impact timeline):
1. Backend Setup (Nakama + Edgegap) - **5 ngày**
2. Matchmaking Logic - **4 ngày**
3. Core Multiplayer Replication - **3 ngày**
4. Integration Testing - **4 ngày**

**Total Critical Path**: approximately 16 ngày

**Parallel Paths** (có thể làm đồng thời):
- UI Development (có thể bắt đầu sớm với mock data)
- Documentation và setup tools

---

## 3. BREAKDOWN TASKS CHI TIẾT THEO FEATURE GROUP

### 3.1. FEATURE GROUP 1: Foundation & Setup (Ngày 1-3)

#### 3.1.1. Team Lead Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| TL-001 | Thiết kế architecture tổng quan cho multiplayer module | 0.5 ngày | - | Architecture Document |
| TL-002 | Setup Perforce workflow và branching strategy cho multiplayer | 0.5 ngày | - | Perforce Guidelines |
| TL-003 | Định nghĩa data structures cho matchmaking và game session | 1 ngày | - | Data Schema Document |
| TL-004 | Setup CI/CD pipeline cho game server builds | 1 ngày | - | Build Pipeline |

**Total**: 3 ngày

#### 3.1.2. Backend Engineer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| BE-001 | Research và setup Nakama development environment | 1 ngày | - | Dev Environment |
| BE-002 | Tạo Nakama và configure basic settings | 0.5 ngày | BE-001 | Nakama Project |
| BE-003 | Setup PostgreSQL database cho Nakama | 0.5 ngày | BE-002 | Database Instance |
| BE-004 | Research Edgegap API | 0.5 ngày | - | Edgegap Account |
| BE-005 | Thiết kế database schema cho match data | 0.5 ngày | TL-003 | DB Schema |

**Total**: 3 ngày

#### 3.1.3. Core Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| CD-001 | Setup Unreal project branch cho multiplayer | 0.5 ngày | TL-002 | Project Branch |
| CD-002 | Tạo base classes cho multiplayer: GameMode, Character, Controller, ... | 1 ngày | TL-003 | Base Classes |
| CD-003 | Implement basic networking configuration | 0.5 ngày | CD-002 | Network Config |
| CD-004 | Create multiplayer test map | 1 ngày | - | Test Map |

**Total**: 3 ngày

#### 3.1.4. UI Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| UI-001 | Thiết kế wireframes cho 3 màn hình multiplayer | 1 ngày | TL-001 | Wireframes |
| UI-002 | Tạo base widget classes và style guide | 1 ngày | UI-001 | Base Widgets |
| UI-003 | Implement mode selection screen (mockup) | 1 ngày | UI-002 | Screen 1 |

**Total**: 3 ngày

#### 3.1.5. UI Integration Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| INT-001 | Setup blueprint communication architecture | 1 ngày | TL-001, CD-002 | BP Architecture |
| INT-002 | Tạo mock data service cho UI testing | 1 ngày | TL-003 | Mock Service |
| INT-003 | Implement basic state management system | 1 ngày | INT-001 | State Manager |

**Total**: 3 ngày

**FEATURE GROUP 1 MILESTONE**: 
- ✅ Development environment
- ✅ Base classes, architecture
- ✅ UI mockups ready integration
- **Demo**: Có thể show wireframes và basic project structure

---

### 3.2. FEATURE GROUP 2: Matchmaking System (Ngày 4-9)

#### 3.2.1. Team Lead Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| TL-005 | Define matchmaking flow và state machine | 1 ngày | BE-005 | Flow Diagram |
| TL-006 | Code review backend matchmaking logic | 0.5 ngày | BE-008 | Review Report |
| TL-007 | Test matchmaking với multiple clients | 1 ngày | BE-010 | Test Report |
| TL-008 | Document API endpoints và protocols | 0.5 ngày | BE-010 | API Documentation |

**Total**: 3 ngày

#### 3.2.2. Backend Engineer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| BE-006 | Implement Nakama authentication flow (device ID) | 1 ngày | BE-003 | Auth Module |
| BE-007 | Develop matchmaking queue system (4 players) | 2 ngày | BE-006, TL-005 | Queue System |
| BE-008 | Implement match creation logic | 1 ngày | BE-007 | Match Creator |
| BE-009 | Setup Edgegap API integration cho server provisioning | 1.5 ngày | BE-004, BE-008 | Server Provisioning |
| BE-010 | Handle match lifecycle (creation, start, end) | 1.5 ngày | BE-009 | Lifecycle Manager |

**Total**: 7 ngày

#### 3.2.3. Core Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| CD-005 | Integrate Nakama C++ SDK vào Unreal | 1 ngày | BE-006 | SDK Integration |
| CD-006 | Implement client authentication flow | 1 ngày | CD-005, BE-006 | Auth Client |
| CD-007 | Develop matchmaking client logic | 1.5 ngày | CD-006, BE-007 | MM Client |
| CD-008 | Handle server connection và session join | 1.5 ngày | CD-007, BE-010 | Connection Handler |

**Total**: 5 ngày

#### 3.2.4. UI Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| UI-004 | Implement queue screen với animations | 1.5 ngày | UI-003 | Queue Screen |
| UI-005 | Design và implement match found notification | 1 ngày | UI-004 | Match Found UI |
| UI-006 | Create countdown và loading screen | 1 ngày | UI-005 | Loading Screen |
| UI-007 | Polish UI animations và transitions | 1 ngày | UI-006 | Polished UI |

**Total**: 4.5 ngày

#### 3.2.5. UI Integration Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| INT-004 | Connect queue screen to matchmaking service | 1.5 ngày | UI-004, CD-007 | Queue Integration |
| INT-005 | Implement match found logic và transition | 1 ngày | UI-005, BE-008 | Match Found Logic |
| INT-006 | Handle loading screen data binding | 1 ngày | UI-006, CD-008 | Loading Integration |
| INT-007 | Implement error handling và retry logic | 1 ngày | INT-006 | Error Handler |

**Total**: 4.5 ngày

**FEATURE GROUP 2 MILESTONE**:
- ✅ Matchmaking system hoàn chỉnh
- ✅ Players có thể queue và được ghép trận
- ✅ UI flows working end-to-end với mock data
- **Demo**: Queue → Match Found → Waiting for server (với mock)

---

### 3.3. FEATURE GROUP 3: In-Game Multiplayer (Ngày 10-15)

#### 3.3.1. Team Lead Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| TL-009 | Review network replication architecture | 1 ngày | CD-011 | Review Report |
| TL-010 | Test multiplayer với 4 clients | 1.5 ngày | CD-013 | Test Cases |

**Total**: 2.5 ngày

#### 3.3.2. Backend Engineer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| BE-011 | Implement match end notification system | 1 ngày | BE-010 | End Match API |
| BE-012 | Create game server health monitoring | 1.5 ngày | BE-009 | Health Monitor |
| BE-013 | Implement player disconnect handling | 1 ngày | BE-012 | Disconnect Handler |
| BE-014 | Setup logging và debugging tools | 1 ngày | BE-013 | Debug Tools |

**Total**: 4.5 ngày

#### 3.3.3. Core Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| CD-009 | Setup game server build configuration | 1 ngày | CD-004 | Server Build |
| CD-010 | Implement vehicle replication (simulated clients) | 2 ngày | CD-008, CD-009 | Replication System |
| CD-011 | Configure client-side prediction cho owning client | 1.5 ngày | CD-010 | Client Prediction |
| CD-012 | Disable collision cho simulated vehicles | 0.5 ngày | CD-010 | Collision Config |
| CD-013 | Implement debug visualization (boxes) | 1 ngày | CD-011 | Debug Viz |

**Total**: 6 ngày

#### 3.3.4. UI Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| UI-008 | Implement in-game multiplayer HUD | 1.5 ngày | UI-007 | HUD Design |
| UI-009 | Implement player list widget | 1 ngày | UI-008 | Player List |
| UI-010 | Create race position indicators | 1 ngày | UI-009 | Position UI |
| UI-011 | Implement end-race results screen | 1 ngày | UI-010 | Results Screen |

**Total**: 4.5 ngày

#### 3.3.5. UI Integration Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| INT-008 | Bind player list to game state | 1 ngày | UI-009, CD-010 | Player List Binding |
| INT-009 | Update position indicators real-time | 1 ngày | UI-010, CD-010 | Position Sync |
| INT-010 | Implement results screen data | 1.5 ngày | UI-011, BE-011 | Results Logic |

**Total**: 3.5 ngày

**FEATURE GROUP 3 MILESTONE**:
- ✅ Multiplayer racing hoàn chỉnh
- ✅ 4 players có thể race cùng lúc
- ✅ No collision, basic replication working
- **Demo**: Full multiplayer race from queue to finish

---

### 3.4. FEATURE GROUP 4: Integration & Polish (Ngày 16-20)

#### 3.4.1. Team Lead Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| TL-012 | Comprehensive integration testing | 2 ngày | Tất cả modules | Test Report |
| TL-013 | Performance profiling | 1.5 ngày | TL-012 | Performance Report |
| TL-014 | Create deployment documentation | 1 ngày | TL-013 | Deploy Docs |
| TL-015 | Final code review và refactoring | 1 ngày | TL-014 | Clean Code |

**Total**: 5.5 ngày

#### 3.4.2. Backend Engineer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| BE-015 | Deploy Nakama to staging environment | 1 ngày | BE-014 | Staging Server |
| BE-016 | Upload game server build to Edgegap | 1 ngày | CD-009 | Server Deployment |
| BE-017 | Configure production settings | 1 ngày | BE-015, BE-016 | Prod Config |
| BE-018 | Test monitoring dashboard | 1.5 ngày | BE-017 | Dashboard |

**Total**: 4.5 ngày

#### 3.4.3. Core Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| CD-014 | Fix bugs from integration testing | 2 ngày | TL-012 | Bug Fixes |
| CD-015 | Optimize code | 2 ngày | TL-013 | Optimized Code |

**Total**: 4 ngày

#### 3.4.4. UI Developer Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| UI-012 | Fix UI bugs và visual issues | 1.5 ngày | TL-012 | Bug Fixes |
| UI-013 | Polish animations và transitions | 1 ngày | UI-012 | Polished UI |
| UI-014 | Optimize UI performance | 1 ngày | TL-013 | Optimized UI |
| UI-015 | Create UI documentation | 0.5 ngày | UI-014 | UI Docs |

**Total**: 4 ngày

#### 3.4.5. UI Integration Tasks

| Task ID | Mô tả | Thời gian | Dependencies | Output |
|---------|-------|-----------|--------------|--------|
| INT-011 | End-to-end flow testing | 2 ngày | Tất cả modules | Flow Tests |
| INT-012 | Handle edge cases và error scenarios | 1.5 ngày | INT-011 | Error Handling |
| INT-013 | Create integration test suite | 1 ngày | INT-012 | Test Suite |

**Total**: 4.5 ngày

**FEATURE GROUP 4 MILESTONE**:
- ✅ Full system integrated và tested
- 🔄 Development ready deployment
- ✅ Documentation hoàn chỉnh
- **Demo**: Production multiplayer demo

---

## 4. TIMELINE VÀ GANTT CHART

### 4.1. Timeline Overview

```
Week 1 (Ngày 1-5): Foundation + Matchmaking Start
├── Day 1-3: Feature Group 1 (All parallel)
└── Day 4-5: Feature Group 2 starts

Week 2 (Ngày 6-10): Matchmaking Complete + Multiplayer Start  
├── Day 6-9: Feature Group 2 (Backend critical path)
└── Day 10: Feature Group 3 starts

Week 3 (Ngày 11-15): Multiplayer Complete
├── Day 11-15: Feature Group 3 (Core dev critical path)
└── Prep for integration

Week 4 (Ngày 16-20): Integration & Polish
└── Day 16-20: Feature Group 4 (Testing & deployment)
```

### 4.2. Resource Allocation Chart

| Developer | Week 1 | Week 2 | Week 3 | Week 4 | Total Days |
|-----------|--------|--------|--------|--------|------------|
| Team Lead | Setup (3d)| Review (3d) | Test (3.5d) | Final (5.5d) | 15 |
| Backend | Setup (3d)| Matchmaking (7d) | In-game (4.5d) | Deploy (4.5d) | 19 |
| Core Dev | Setup (3d)| Client (5d) | Replication (6d) | Polish (4d) | 18 |
| UI Dev | Mockup (3d)| Screens (4.5d) | HUD (4.5d) | Polish (4d) | 16 |
| UI Integration | Foundation (3d) | Connect (4.5d) | Bind (3.5d) | Test (4.5d) | 15.5 |

---

## 5. RISK MITIGATION & CONTINGENCY

### 5.1. Identified Risks

| Risk | Probability | Impact | Mitigation Strategy | Contingency Plan |
|------|------------|--------|---------------------|------------------|
| Nakama learning curve | High | High | - Dedicated research time (Day 1)<br>- Pair programming sessions<br>- Online resources | - Extend backend timeline +2 days<br>- Simplify matchmaking logic |
| Edgegap setup issues | Medium | High | - Early account setup<br>- Test deployment ASAP<br>- Support tickets ready | - Use local server testing<br>- Manual server management |
| Network replication bugs | High | Medium | - Start with simple replication<br>- Incremental testing<br>- Debug tools early | - Reduce player count to 2<br>- Simplify sync |
| UI-Backend integration | Medium | Medium | - Mock data early<br>- Clear API contracts<br>- Daily sync meetings | - Keep mock fallbacks<br>- Phased integration |
| Timeline overrun | High | High | - Buffer days built in<br>- Parallel work streams<br>- Daily standups | - Cut nice-to-have features<br>- Extend by 3-5 days |

### 5.2. Daily Standup Structure

**Format**: 15 phút mỗi sáng

### 5.3. Code Review Process

- **Frequency**: Sau mỗi feature completion
- **Reviewer**: Team Lead + 1 peer
- **Checklist**:
  - Code quality
  - Performance implications
  - Mobile compatibility
  - Documentation

---

## 6. DEMO POINTS VÀ DELIVERABLES

### 6.1. Demo Schedule

| Demo Point | Timing | Content | Audience |
|------------|--------|---------|----------|
| **Demo 1** | End of Week 1 | - Architecture walkthrough<br>- UI mockups<br>- Basic matchmaking flow | Internal team |
| **Demo 2** | End of Week 2 | - Working matchmaking<br>- Queue to match found<br>- Server provisioning | Stakeholders |
| **Demo 3** | End of Week 3 | - Full multiplayer race<br>- 4 players racing<br>- End-to-end flow | QA + Stakeholders |
| **Final Demo** | End of Week 4 | - Production-ready demo<br>- Full feature showcase<br>- Performance metrics | All stakeholders |

### 6.2. Deliverables Checklist

**Week 1**:
- [ ] Architecture document
- [ ] Development environment setup guide
- [ ] UI wireframes
- [ ] Base classes implemented

**Week 2**:
- [ ] Nakama server running
- [ ] Matchmaking logic functional
- [ ] Client authentication working
- [ ] UI screens 80% complete

**Week 3**:
- [ ] Game server builds
- [ ] Replication working
- [ ] Multiplayer racing functional
- [ ] Debug tools ready

**Week 4**:
- [ ] Production deployment
- [ ] Full documentation
- [ ] Test reports
- [ ] Performance benchmarks

---

## 7. SUCCESS CRITERIA

### 7.1. Functional Requirements

✅ **Must Have** (MVP):
- [ ] 4 players có thể queue simultaneously
- [ ] Matchmaking ghép đủ 4 người
- [ ] Game server tự động spin up via Edgegap
- [ ] Players có thể race cùng nhau
- [ ] No collision giữa players
- [ ] Race kết thúc và return to menu

❌ **Limitations**:

- No private rooms
- No friend invites
- No MMR/ranking system
- No anti-cheat validation
- No replay system
- No spectator mode
- No chat/voice comm

### 7.2. Non-Functional Requirements

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Matchmaking Time** | < 30 giây (với 4 players ready) | Timer logs |
| **Server Spin-up Time** | < 60 giây | Edgegap metrics |
| **Network Latency** | < 100ms (same region) | Ping monitoring |
| **Frame Rate** | > 30 FPS (mobile) | In-game profiler |
| **Success Rate** | > 90% (matches complete) | Analytics |

---

## CHANGELOG

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 14/10/2025 | 1.0 | Initial implementation plan created | Team Lead |

