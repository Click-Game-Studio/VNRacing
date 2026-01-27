# Performance Targets - VNRacing

**Breadcrumbs:** Docs > Architecture > Performance Targets

**Version:** 1.1.0 | **Date:** 2026-01-26

![Status: Development](https://img.shields.io/badge/Status-Development-blue)

---

## Table of Contents

1. [Overview](#overview)
2. [Frame Rate Targets](#1-frame-rate-targets)
   - [Target Frame Rates](#target-frame-rates)
   - [Frame Time Budgets](#frame-time-budgets)
   - [Device Tier Classification](#device-tier-classification)
3. [Memory Budgets](#2-memory-budgets)
   - [Total Memory Budget](#total-memory-budget)
   - [Texture Memory Budget](#texture-memory-budget)
   - [Mesh Memory Budget](#mesh-memory-budget)
4. [Draw Call Budgets](#3-draw-call-budgets)
   - [Draw Call Limits](#draw-call-limits)
   - [Draw Call Breakdown](#draw-call-breakdown)
5. [Loading Time Targets](#4-loading-time-targets)
   - [Initial Load](#initial-load)
   - [Level Load](#level-load)
   - [Asset Streaming](#asset-streaming)
6. [Network Performance Targets](#5-network-performance-targets)
   - [Latency Targets](#latency-targets)
   - [Bandwidth Targets](#bandwidth-targets)
   - [Replication Frequency](#replication-frequency)
7. [Battery Consumption Targets](#6-battery-consumption-targets)
   - [Battery Drain Rate](#battery-drain-rate)
   - [Power Optimization](#power-optimization)
8. [Asset Size Budgets](#7-asset-size-budgets)
   - [Texture Sizes](#texture-sizes)
   - [Mesh Complexity](#mesh-complexity)
9. [Audio Performance Targets](#8-audio-performance-targets)
   - [Audio Budget](#audio-budget)
   - [Audio Quality](#audio-quality)
10. [Profiling Targets](#9-profiling-targets)
    - [CPU Profiling](#cpu-profiling)
    - [GPU Profiling](#gpu-profiling)
11. [Quality Scalability Settings](#10-quality-scalability-settings)
    - [Graphics Quality Levels](#graphics-quality-levels)
12. [Benchmarking Methodology](#11-benchmarking-methodology)
    - [Test Scenarios](#test-scenarios)
    - [Performance Metrics to Track](#performance-metrics-to-track)
    - [Profiling Tools](#profiling-tools)
13. [Performance Regression Testing](#12-performance-regression-testing)
    - [Automated Tests](#automated-tests)
    - [Regression Thresholds](#regression-thresholds)
14. [Optimization Priorities](#13-optimization-priorities)
15. [Performance Target Summary](#performance-target-summary)
16. [Conclusion](#conclusion)

---

## Overview

This document defines the performance targets, budgets, and benchmarks for PrototypeRacing across different mobile device tiers and network conditions.

---

## 1. Frame Rate Targets

### Target Frame Rates

| Device Tier | Target FPS | Minimum FPS | Resolution |
|-------------|-----------|-------------|------------|
| **High-End** | 60 FPS | 55 FPS | 1080p (1920x1080) |
| **Mid-Range** | 60 FPS | 50 FPS | 720p (1280x720) |
| **Low-End** | 30 FPS | 25 FPS | 540p (960x540) |

### Frame Time Budgets

| Target FPS | Frame Time Budget | Game Thread | Render Thread | GPU |
|-----------|-------------------|-------------|---------------|-----|
| **60 FPS** | 16.67 ms | 10 ms | 10 ms | 12 ms |
| **30 FPS** | 33.33 ms | 20 ms | 20 ms | 25 ms |

### Device Tier Classification

**High-End Devices**:
- iPhone 13 Pro and newer
- Samsung Galaxy S21 and newer
- Google Pixel 6 and newer
- Snapdragon 888+ or better
- Apple A15 Bionic or better

**Mid-Range Devices**:
- iPhone 11 and newer
- Samsung Galaxy A52 and newer
- Snapdragon 750G or better
- Apple A13 Bionic or better

**Low-End Devices**:
- iPhone XR and newer
- Samsung Galaxy A32 and newer
- Snapdragon 665 or better
- Apple A12 Bionic or better

---

## 2. Memory Budgets

### Total Memory Budget

| Device Tier | Total Budget | Textures | Meshes | Audio | Code | Other |
|-------------|-------------|----------|--------|-------|------|-------|
| **High-End** | 2.5 GB | 1.2 GB | 500 MB | 200 MB | 300 MB | 300 MB |
| **Mid-Range** | 2.0 GB | 900 MB | 400 MB | 150 MB | 300 MB | 250 MB |
| **Low-End** | 1.5 GB | 600 MB | 300 MB | 100 MB | 300 MB | 200 MB |

### Texture Memory Budget

| Asset Type | High-End | Mid-Range | Low-End |
|-----------|----------|-----------|---------|
| **Vehicle Textures** | 256 MB | 192 MB | 128 MB |
| **Environment Textures** | 512 MB | 384 MB | 256 MB |
| **UI Textures** | 128 MB | 96 MB | 64 MB |
| **VFX Textures** | 128 MB | 96 MB | 64 MB |
| **Other** | 176 MB | 132 MB | 88 MB |

### Mesh Memory Budget

| Asset Type | High-End | Mid-Range | Low-End |
|-----------|----------|-----------|---------|
| **Vehicles** | 150 MB | 120 MB | 90 MB |
| **Environment** | 250 MB | 200 MB | 150 MB |
| **Props** | 100 MB | 80 MB | 60 MB |

---

## 3. Draw Call Budgets

### Draw Call Limits

| Device Tier | Max Draw Calls | Triangles per Frame | Vertices per Frame |
|-------------|---------------|---------------------|-------------------|
| **High-End** | 2000 | 2,000,000 | 3,000,000 |
| **Mid-Range** | 1500 | 1,500,000 | 2,000,000 |
| **Low-End** | 1000 | 1,000,000 | 1,500,000 |

### Draw Call Breakdown

| Category | High-End | Mid-Range | Low-End |
|----------|----------|-----------|---------|
| **Environment** | 800 | 600 | 400 |
| **Vehicles** | 400 | 300 | 200 |
| **VFX** | 300 | 200 | 150 |
| **UI** | 200 | 150 | 100 |
| **Other** | 300 | 250 | 150 |

---

## 4. Loading Time Targets

### Initial Load

| Device Tier | Target | Maximum |
|-------------|--------|---------|
| **High-End** | 5 seconds | 8 seconds |
| **Mid-Range** | 8 seconds | 12 seconds |
| **Low-End** | 10 seconds | 15 seconds |

### Level Load

| Device Tier | Target | Maximum |
|-------------|--------|---------|
| **High-End** | 3 seconds | 5 seconds |
| **Mid-Range** | 5 seconds | 8 seconds |
| **Low-End** | 8 seconds | 12 seconds |

### Asset Streaming

| Asset Type | Target Load Time | Maximum |
|-----------|------------------|---------|
| **Vehicle** | 0.5 seconds | 1 second |
| **Track Section** | 1 second | 2 seconds |
| **UI Screen** | 0.2 seconds | 0.5 seconds |

---

## 5. Network Performance Targets

### Latency Targets

| Network Quality | Target Latency | Maximum Latency | Packet Loss |
|----------------|----------------|-----------------|-------------|
| **Excellent** | <50 ms | 80 ms | <1% |
| **Good** | <100 ms | 150 ms | <3% |
| **Acceptable** | <150 ms | 200 ms | <5% |
| **Poor** | <200 ms | 300 ms | <10% |

### Bandwidth Targets

| Scenario | Target Bandwidth | Maximum Bandwidth |
|----------|-----------------|-------------------|
| **Multiplayer Race** | 50 KB/s per player | 100 KB/s per player |
| **Matchmaking** | 10 KB/s | 20 KB/s |
| **Cloud Sync** | 20 KB/s | 50 KB/s |
| **Leaderboards** | 5 KB/s | 10 KB/s |

### Replication Frequency

| Actor Type | Update Frequency | Bandwidth per Actor |
|-----------|------------------|---------------------|
| **Player Vehicle** | 30 Hz | 15 KB/s |
| **AI Vehicle (Near)** | 10 Hz | 5 KB/s |
| **AI Vehicle (Far)** | 1 Hz | 0.5 KB/s |
| **Pickups** | 1 Hz | 0.2 KB/s |

---

## 6. Battery Consumption Targets

### Battery Drain Rate

| Mode | Target Drain | Maximum Drain |
|------|-------------|---------------|
| **Active Gameplay** | 15% per hour | 20% per hour |
| **Menu/Idle** | 5% per hour | 8% per hour |
| **Battery Saving Mode** | 10% per hour | 12% per hour |

### Power Optimization

| Setting | Normal Mode | Battery Saving Mode |
|---------|------------|---------------------|
| **Frame Rate** | 60 FPS | 30 FPS |
| **Quality** | Medium/High | Low |
| **Update Frequency** | 1.0x | 0.5x |
| **VFX** | Full | Reduced |

---

## 7. Asset Size Budgets

### Texture Sizes

| Asset Type | High-End | Mid-Range | Low-End |
|-----------|----------|-----------|---------|
| **Vehicle Diffuse** | 2048x2048 | 1024x1024 | 512x512 |
| **Environment Diffuse** | 2048x2048 | 1024x1024 | 512x512 |
| **UI Textures** | 1024x1024 | 512x512 | 512x512 |
| **VFX Textures** | 512x512 | 256x256 | 256x256 |

### Mesh Complexity

| Asset Type | Max Triangles (High) | Max Triangles (Mid) | Max Triangles (Low) |
|-----------|---------------------|---------------------|---------------------|
| **Player Vehicle** | 50,000 | 30,000 | 20,000 |
| **AI Vehicle** | 30,000 | 20,000 | 15,000 |
| **Environment Prop** | 10,000 | 5,000 | 3,000 |
| **Building** | 20,000 | 10,000 | 5,000 |

---

## 8. Audio Performance Targets

### Audio Budget

| Device Tier | Max Simultaneous Sounds | Audio Memory |
|-------------|------------------------|--------------|
| **High-End** | 32 | 200 MB |
| **Mid-Range** | 24 | 150 MB |
| **Low-End** | 16 | 100 MB |

### Audio Quality

| Audio Type | Sample Rate | Bit Depth | Compression |
|-----------|------------|-----------|-------------|
| **Music** | 44.1 kHz | 16-bit | OGG Vorbis |
| **SFX** | 22.05 kHz | 16-bit | OGG Vorbis |
| **Voice** | 22.05 kHz | 16-bit | OGG Vorbis |

---

## 9. Profiling Targets

### CPU Profiling

| System | Target Time | Maximum Time |
|--------|------------|--------------|
| **Game Thread** | 8 ms | 10 ms |
| **Render Thread** | 8 ms | 10 ms |
| **Physics** | 2 ms | 4 ms |
| **Animation** | 1 ms | 2 ms |
| **AI** | 1 ms | 2 ms |
| **Networking** | 0.5 ms | 1 ms |

### GPU Profiling

| Pass | Target Time | Maximum Time |
|------|------------|--------------|
| **Base Pass** | 4 ms | 6 ms |
| **Lighting** | 2 ms | 3 ms |
| **Post-Processing** | 2 ms | 3 ms |
| **Translucency** | 1 ms | 2 ms |
| **UI** | 1 ms | 1.5 ms |

---

## 10. Quality Scalability Settings

### Graphics Quality Levels

| Setting | Low | Medium | High | Ultra |
|---------|-----|--------|------|-------|
| **Resolution Scale** | 0.5 | 0.75 | 1.0 | 1.0 |
| **View Distance** | 0 | 1 | 2 | 3 |
| **Shadow Quality** | 0 | 1 | 2 | 3 |
| **Post-Process** | 0 | 1 | 2 | 3 |
| **Texture Quality** | 0 | 1 | 2 | 3 |
| **Effects Quality** | 0 | 1 | 2 | 3 |
| **Foliage Quality** | 0 | 1 | 2 | 3 |

---

## 11. Benchmarking Methodology

### Test Scenarios

1. **Race Start**: Measure frame time during race countdown and start
2. **Mid-Race**: Measure sustained performance during active racing
3. **Crowded Scene**: Maximum AI vehicles and VFX
4. **Level Transition**: Measure loading times between tracks
5. **Menu Navigation**: UI responsiveness and frame rate
6. **Multiplayer**: Network performance with 8 players

### Performance Metrics to Track

- **Frame Rate**: Average, minimum, maximum
- **Frame Time**: Average, 95th percentile, 99th percentile
- **Memory Usage**: Peak, average, by category
- **Draw Calls**: Average, peak
- **Network Latency**: Average, peak, packet loss
- **Battery Drain**: Per hour, per race
- **Loading Times**: Initial, level, asset streaming

### Profiling Tools

- **Unreal Insights**: Detailed CPU/GPU profiling
- **stat fps**: Real-time FPS display
- **stat unit**: Game/Render/GPU thread times
- **stat memory**: Memory usage breakdown
- **stat gpu**: GPU pass breakdown
- **Platform Profilers**: Xcode Instruments (iOS), Android Profiler

---

## 12. Performance Regression Testing

### Automated Tests

- **Frame Rate Test**: Automated race with FPS logging
- **Memory Test**: Track memory usage over time
- **Loading Test**: Measure all loading scenarios
- **Network Test**: Simulate various network conditions

### Regression Thresholds

| Metric | Warning Threshold | Failure Threshold |
|--------|------------------|-------------------|
| **FPS Drop** | -5 FPS | -10 FPS |
| **Memory Increase** | +50 MB | +100 MB |
| **Loading Time Increase** | +1 second | +2 seconds |
| **Draw Call Increase** | +100 | +200 |

---

## 13. Optimization Priorities

### High Priority (Must Fix)

- Frame rate below minimum target
- Memory exceeding budget
- Loading times exceeding maximum
- Critical network issues

### Medium Priority (Should Fix)

- Frame rate below target (but above minimum)
- Memory approaching budget
- Loading times approaching maximum
- Minor network issues

### Low Priority (Nice to Have)

- Frame rate optimization beyond target
- Memory optimization below budget
- Loading time optimization below target
- Network optimization beyond target

---

## Performance Target Summary

| Category | Target | Measurement |
|----------|--------|-------------|
| **Frame Rate** | 60 FPS (mobile) | stat fps |
| **Frame Time** | <16.67 ms | stat unit |
| **Memory** | <2 GB (mid-range) | stat memory |
| **Draw Calls** | <1500 (mid-range) | stat scenerendering |
| **Loading Time** | <8 seconds (initial) | Manual timing |
| **Network Latency** | <100 ms | stat net |
| **Battery Drain** | <15% per hour | Platform tools |

---

## Conclusion

The PrototypeRacing performance targets ensure:
- **Smooth Gameplay**: 60 FPS on mid-range devices
- **Efficient Memory**: Within mobile device constraints
- **Fast Loading**: Quick initial and level loads
- **Low Latency**: Responsive multiplayer experience
- **Battery Friendly**: Reasonable power consumption

All features must meet these performance targets before release. Regular profiling and optimization are mandatory throughout development.

