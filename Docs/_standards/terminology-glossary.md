---
title: Terminology Glossary
version: 1.1.0
status: approved
created: 2026-01-26
last_updated: 2026-01-26
---

# Terminology Glossary

**Breadcrumbs:** Docs > Standards > Terminology Glossary

## Overview

This glossary defines standard terminology for VNRacing documentation. All documentation must follow these conventions to maintain professional quality and consistency.

**Purpose:**
- Eliminate informal/casual language
- Standardize technical terminology
- Ensure consistency across 640+ documentation files

---

## 1. Informal → Professional Vietnamese

Replace informal Vietnamese expressions with professional equivalents.

| Informal (❌ Không dùng) | Professional (✅ Sử dụng) | Context | Example |
|--------------------------|---------------------------|---------|---------|
| ít trừng phạt hơn | giảm mức độ ảnh hưởng tiêu cực | Collision mechanics | "Hệ thống va chạm giảm mức độ ảnh hưởng tiêu cực khi va chạm" |
| khoan dung | có dung sai cao / linh hoạt | Physics tolerance | "Hệ thống vật lý có dung sai cao" |
| húc văng | đẩy ra khỏi đường đua | Collision description | "Xe có thể đẩy đối thủ ra khỏi đường đua" |
| đập hộp | mở hộp quà | Loot crate mechanics | "Người chơi mở hộp quà để nhận phần thưởng" |
| sẽ bổ sung sau | [PENDING] - Xem mục Placeholder | Incomplete content | Sử dụng format placeholder chuẩn |
| bứt phá qua | vượt qua | Movement | "Xe có khả năng vượt qua chướng ngại vật" |
| dính vào tường | mắc kẹt tại rào chắn | Collision | "Tránh tình trạng xe mắc kẹt tại rào chắn" |
| bay lên | nảy lên / bật lên | Physics | "Xe bật lên khi đi qua gờ giảm tốc" |
| văng ra | bị đẩy ra / mất kiểm soát | Collision | "Xe bị đẩy ra khi va chạm mạnh" |
| đâm sầm | va chạm trực diện | Collision | "Va chạm trực diện với rào chắn" |
| lao vào | tiếp cận / di chuyển về phía | Movement | "Xe di chuyển về phía checkpoint" |
| chạy bon bon | di chuyển ổn định | Movement | "Xe di chuyển ổn định trên đường thẳng" |
| quẹo | rẽ / chuyển hướng | Steering | "Xe chuyển hướng tại góc cua" |
| tông | va chạm | Collision | "Va chạm với xe khác" |
| đụng | va chạm / tiếp xúc | Collision | "Tiếp xúc với rào chắn" |

---

## 2. Approximation Notation

Standardize how approximate values are expressed.

### In Prose (văn xuôi)

| Informal (❌) | Professional (✅) | Example |
|---------------|-------------------|---------|
| ~50% | approximately 50% | "Giảm approximately 50% damage" |
| ~100km/h | approximately 100 km/h | "Tốc độ tối đa approximately 100 km/h" |
| khoảng 3 giây | approximately 3 seconds | "Cooldown approximately 3 seconds" |
| tầm 5 lần | approximately 5 times | "Tăng approximately 5 times so với base" |
| chừng 10% | approximately 10% | "Bonus approximately 10%" |

### In Tables and Code

| Informal (❌) | Professional (✅) | Usage |
|---------------|-------------------|-------|
| ~50% | ≈50% hoặc 45-55% | Tables, specifications |
| ~100km/h | ≈100 km/h | Technical specs |
| ~3 giây | 3s (±0.5s) | Timing specifications |
| ~5-10 | 5-10 (range) | Numeric ranges |

### Mathematical Context

| Context | Format | Example |
|---------|--------|---------|
| Exact value | X | 100 km/h |
| Approximate | ≈X | ≈100 km/h |
| Range | X-Y | 95-105 km/h |
| Tolerance | X (±Y) | 100 km/h (±5) |
| Percentage range | X-Y% | 45-55% |

---

## 3. Technical Terms Standardization

Use consistent terminology for technical concepts.

| Variations (❌ Không nhất quán) | Standard (✅) | Definition |
|--------------------------------|---------------|------------|
| Rubber Banding, RubberBand, Rubberband, rubber banding | **Rubber Banding** | Dynamic difficulty adjustment system that helps trailing racers catch up |
| CoolDown, Cooldown, Cool Down, cooldown | **Cooldown** | Time period before an ability can be used again |
| A.I, AI, A.I., ai, Ai | **AI** | Artificial Intelligence |
| Racing Line, RacingLine, racing line | **Racing Line** | Optimal path through a track section |
| NOS, Nos, nos, N.O.S | **NOS** | Nitrous Oxide System (boost) |
| Drift, drift, DRIFT | **Drift** | Controlled oversteer technique |
| Checkpoint, CheckPoint, check point | **Checkpoint** | Track progress marker |
| Respawn, ReSpawn, re-spawn | **Respawn** | Return to track after crash/fall |
| Hitbox, HitBox, hit box | **Hitbox** | Collision detection boundary |
| Framerate, FrameRate, frame rate | **Frame Rate** | Frames rendered per second |
| Gameplay, GamePlay, game play | **Gameplay** | Interactive game experience |

---

## 4. Placeholder Format Standard

When content is incomplete or pending, use this standardized format:

### Standard Placeholder Block

```markdown
> **[PENDING]** Brief description of what content is needed.  
> **Owner**: [Team Name or Role]  
> **Target Date**: [YYYY-MM-DD or TBD]
```

### Examples

**For missing feature documentation:**
```markdown
> **[PENDING]** Tutorial flow documentation for Advanced Car Upgrade feature.  
> **Owner**: UX Team  
> **Target Date**: 2026-Q2
```

**For incomplete technical specs:**
```markdown
> **[PENDING]** Performance benchmarks for low-end devices.  
> **Owner**: Performance Team  
> **Target Date**: TBD
```

### Deprecated Patterns (❌ Không sử dụng)

| Pattern | Replacement |
|---------|-------------|
| TBD | [PENDING] block |
| Pending | [PENDING] block |
| TODO | [PENDING] block |
| sẽ bổ sung sau | [PENDING] block |
| ... (trailing ellipsis for incomplete) | [PENDING] block |
| Đang cập nhật | [PENDING] block |
| Chưa hoàn thành | [PENDING] block |

---

## 5. Language Policy by Document Type

| Document Type | Primary Language | Notes |
|---------------|------------------|-------|
| Requirements (GDDs) | Vietnamese | English technical terms allowed |
| Design Documents | English | Vietnamese cultural terms preserved |
| Architecture Docs | English | Technical audience |
| Planning Docs | English | Project management |
| Implementation Docs | English | Developer audience |
| Testing Docs | English | QA audience |
| README files | English | Vietnamese proper nouns preserved |

### Vietnamese Terms to Preserve (Proper Nouns)

These Vietnamese terms should NOT be translated:

| Category | Examples |
|----------|----------|
| City Names | Hà Nội, TP. Hồ Chí Minh, Đà Nẵng, Huế, Hội An |
| Landmarks | Hồ Gươm, Cầu Rồng, Bến Thành, Bitexco |
| Cultural Terms | VN-Tour, Phố cổ, Đèn lồng |
| Feature Names | When used as identifiers in code/config |

---

## 6. Abbreviations

Define abbreviations on first use, then use consistently.

| Abbreviation | Full Form | First Use Example |
|--------------|-----------|-------------------|
| AI | Artificial Intelligence | "Artificial Intelligence (AI) opponents..." |
| NOS | Nitrous Oxide System | "Nitrous Oxide System (NOS) provides..." |
| UI | User Interface | "User Interface (UI) elements..." |
| UX | User Experience | "User Experience (UX) design..." |
| FPS | Frames Per Second | "Frames Per Second (FPS) target..." |
| IAP | In-App Purchase | "In-App Purchase (IAP) integration..." |
| XP | Experience Points | "Experience Points (XP) system..." |
| HP | Health Points / Horsepower | Context-dependent, define on first use |
| DLC | Downloadable Content | "Downloadable Content (DLC)..." |
| SDK | Software Development Kit | "Software Development Kit (SDK)..." |
| API | Application Programming Interface | "Application Programming Interface (API)..." |

---

## 7. Units and Formatting

### Speed
| Format | Example |
|--------|---------|
| Standard | 100 km/h |
| With space | 100 km/h (not 100km/h) |

### Time
| Format | Example |
|--------|---------|
| Seconds | 3s, 3 seconds |
| Milliseconds | 100ms |
| Minutes | 5 min, 5 minutes |

### Percentages
| Format | Example |
|--------|---------|
| Standard | 50% |
| With space before | 50% (not 50 %) |

### Currency
| Format | Example |
|--------|---------|
| In-game Coin | 1,000 Coins |
| In-game Cash | 500 Cash |
| Real money | $4.99, 99,000 VND |

---

## 8. Common Mistakes to Avoid

| Mistake (❌) | Correction (✅) | Reason |
|--------------|-----------------|--------|
| "Xe sẽ bị húc văng ra ngoài" | "Xe bị đẩy ra khỏi đường đua" | Informal language |
| "Giảm ~50% damage" | "Giảm approximately 50% damage" | Informal approximation |
| "Feature này sẽ bổ sung sau..." | [PENDING] block | Unprofessional placeholder |
| "rubberband system" | "Rubber Banding system" | Inconsistent capitalization |
| "100km/h" | "100 km/h" | Missing space |
| "người chơi đập hộp" | "người chơi mở hộp quà" | Informal term |
| "AI, A.I, ai" mixed | "AI" consistently | Inconsistent terminology |

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-26 | Initial glossary creation |

---

**Related Documents:**
- [Documentation Standards](./documentation-standards.md)
- [Code Standards](./code-standards.md)
- [Naming Conventions](./naming-conventions.md)

