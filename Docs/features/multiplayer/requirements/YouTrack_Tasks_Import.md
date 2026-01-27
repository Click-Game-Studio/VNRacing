# YOUTRACK TASK CARDS - MULTIPLAYER DEMO
## Import-Ready Format cho YouTrack

**Project**: PrototypeRacing  
**Module**: Multiplayer Demo  
**Sprint Duration**: 2.5-3 tuần (12-15 ngày)  
**Team Size**: 5 developers  

---

## CÁCH SỬ DụNG

1. **Import vào YouTrack**: Copy từng epic/story vào YouTrack
2. **Assign**: Gán cho đúng developer
3. **Set Dependencies**: Link tasks theo dependencies được định nghĩa
4. **Track Progress**: Update status daily

---

## EPIC 1: FOUNDATION & SETUP (Days 1-3)

### Epic Details
- **Epic ID**: MP-EPIC-001
- **Summary**: Foundation & Development Environment Setup
- **Priority**: Critical
- **Timeline**: Days 1-3
- **Team**: All developers

---

### STORY: TL-001 - Architecture Design
```
Type: Story
Priority: Critical
Assignee: Team Lead
Story Points: 3
Time Estimate: 4h
Tags: architecture, design, foundation

Description:
Thiết kế architecture tổng quan cho multiplayer module bao gồm:
- Component diagram
- Data flow
- Network architecture
- Integration points với existing systems (VN_Tour, Shop, Progression)

Acceptance Criteria:
[ ] Architecture document hoàn chỉnh
[ ] Component diagram được approve
[ ] Data structures được define
[ ] Integration points được xác định

Dependencies: None

Output: Architecture Document (Confluence)
```

---

### STORY: TL-002 - Perforce Workflow Setup
```
Type: Story
Priority: High
Assignee: Team Lead
Story Points: 3
Time Estimate: 4h
Tags: perforce, workflow, vcs

Description:
Setup Perforce workflow và branching strategy cho multiplayer module:
- Tạo branch structure
- Define merge policies
- Setup code review workflow
- Document best practices

Acceptance Criteria:
[ ] Branch //PrototypeRacing/Multiplayer created
[ ] Merge policies documented
[ ] Team trained on workflow
[ ] Code review process defined

Dependencies: None

Output: Perforce Guidelines Document
```

---

### STORY: TL-003 - Data Structure Definition
```
Type: Story
Priority: Critical
Assignee: Team Lead
Story Points: 5
Time Estimate: 8h
Tags: architecture, data-structures, design

Description:
Định nghĩa data structures chi tiết cho:
- Matchmaking queue data
- Game session data
- Player state replication
- Match results
- Integration với VN_Tour progression

Acceptance Criteria:
[ ] Data schemas documented
[ ] Database ERD created
[ ] Struct definitions in C++/Blueprint
[ ] Integration schemas với existing systems
[ ] Reviewed và approved

Dependencies: TL-001

Output: Data Schema Document + UE Structs
```

---

### STORY: TL-004 - Jenkins CI/CD Pipeline
```
Type: Story
Priority: High
Assignee: Team Lead
Story Points: 5
Time Estimate: 8h
Tags: jenkins, ci-cd, automation

Description:
Setup Jenkins CI/CD pipeline cho:
- Game server builds (Windows Server)
- Client builds (Android, iOS staging)
- Automated testing
- Deployment to Edgegap

Acceptance Criteria:
[ ] Jenkinsfile created
[ ] Server build pipeline working
[ ] Client build pipeline working
[ ] Auto-deploy to Edgegap configured
[ ] Build notifications setup

Dependencies: TL-002

Output: Working Jenkins Pipeline
```

---

### STORY: BE-001 - Nakama Development Environment
```
Type: Story
Priority: Critical
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: nakama, backend, setup

Description:
Research và setup Nakama development environment:
- Install Nakama server locally
- Setup development tools
- Understand Nakama architecture
- Test basic functionality
- Document setup process

Acceptance Criteria:
[ ] Nakama server running locally
[ ] Development tools installed
[ ] Basic tests passed
[ ] Setup documentation created
[ ] Team trained on basics

Dependencies: None

Output: Local Nakama Instance + Setup Guide
```

---

### STORY: BE-002 - Nakama Project Creation
```
Type: Story
Priority: High
Assignee: Backend Engineer
Story Points: 3
Time Estimate: 4h
Tags: nakama, backend, configuration

Description:
Tạo Nakama project và configure basic settings:
- Create new Nakama project
- Configure server settings
- Setup authentication methods
- Create basic collections
- Test connectivity

Acceptance Criteria:
[ ] Nakama project created
[ ] Basic settings configured
[ ] Authentication working
[ ] Collections created
[ ] Connection tested from Unreal

Dependencies: BE-001

Output: Configured Nakama Project
```

---

### STORY: BE-003 - PostgreSQL Database Setup
```
Type: Story
Priority: High
Assignee: Backend Engineer
Story Points: 3
Time Estimate: 4h
Tags: database, postgresql, backend

Description:
Setup PostgreSQL database cho Nakama:
- Install PostgreSQL
- Create database và users
- Configure Nakama connection
- Setup backup strategy
- Test database operations

Acceptance Criteria:
[ ] PostgreSQL installed
[ ] Database created
[ ] Nakama connected
[ ] Backup configured
[ ] CRUD operations tested

Dependencies: BE-002

Output: PostgreSQL Database Instance
```

---

### STORY: BE-004 - Edgegap Account & Research
```
Type: Story
Priority: Medium
Assignee: Backend Engineer
Story Points: 3
Time Estimate: 4h
Tags: edgegap, research, infrastructure

Description:
Research Edgegap API và tạo account:
- Sign up for Edgegap
- Understand API capabilities
- Test API endpoints
- Document API usage
- Plan integration approach

Acceptance Criteria:
[ ] Edgegap account created
[ ] API key obtained
[ ] Test API calls successful
[ ] Integration plan documented
[ ] Cost estimates prepared

Dependencies: None

Output: Edgegap Account + API Documentation
```

---

### STORY: BE-005 - Database Schema Design
```
Type: Story
Priority: High
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: database, schema, design

Description:
Thiết kế database schema chi tiết cho match data:
- Match metadata table
- Player session table
- Queue state table
- Game server instances table
- Match results table

Acceptance Criteria:
[ ] ERD diagram created
[ ] Tables defined
[ ] Indexes planned
[ ] Foreign keys defined
[ ] Migration scripts ready

Dependencies: TL-003, BE-003

Output: Database Schema + Migration Scripts
```

---

### STORY: CD-001 - Perforce Branch Setup
```
Type: Story
Priority: High
Assignee: Core Developer
Story Points: 3
Time Estimate: 4h
Tags: perforce, setup, branching

Description:
Setup Unreal project branch cho multiplayer trong Perforce:
- Create //Multiplayer branch
- Sync latest from main
- Setup local workspace
- Test submit/sync cycle
- Document workflow

Acceptance Criteria:
[ ] Branch created
[ ] Workspace configured
[ ] Initial sync completed
[ ] Test submit successful
[ ] Workflow documented

Dependencies: TL-002

Output: Working Perforce Branch
```

---

### STORY: CD-002 - Multiplayer Base Classes
```
Type: Story
Priority: Critical
Assignee: Core Developer
Story Points: 8
Time Estimate: 8h
Tags: unreal, multiplayer, foundation

Description:
Tạo base classes cho multiplayer:
- ARacingGameMode_Multiplayer
- ARacingGameState_Multiplayer
- ARacingPlayerState_Multiplayer
- ARacingPlayerController_Multiplayer
- Setup replication flags

Acceptance Criteria:
[ ] All base classes created
[ ] Replication configured
[ ] Basic properties replicated
[ ] Code compiled
[ ] Unit tests passed

Dependencies: TL-003

Output: Multiplayer Base Classes
```

---

### STORY: CD-003 - Network Configuration
```
Type: Story
Priority: High
Assignee: Core Developer
Story Points: 3
Time Estimate: 4h
Tags: unreal, networking, configuration

Description:
Implement basic networking configuration:
- Configure DefaultEngine.ini
- Setup network settings
- Configure replication graph
- Test network connectivity
- Document settings

Acceptance Criteria:
[ ] Network settings configured
[ ] Replication graph setup
[ ] Listen server working
[ ] Dedicated server config ready
[ ] Settings documented

Dependencies: CD-002

Output: Network Configuration + Documentation
```

---

### STORY: CD-004 - Multiplayer Test Map
```
Type: Story
Priority: Medium
Assignee: Core Developer
Story Points: 5
Time Estimate: 8h
Tags: unreal, level-design, testing

Description:
Create multiplayer test map:
- Simple race track
- 4 spawn points
- Checkpoints
- Finish line
- Debug visualizations

Acceptance Criteria:
[ ] Test map created
[ ] Spawn points configured
[ ] Checkpoints working
[ ] Finish line functional
[ ] Map packaged successfully

Dependencies: CD-002

Output: TestMap_Multiplayer.umap
```

---

### STORY: UI-001 - UI Base Widgets từ Design
```
Type: Story
Priority: High
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
Tags: ui, umg, widgets, implementation

Description:
Implement base widget classes từ design specs có sẵn:
- WBP_MultiplayerBase
- WBP_ButtonBase
- WBP_ScreenTransition
- Setup style assets (đã có từ design team)
- Test widget hierarchy

NOTE: Design files đã có sẵn từ design team, chỉ cần implement

Acceptance Criteria:
[ ] Base widgets implemented theo design
[ ] Style assets imported
[ ] Widget hierarchy setup
[ ] Compile success
[ ] Preview working

Dependencies: None (Design files ready)

Output: Base UMG Widgets
```

---

### STORY: UI-002 - Mode Selection Screen Implementation
```
Type: Story
Priority: High
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
Tags: ui, umg, screens

Description:
Implement mode selection screen theo design có sẵn:
- WBP_ModeSelection
- Single player button
- Multiplayer button (functional)
- Private room button (disabled)
- Navigation logic

Acceptance Criteria:
[ ] Screen implemented theo design spec
[ ] Buttons functional
[ ] Private room button grayed out
[ ] Navigation working
[ ] Animations imported

Dependencies: UI-001

Output: WBP_ModeSelection Widget
```

---

### STORY: INT-001 - Blueprint Communication Architecture
```
Type: Story
Priority: Critical
Assignee: UI Integration
Story Points: 5
Time Estimate: 8h
Tags: blueprint, architecture, integration

Description:
Setup blueprint communication architecture:
- Event dispatcher system
- Interface definitions
- State management blueprint
- Data binding framework
- Testing framework

Acceptance Criteria:
[ ] Communication system working
[ ] Interfaces defined
[ ] State manager created
[ ] Data binding working
[ ] Test cases passed

Dependencies: TL-001, CD-002

Output: BP Communication Framework
```

---

### STORY: INT-002 - Mock Data Service
```
Type: Story
Priority: High
Assignee: UI Integration
Story Points: 3
Time Estimate: 4h
Tags: testing, mock, data

Description:
Tạo mock data service cho UI testing:
- Mock matchmaking responses
- Mock player data
- Mock game server data
- Fake timer service
- Switch để enable/disable mock

Acceptance Criteria:
[ ] Mock service created
[ ] All data types mocked
[ ] Switch working
[ ] UI testable without backend
[ ] Documentation complete

Dependencies: TL-003

Output: Mock Data Service Blueprint
```

---

### STORY: INT-003 - State Management System
```
Type: Story
Priority: High
Assignee: UI Integration
Story Points: 5
Time Estimate: 8h
Tags: state-management, architecture

Description:
Implement basic state management system:
- Matchmaking states
- Game session states
- Player states
- Transitions
- Event broadcasting

Acceptance Criteria:
[ ] State machine implemented
[ ] All states defined
[ ] Transitions working
[ ] Events firing correctly
[ ] Debug logging added

Dependencies: INT-001

Output: State Management System
```

---

## EPIC 2: MATCHMAKING SYSTEM (Days 4-9)

### Epic Details
- **Epic ID**: MP-EPIC-002
- **Summary**: Matchmaking và Queue System
- **Priority**: Critical
- **Timeline**: Days 4-9
- **Team**: Backend (critical), Core Dev, UI, Integration

---

### STORY: TL-005 - Matchmaking Flow Design
```
Type: Story
Priority: Critical
Assignee: Team Lead
Story Points: 5
Time Estimate: 8h
Tags: architecture, design, matchmaking

Description:
Define matchmaking flow và state machine chi tiết:
- Queue entry states
- Match formation states
- Server provisioning states
- Error states
- Diagram tất cả transitions

Acceptance Criteria:
[ ] Flow diagram hoàn chỉnh
[ ] State machine documented
[ ] Error handling defined
[ ] Timeouts specified
[ ] Team reviewed và approved

Dependencies: BE-005

Output: Matchmaking Flow Diagram + State Machine Spec
```

---

### STORY: TL-006 - Backend Code Review
```
Type: Task
Priority: High
Assignee: Team Lead
Story Points: 3
Time Estimate: 4h
Tags: code-review, backend

Description:
Code review cho backend matchmaking logic:
- Review Nakama custom modules
- Check error handling
- Verify security
- Review database queries
- Performance check

Acceptance Criteria:
[ ] All code reviewed
[ ] Issues logged in YouTrack
[ ] Critical issues resolved
[ ] Best practices followed
[ ] Documentation updated

Dependencies: BE-008

Output: Code Review Report
```

---

### STORY: TL-007 - Multi-Client Testing
```
Type: Task
Priority: Critical
Assignee: Team Lead
Story Points: 8
Time Estimate: 8h
Tags: testing, integration, multiplayer

Description:
Test matchmaking với multiple clients:
- Setup 4 test clients
- Test queue flow
- Test match formation
- Test server connection
- Document bugs

Acceptance Criteria:
[ ] 4 clients tested simultaneously
[ ] Queue working
[ ] Match formation working
[ ] Server connection stable
[ ] Bugs logged

Dependencies: BE-010

Output: Test Report + Bug List
```

---

### STORY: BE-006 - Nakama Authentication
```
Type: Story
Priority: Critical
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: nakama, authentication, backend

Description:
Implement Nakama authentication flow:
- Device ID authentication
- Session management
- Token refresh
- Error handling
- Security measures

Acceptance Criteria:
[ ] Authentication working
[ ] Sessions managed correctly
[ ] Token refresh automatic
[ ] Errors handled gracefully
[ ] Security tested

Dependencies: BE-003

Output: Authentication Module
```

---

### STORY: BE-007 - Matchmaking Queue System
```
Type: Story
Priority: Critical
Assignee: Backend Engineer
Story Points: 13
Time Estimate: 16h (2 days)
Tags: nakama, matchmaking, critical-path

Description:
Develop matchmaking queue system (4 players):
- Queue entry logic
- Player matching algorithm
- Queue timeout handling
- Match formation
- Queue state management
- Real-time updates

NOTE: Critical path task - prioritize!

Acceptance Criteria:
[ ] Queue entry working
[ ] 4-player matching working
[ ] Timeouts handled
[ ] Match created automatically
[ ] State updates real-time
[ ] Load tested (100 players)

Dependencies: BE-006, TL-005

Output: Matchmaking Queue Module
```

---

### STORY: BE-008 - Match Creation Logic
```
Type: Story
Priority: Critical
Assignee: Backend Engineer
Story Points: 8
Time Estimate: 8h
Tags: nakama, matches, backend

Description:
Implement match creation logic:
- Create match on Nakama
- Assign match ID
- Store player list
- Lock players from re-queuing
- Trigger server provisioning

Acceptance Criteria:
[ ] Match created in database
[ ] Match ID generated
[ ] Players assigned
[ ] Queue locks working
[ ] Server provisioning triggered

Dependencies: BE-007

Output: Match Creation Module
```

---

### STORY: BE-009 - Edgegap Integration
```
Type: Story
Priority: Critical
Assignee: Backend Engineer
Story Points: 13
Time Estimate: 12h (1.5 days)
Tags: edgegap, integration, infrastructure, critical-path

Description:
Setup Edgegap API integration cho server provisioning:
- API authentication
- Server deployment request
- Server status polling
- Get server IP/port
- Error handling và retries
- Timeout management

NOTE: Critical path task - coordinate với Jenkins (TL-004)

Acceptance Criteria:
[ ] API calls working
[ ] Server deploys successfully
[ ] IP/port received
[ ] Status polling reliable
[ ] Errors handled properly
[ ] Integration tested

Dependencies: BE-004, BE-008, TL-004

Output: Edgegap Integration Module
```

---

### STORY: BE-010 - Match Lifecycle Management
```
Type: Story
Priority: Critical
Assignee: Backend Engineer
Story Points: 13
Time Estimate: 12h (1.5 days)
Tags: nakama, lifecycle, backend

Description:
Handle match lifecycle management:
- Match start notification
- In-progress state management
- Match end handling
- Unlock players
- Cleanup resources
- Results storage preparation

Acceptance Criteria:
[ ] Start notification working
[ ] State tracking accurate
[ ] End handling working
[ ] Players unlocked
[ ] Cleanup successful
[ ] Results ready for storage

Dependencies: BE-009

Output: Match Lifecycle Manager
```

---

### STORY: CD-005 - Nakama SDK Integration
```
Type: Story
Priority: Critical
Assignee: Core Developer
Story Points: 8
Time Estimate: 8h
Tags: unreal, nakama, integration

Description:
Integrate Nakama C++ SDK vào Unreal:
- Add SDK to project
- Configure build settings
- Test compilation
- Create wrapper classes
- Basic connectivity test

Acceptance Criteria:
[ ] SDK integrated
[ ] Project compiles
[ ] Wrapper classes created
[ ] Connection test passed
[ ] Documentation updated

Dependencies: BE-006

Output: Nakama SDK Integration
```

---

### STORY: CD-006 - Client Authentication Flow
```
Type: Story
Priority: High
Assignee: Core Developer
Story Points: 8
Time Estimate: 8h
Tags: unreal, authentication, client

Description:
Implement client authentication flow:
- Device ID generation
- Authentication request
- Session storage
- Token management
- Reconnection logic

Acceptance Criteria:
[ ] Device ID generated
[ ] Authentication working
[ ] Session persisted
[ ] Tokens managed
[ ] Reconnection working

Dependencies: CD-005, BE-006

Output: Authentication Client Module
```

---

### STORY: CD-007 - Matchmaking Client Logic
```
Type: Story
Priority: Critical
Assignee: Core Developer
Story Points: 13
Time Estimate: 12h (1.5 days)
Tags: unreal, matchmaking, client, critical-path

Description:
Develop matchmaking client logic:
- Queue entry request
- Queue status polling
- Match found notification
- Cancel queue logic
- Error handling

NOTE: Parallel với BE-007, coordinate closely

Acceptance Criteria:
[ ] Queue entry working
[ ] Status updates real-time
[ ] Match notification received
[ ] Cancel working
[ ] Errors handled

Dependencies: CD-006, BE-007

Output: Matchmaking Client Module
```

---

### STORY: CD-008 - Server Connection Handler
```
Type: Story
Priority: Critical
Assignee: Core Developer
Story Points: 13
Time Estimate: 12h (1.5 days)
Tags: unreal, networking, connection

Description:
Handle server connection và session join:
- Parse server IP/port
- Connect to dedicated server
- Join session
- Handle connection failures
- Reconnection attempts

Acceptance Criteria:
[ ] Connection parsing working
[ ] Server connection successful
[ ] Session join working
[ ] Failures handled
[ ] Reconnection attempted

Dependencies: CD-007, BE-010

Output: Connection Handler Module
```

---

### STORY: UI-003 - Queue Screen Implementation
```
Type: Story
Priority: High
Assignee: UI Developer
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: ui, umg, screens

Description:
Implement queue screen theo design:
- WBP_QueueScreen
- Searching animation (từ design)
- Player count display
- Cancel button
- Estimated time display

NOTE: Import animations từ design team

Acceptance Criteria:
[ ] Screen implemented theo design
[ ] Animations imported và working
[ ] Cancel button functional
[ ] Display updates implemented
[ ] Transitions smooth

Dependencies: UI-002

Output: WBP_QueueScreen Widget
```

---

### STORY: UI-004 - Match Found Notification
```
Type: Story
Priority: High
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
Tags: ui, umg, notifications

Description:
Design và implement match found notification:
- WBP_MatchFoundPopup
- Match found animation
- Accept countdown
- Player avatars (placeholders)
- Transition to loading

Acceptance Criteria:
[ ] Popup implemented
[ ] Animation working
[ ] Countdown functional
[ ] Avatars displayed
[ ] Transition smooth

Dependencies: UI-003

Output: WBP_MatchFoundPopup Widget
```

---

### STORY: UI-005 - Loading Screen
```
Type: Story
Priority: Medium
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
Tags: ui, umg, loading

Description:
Create countdown và loading screen:
- WBP_LoadingScreen
- Server status display
- Progress indicators
- Tips/hints display
- Cancel/disconnect option

Acceptance Criteria:
[ ] Loading screen implemented
[ ] Status updates working
[ ] Progress bars functional
[ ] Tips displayed
[ ] Cancel option working

Dependencies: UI-004

Output: WBP_LoadingScreen Widget
```

---

### STORY: INT-004 - Queue Screen Integration
```
Type: Story
Priority: Critical
Assignee: UI Integration
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: integration, ui-backend

Description:
Connect queue screen to matchmaking service:
- Bind queue entry button
- Update player count real-time
- Handle status updates
- Implement cancel logic
- Error message display

Acceptance Criteria:
[ ] Queue entry working
[ ] Player count updates
[ ] Status messages displayed
[ ] Cancel functional
[ ] Errors shown properly

Dependencies: UI-003, CD-007

Output: Integrated Queue Flow
```

---

### STORY: INT-005 - Match Found Logic
```
Type: Story
Priority: High
Assignee: UI Integration
Story Points: 5
Time Estimate: 8h
Tags: integration, ui-backend

Description:
Implement match found logic và transition:
- Listen for match notification
- Show match found popup
- Start countdown
- Transition to loading
- Handle auto-accept

Acceptance Criteria:
[ ] Notification received
[ ] Popup shows correctly
[ ] Countdown accurate
[ ] Transition smooth
[ ] Auto-accept working

Dependencies: UI-004, BE-008

Output: Match Found Integration
```

---

### STORY: INT-006 - Loading Screen Data Binding
```
Type: Story
Priority: Medium
Assignee: UI Integration
Story Points: 5
Time Estimate: 8h
Tags: integration, data-binding

Description:
Handle loading screen data binding:
- Server status updates
- Progress tracking
- Map info display
- Player list updates
- Connection status

Acceptance Criteria:
[ ] Server status displayed
[ ] Progress updates real-time
[ ] Map info shown
[ ] Players listed
[ ] Status accurate

Dependencies: UI-005, CD-008

Output: Loading Screen Integration
```

---

### STORY: INT-007 - Error Handling System
```
Type: Story
Priority: High
Assignee: UI Integration
Story Points: 5
Time Estimate: 8h
Tags: integration, error-handling

Description:
Implement error handling và retry logic:
- Network error handling
- Queue timeout handling
- Server unavailable handling
- Retry mechanisms
- User-friendly messages

Acceptance Criteria:
[ ] All errors caught
[ ] Retry logic working
[ ] Messages user-friendly
[ ] State recovered
[ ] Logging implemented

Dependencies: INT-006

Output: Error Handling System
```

---

## EPIC 3: IN-GAME MULTIPLAYER (Days 10-14)

### Epic Details
- **Epic ID**: MP-EPIC-003
- **Summary**: In-Game Multiplayer Racing Implementation
- **Priority**: Critical
- **Timeline**: Days 10-14
- **Team**: Core Dev (critical), Backend, UI, Integration

---

### STORY: CD-009 - Game Server Build Configuration
```
Type: Story
Priority: Critical
Assignee: Core Developer
Story Points: 8
Time Estimate: 8h
Tags: unreal, server, build

Description:
Setup game server build configuration:
- Configure dedicated server target
- Package settings optimization
- Network settings
- Test server locally
- Jenkins integration prep

Acceptance Criteria:
[ ] Server target configured
[ ] Build packaging successfully
[ ] Local server runs
[ ] Network settings correct
[ ] Ready for Jenkins

Dependencies: CD-004, TL-004

Output: Packaged Server Build
```

---

### STORY: CD-010 - Vehicle Replication System
```
Type: Story
Priority: Critical
Assignee: Core Developer
Story Points: 13
Time Estimate: 16h (2 days)
Tags: unreal, replication, physics, critical-path

Description:
Implement vehicle replication (simulated clients):
- Setup replication conditions
- Replicate transform
- Replicate velocity
- Replicate input state
- Smooth interpolation
- LOD based updates

NOTE: Critical path - most complex task

Acceptance Criteria:
[ ] Simulated clients replicate
[ ] Transform sync smooth
[ ] Velocity accurate
[ ] Input replicated
[ ] Interpolation working
[ ] Performance acceptable (60 FPS)

Dependencies: CD-008, CD-009

Output: Vehicle Replication Module
```

---

### STORY: CD-011 - Client-Side Prediction
```
Type: Story
Priority: Critical
Assignee: Core Developer
Story Points: 13
Time Estimate: 12h (1.5 days)
Tags: unreal, prediction, networking

Description:
Configure client-side prediction cho owning client:
- Client-authoritative movement
- Input buffering
- Prediction corrections
- Smoothing algorithms
- Debug visualization

Acceptance Criteria:
[ ] Client prediction working
[ ] Input responsive
[ ] Corrections smooth
[ ] No jittering
[ ] Debug tools working

Dependencies: CD-010

Output: Client Prediction System
```

---

### STORY: CD-012 - Collision Configuration
```
Type: Task
Priority: High
Assignee: Core Developer
Story Points: 3
Time Estimate: 4h
Tags: unreal, physics, collision

Description:
Disable collision cho simulated vehicles:
- Configure collision profiles
- Keep VFX collision (sparks)
- Test collision interactions
- Verify physics stability
- Document settings

Acceptance Criteria:
[ ] No vehicle-to-vehicle collision
[ ] VFX effects still working
[ ] Physics stable
[ ] Settings documented
[ ] No performance impact

Dependencies: CD-010

Output: Collision Configuration
```

---

### STORY: CD-013 - Debug Visualization Tools
```
Type: Story
Priority: Medium
Assignee: Core Developer
Story Points: 8
Time Estimate: 8h
Tags: unreal, debug, tools

Description:
Implement debug visualization (boxes):
- Draw debug boxes cho vehicles
- Show network ownership
- Display replication status
- Latency indicators
- Console commands

Acceptance Criteria:
[ ] Debug boxes rendering
[ ] Ownership shown
[ ] Status displayed
[ ] Latency visible
[ ] Commands working

Dependencies: CD-011

Output: Debug Visualization System
```

---

### STORY: CD-014 - VN_Tour Multiplayer Integration
```
Type: Story
Priority: High
Assignee: Core Developer
Story Points: 8
Time Estimate: 8h
Tags: integration, vn-tour, systems

Description:
Update VN_Tour system để support multiplayer:
- Add multiplayer track variants
- Integrate with matchmaking
- Update progression tracking
- Leaderboard integration prep
- Test integration

NOTE: New task - integration với existing system

Acceptance Criteria:
[ ] VN_Tour tracks support multiplayer
[ ] Matchmaking integrated
[ ] Progression tracking working
[ ] No single-player regression
[ ] Integration tested

Dependencies: CD-008, Existing VN_Tour system

Output: VN_Tour Multiplayer Integration
```

---

### STORY: BE-011 - Match End Notification
```
Type: Story
Priority: Critical
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: nakama, backend, match-lifecycle

Description:
Implement match end notification system:
- Listen for game server notifications
- Validate match completion
- Update match status
- Notify all clients
- Prepare results data

Acceptance Criteria:
[ ] Server notifications received
[ ] Match status updated
[ ] Clients notified
[ ] Results prepared
[ ] Database updated

Dependencies: BE-010

Output: Match End API
```

---

### STORY: BE-012 - Game Server Health Monitoring
```
Type: Story
Priority: High
Assignee: Backend Engineer
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: backend, monitoring, infrastructure

Description:
Create game server health monitoring:
- Heartbeat system
- Server crash detection
- Auto-restart logic
- Status dashboard
- Alert system

Acceptance Criteria:
[ ] Heartbeat working
[ ] Crashes detected
[ ] Auto-restart functional
[ ] Dashboard accessible
[ ] Alerts firing

Dependencies: BE-009

Output: Health Monitoring System
```

---

### STORY: BE-013 - Player Disconnect Handling
```
Type: Story
Priority: High
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: backend, networking, error-handling

Description:
Implement player disconnect handling:
- Detect disconnections
- Grace period for reconnection
- Match state preservation
- Cleanup after timeout
- Notify remaining players

Acceptance Criteria:
[ ] Disconnects detected
[ ] Grace period working
[ ] State preserved
[ ] Cleanup successful
[ ] Notifications sent

Dependencies: BE-012

Output: Disconnect Handler
```

---

### STORY: BE-014 - Logging và Debug Tools
```
Type: Task
Priority: Medium
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: backend, logging, debugging

Description:
Setup logging và debugging tools:
- Structured logging
- Log aggregation
- Search và filtering
- Performance metrics
- Debug endpoints

Acceptance Criteria:
[ ] Logging implemented
[ ] Logs aggregated
[ ] Search working
[ ] Metrics tracked
[ ] Debug endpoints available

Dependencies: BE-013

Output: Logging System + Debug Tools
```

---

### STORY: UI-006 - In-Game Multiplayer HUD
```
Type: Story
Priority: High
Assignee: UI Developer
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: ui, umg, hud

Description:
Design và implement in-game multiplayer HUD:
- WBP_MultiplayerHUD
- Player list overlay
- Position indicators
- Lap counters
- Network status indicator

Acceptance Criteria:
[ ] HUD implemented theo design
[ ] All elements visible
[ ] Layout responsive
[ ] Performance optimized
[ ] No screen clutter

Dependencies: UI-005

Output: WBP_MultiplayerHUD Widget
```

---

### STORY: UI-007 - Player List Widget
```
Type: Story
Priority: Medium
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
Tags: ui, umg, widgets

Description:
Implement player list widget:
- WBP_PlayerListItem
- Player name
- Position number
- Avatar (placeholder)
- Status indicators (disconnected, etc.)

Acceptance Criteria:
[ ] List items created
[ ] Names displayed
[ ] Positions shown
[ ] Avatars working
[ ] Status indicated

Dependencies: UI-006

Output: WBP_PlayerListItem Widget
```

---

### STORY: UI-008 - Race Position Indicators
```
Type: Story
Priority: Medium
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
Tags: ui, umg, widgets

Description:
Create race position indicators:
- Current position display
- Position change animations
- Leader indicator
- Personal best indicator
- Visual feedback

Acceptance Criteria:
[ ] Position displayed clearly
[ ] Changes animated
[ ] Leader highlighted
[ ] Best time shown
[ ] Feedback working

Dependencies: UI-007

Output: Position Indicator Widgets
```

---

### STORY: UI-009 - End Race Results Screen
```
Type: Story
Priority: High
Assignee: UI Developer
Story Points: 8
Time Estimate: 8h
Tags: ui, umg, screens

Description:
Design và implement end-race results screen:
- WBP_RaceResults
- Final standings
- Time comparisons
- Rewards display (prep for future)
- Return to menu button

Acceptance Criteria:
[ ] Results screen implemented
[ ] Standings displayed
[ ] Times shown
[ ] Rewards placeholder ready
[ ] Navigation working

Dependencies: UI-008

Output: WBP_RaceResults Widget
```

---

### STORY: INT-008 - Player List Data Binding
```
Type: Story
Priority: High
Assignee: UI Integration
Story Points: 5
Time Estimate: 8h
Tags: integration, data-binding, ui

Description:
Bind player list to game state:
- Listen to GameState updates
- Update player list real-time
- Handle player join/leave
- Sort by position
- Update statuses

Acceptance Criteria:
[ ] Player list updates real-time
[ ] Join/leave handled
[ ] Sorting correct
[ ] Statuses accurate
[ ] Performance good

Dependencies: UI-007, CD-010

Output: Player List Integration
```

---

### STORY: INT-009 - Position Indicators Real-time Sync
```
Type: Story
Priority: Medium
Assignee: UI Integration
Story Points: 5
Time Estimate: 8h
Tags: integration, real-time, ui

Description:
Update position indicators real-time:
- Listen to position changes
- Trigger change animations
- Update leader status
- Show position gains/losses
- Performance optimization

Acceptance Criteria:
[ ] Updates real-time
[ ] Animations triggered
[ ] Leader updated
[ ] Gains/losses shown
[ ] No frame drops

Dependencies: UI-008, CD-010

Output: Position Sync System
```

---

### STORY: INT-010 - Results Screen Integration
```
Type: Story
Priority: High
Assignee: UI Integration
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: integration, results, ui-backend

Description:
Implement results screen data integration:
- Fetch final results from server
- Display race statistics
- Calculate rewards (prep)
- Show personal progress
- Return to menu logic

Acceptance Criteria:
[ ] Results fetched
[ ] Stats displayed
[ ] Rewards calculated
[ ] Progress shown
[ ] Navigation working

Dependencies: UI-009, BE-011

Output: Results Screen Integration
```

---

### STORY: INT-011 - Existing Systems Integration
```
Type: Story
Priority: High
Assignee: UI Integration
Story Points: 8
Time Estimate: 8h
Tags: integration, systems, vn-tour

Description:
Integrate multiplayer với existing systems:
- Shop system (currency rewards)
- Progression system (XP, levels)
- VN_Tour (track selection)
- Achievement system prep
- Data persistence

NOTE: New task - critical cho production readiness

Acceptance Criteria:
[ ] Shop integration working
[ ] Progression tracking correct
[ ] VN_Tour integrated
[ ] Achievements prepared
[ ] Data persists correctly

Dependencies: INT-010, CD-014

Output: Systems Integration Module
```

---

### STORY: TL-008 - Network Code Review
```
Type: Task
Priority: Critical
Assignee: Team Lead
Story Points: 5
Time Estimate: 8h
Tags: code-review, networking

Description:
Review network replication architecture:
- Review replication code
- Check bandwidth usage
- Verify security
- Performance analysis
- Best practices compliance

Acceptance Criteria:
[ ] Code reviewed
[ ] Bandwidth acceptable
[ ] Security verified
[ ] Performance good
[ ] Issues logged

Dependencies: CD-011

Output: Network Code Review Report
```

---

### STORY: TL-009 - 4-Client Integration Test
```
Type: Task
Priority: Critical
Assignee: Team Lead
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: testing, integration, multiplayer

Description:
Test multiplayer với 4 clients end-to-end:
- Setup 4 test stations
- Full flow testing
- Performance monitoring
- Bug identification
- Edge cases testing

Acceptance Criteria:
[ ] 4 clients tested simultaneously
[ ] Full flow working
[ ] Performance measured
[ ] Bugs documented
[ ] Edge cases tested

Dependencies: CD-013, INT-010

Output: Integration Test Report
```

---

### STORY: TL-010 - Network Bandwidth Optimization
```
Type: Task
Priority: High
Assignee: Team Lead
Story Points: 5
Time Estimate: 8h
Tags: optimization, networking, performance

Description:
Optimize network bandwidth usage:
- Profile replication traffic
- Identify bottlenecks
- Implement optimizations
- Re-test performance
- Document improvements

Acceptance Criteria:
[ ] Profiling complete
[ ] Bottlenecks identified
[ ] Optimizations implemented
[ ] Performance improved
[ ] Documentation updated

Dependencies: CD-013, TL-009

Output: Optimization Report
```

---

## EPIC 4: INTEGRATION & POLISH (Days 15-18)

### Epic Details
- **Epic ID**: MP-EPIC-004
- **Summary**: Final Integration, Testing & Deployment
- **Priority**: Critical
- **Timeline**: Days 15-18
- **Team**: All hands on deck

---

### STORY: TL-011 - Comprehensive Integration Testing
```
Type: Task
Priority: Critical
Assignee: Team Lead
Story Points: 13
Time Estimate: 16h (2 days)
Tags: testing, integration, qa, critical-path

Description:
Comprehensive end-to-end integration testing:
- Full user journey testing
- Cross-device testing
- Network condition simulation
- Edge case testing
- Regression testing

NOTE: All team members participate in testing

Acceptance Criteria:
[ ] All user flows tested
[ ] Multiple devices tested
[ ] Network conditions tested
[ ] Edge cases handled
[ ] Regression tests passed
[ ] Bug list prioritized

Dependencies: Tất cả modules complete

Output: Master Test Report + Prioritized Bug List
```

---

### STORY: TL-012 - Performance Profiling & Optimization
```
Type: Task
Priority: High
Assignee: Team Lead
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: performance, optimization, profiling

Description:
Performance profiling và optimization:
- CPU profiling
- Memory profiling
- Network profiling
- Frame rate analysis
- Implement optimizations
- Re-test

Acceptance Criteria:
[ ] All profiles completed
[ ] Bottlenecks identified
[ ] Optimizations implemented
[ ] Target FPS achieved (60+)
[ ] Memory within limits
[ ] Network efficient

Dependencies: TL-011

Output: Performance Report + Optimization Patch
```

---

### STORY: TL-013 - Deployment Documentation
```
Type: Task
Priority: High
Assignee: Team Lead
Story Points: 5
Time Estimate: 8h
Tags: documentation, deployment

Description:
Create comprehensive deployment documentation:
- Server deployment guide
- Client build guide
- Nakama configuration
- Edgegap setup
- Troubleshooting guide

Acceptance Criteria:
[ ] All guides complete
[ ] Step-by-step instructions
[ ] Screenshots included
[ ] Troubleshooting covered
[ ] Team reviewed

Dependencies: TL-012

Output: Deployment Documentation (Confluence)
```

---

### STORY: TL-014 - Final Code Review & Refactoring
```
Type: Task
Priority: Medium
Assignee: Team Lead
Story Points: 5
Time Estimate: 8h
Tags: code-review, refactoring, quality

Description:
Final code review và refactoring:
- Review all multiplayer code
- Refactor duplicate code
- Improve naming
- Add missing comments
- Code cleanup

Acceptance Criteria:
[ ] All code reviewed
[ ] Refactoring complete
[ ] Comments added
[ ] Code clean
[ ] Standards compliant

Dependencies: TL-013

Output: Clean Codebase + Review Report
```

---

### STORY: BE-015 - Nakama Staging Deployment
```
Type: Task
Priority: Critical
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: deployment, nakama, staging

Description:
Deploy Nakama to staging environment:
- Setup staging server
- Configure production settings
- Migrate database
- Test connectivity
- Performance test

Acceptance Criteria:
[ ] Staging server running
[ ] Settings configured
[ ] Database migrated
[ ] Connectivity tested
[ ] Performance acceptable

Dependencies: BE-014

Output: Staging Nakama Server
```

---

### STORY: BE-016 - Game Server Upload to Edgegap
```
Type: Task
Priority: Critical
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: deployment, edgegap, server

Description:
Upload game server build to Edgegap:
- Package final server build
- Upload to Edgegap registry
- Configure deployment settings
- Test deployment
- Monitor first instances

Acceptance Criteria:
[ ] Server build packaged
[ ] Upload successful
[ ] Settings configured
[ ] Test deployment working
[ ] Monitoring setup

Dependencies: CD-009, BE-015

Output: Deployed Game Server on Edgegap
```

---

### STORY: BE-017 - Production Configuration
```
Type: Task
Priority: High
Assignee: Backend Engineer
Story Points: 5
Time Estimate: 8h
Tags: configuration, production, deployment

Description:
Configure production settings:
- Production environment variables
- Database connection strings
- API keys và secrets
- Rate limiting
- Monitoring alerts

Acceptance Criteria:
[ ] Environment configured
[ ] Secrets secured
[ ] Rate limits set
[ ] Monitoring enabled
[ ] Alerts configured

Dependencies: BE-015, BE-016

Output: Production Configuration
```

---

### STORY: BE-018 - Monitoring Dashboard
```
Type: Task
Priority: Medium
Assignee: Backend Engineer
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: monitoring, dashboard, operations

Description:
Create monitoring dashboard:
- Server health metrics
- Match statistics
- Player counts
- Error rates
- Performance metrics

Acceptance Criteria:
[ ] Dashboard created
[ ] All metrics displayed
[ ] Real-time updates
[ ] Historical data
[ ] Alerts integrated

Dependencies: BE-017

Output: Operations Dashboard
```

---

### STORY: CD-015 - Bug Fixes from Testing
```
Type: Task
Priority: Critical
Assignee: Core Developer
Story Points: 13
Time Estimate: 16h (2 days)
Tags: bugfix, testing, quality

Description:
Fix bugs identified trong integration testing:
- Critical bugs (blockers)
- High priority bugs
- Medium priority bugs
- Testing fixes
- Regression testing

NOTE: Bug list từ TL-011

Acceptance Criteria:
[ ] All critical bugs fixed
[ ] High priority bugs fixed
[ ] Medium bugs addressed
[ ] Fixes tested
[ ] No regressions

Dependencies: TL-011

Output: Bug Fix Patch
```

---

### STORY: CD-016 - Network Code Optimization
```
Type: Task
Priority: High
Assignee: Core Developer
Story Points: 8
Time Estimate: 8h
Tags: optimization, networking, performance

Description:
Optimize network code based on profiling:
- Reduce replication frequency
- Optimize data serialization
- Implement relevancy checks
- Bandwidth optimization
- Test improvements

Acceptance Criteria:
[ ] Frequency optimized
[ ] Serialization improved
[ ] Relevancy working
[ ] Bandwidth reduced
[ ] Performance better

Dependencies: TL-012

Output: Optimized Network Code
```

---

### STORY: CD-017 - Telemetry & Analytics
```
Type: Task
Priority: Medium
Assignee: Core Developer
Story Points: 5
Time Estimate: 8h
Tags: telemetry, analytics, tracking

Description:
Add telemetry và analytics events:
- Match start/end events
- Player actions tracking
- Performance metrics
- Error tracking
- Custom events

Acceptance Criteria:
[ ] Events defined
[ ] Tracking implemented
[ ] Metrics flowing
[ ] Errors tracked
[ ] Dashboard receiving data

Dependencies: CD-016

Output: Telemetry System
```

---

### STORY: UI-010 - UI Bug Fixes
```
Type: Task
Priority: High
Assignee: UI Developer
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: bugfix, ui, quality

Description:
Fix UI bugs và visual issues:
- Layout issues
- Animation glitches
- Text overflow
- Button states
- Transition bugs

NOTE: Bug list từ TL-011

Acceptance Criteria:
[ ] All layout issues fixed
[ ] Animations smooth
[ ] Text displays correctly
[ ] Buttons working
[ ] Transitions smooth

Dependencies: TL-011

Output: UI Bug Fix Patch
```

---

### STORY: UI-011 - Animation Polish
```
Type: Task
Priority: Medium
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
Tags: polish, animations, ux

Description:
Polish animations và transitions:
- Smooth transitions
- Easing curves
- Timing adjustments
- Visual feedback
- Loading animations

Acceptance Criteria:
[ ] Transitions smooth
[ ] Curves natural
[ ] Timing feels right
[ ] Feedback clear
[ ] Loading pleasant

Dependencies: UI-010

Output: Polished UI Animations
```

---

### STORY: UI-012 - UI Performance Optimization
```
Type: Task
Priority: High
Assignee: UI Developer
Story Points: 5
Time Estimate: 8h
tags: optimization, ui, performance

Description:
Optimize UI performance:
- Widget pooling
- Texture optimization
- Reduce draw calls
- Invalidation optimization
- Test on low-end devices

Acceptance Criteria:
[ ] Widgets pooled
[ ] Textures optimized
[ ] Draw calls reduced
[ ] Invalidation minimized
[ ] Low-end devices tested

Dependencies: TL-012

Output: Optimized UI System
```

---

### STORY: UI-013 - UI Documentation
```
Type: Task
Priority: Low
Assignee: UI Developer
Story Points: 3
Time Estimate: 4h
Tags: documentation, ui

Description:
Create UI implementation documentation:
- Widget hierarchy
- Binding guidelines
- Animation guidelines
- Style guide usage
- Common patterns

Acceptance Criteria:
[ ] Hierarchy documented
[ ] Bindings explained
[ ] Animations documented
[ ] Style guide complete
[ ] Patterns listed

Dependencies: UI-012

Output: UI Documentation (Confluence)
```

---

### STORY: INT-012 - End-to-End Flow Testing
```
Type: Task
Priority: Critical
Assignee: UI Integration
Story Points: 13
Time Estimate: 16h (2 days)
Tags: testing, integration, e2e

Description:
End-to-end flow testing của tất cả features:
- Full multiplayer flow
- Integration với existing systems
- Error scenarios
- Recovery flows
- Performance testing

Acceptance Criteria:
[ ] All flows tested
[ ] Integrations verified
[ ] Errors handled
[ ] Recovery working
[ ] Performance acceptable

Dependencies: INT-011, TL-011

Output: E2E Test Report + Integration Test Suite
```

---

### STORY: INT-013 - Edge Cases & Error Handling
```
Type: Task
Priority: High
Assignee: UI Integration
Story Points: 8
Time Estimate: 12h (1.5 days)
Tags: error-handling, edge-cases, quality

Description:
Handle edge cases và error scenarios:
- Network disconnections
- Server crashes
- Timeout scenarios
- Data corruption
- Graceful degradation

Acceptance Criteria:
[ ] All edge cases identified
[ ] Error handling implemented
[ ] Graceful degradation working
[ ] User feedback clear
[ ] No crashes

Dependencies: INT-012

Output: Robust Error Handling System
```

---

### STORY: INT-014 - Integration Test Suite
```
Type: Task
Priority: Medium
Assignee: UI Integration
Story Points: 8
Time Estimate: 8h
Tags: testing, automation, qa

Description:
Create automated integration test suite:
- Test cases for all flows
- Mock server responses
[ ] Automated UI tests
- Regression test suite
- CI integration

Acceptance Criteria:
[ ] Test suite created
[ ] All flows covered
[ ] Mocks working
[ ] UI tests automated
[ ] CI integrated

Dependencies: INT-013, TL-004

Output: Automated Test Suite (Jenkins)
```

---

## SUMMARY STATISTICS

### Total Tasks by Epic
- **Epic 1** (Foundation): 15 tasks = 51 story points
- **Epic 2** (Matchmaking): 20 tasks = 112 story points
- **Epic 3** (In-Game): 23 tasks = 145 story points
- **Epic 4** (Integration): 14 tasks = 107 story points

**Total**: 72 tasks = 415 story points

### Tasks by Role
- **Team Lead**: 15 tasks = 70 story points
- **Backend Engineer**: 18 tasks = 101 story points
- **Core Developer**: 17 tasks = 132 story points (most loaded)
- **UI Developer**: 13 tasks = 68 story points (reduced from original due to existing designs)
- **UI Integration**: 9 tasks = 44 story points

### Story Points to Hours Mapping
- 3 points = 4h (0.5 day)
- 5 points = 8h (1 day)
- 8 points = 8-12h (1-1.5 days)
- 13 points = 12-16h (1.5-2 days)

### Critical Path
**Backend → Core Dev → Integration**  
Total critical path: approximately 14-15 days

---

## YOUTRACK IMPORT INSTRUCTIONS

### Step 1: Create Project
1. YouTrack → New Project
2. Name: "Multiplayer Demo"
3. Key: "MP"
4. Template: "Scrum"

### Step 2: Create Epics
1. Import all 4 epics (MP-EPIC-001 to MP-EPIC-004)
2. Set timeline dates
3. Assign to team

### Step 3: Import Stories
1. Copy each story block
2. YouTrack → New Issue
3. Paste description
4. Set fields:
   - Type
   - Priority
   - Assignee
   - Story Points
   - Time Estimate
   - Tags
5. Link to Epic
6. Add dependencies

### Step 4: Setup Board
1. Create Kanban board
2. Columns: Backlog → To Do → In Progress → Review → Done
3. Swimlanes by Epic or Assignee

### Step 5: Setup Gantt Chart
1. Enable Gantt view
2. Link dependencies
3. Set start dates
4. Generate timeline

---

**Document Version**: 2.0  
**Ready for Import**: YES  
**Next Step**: Import vào YouTrack và start Sprint 1!

