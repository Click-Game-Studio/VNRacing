## 1. Rewrite traceability.md (master mapping)

- [ ] 1.1 Build the new 10-column flat table from CSV 06-23 data: Mã | OP ID | Tên Feature | Epic | 🆕 | Sub Features | Code thật | TT | Map cũ | LD. Sort by Epic then Mã.
- [ ] 1.2 Mark each row that has no corresponding row in the 06-15 CSV with `🆕 since 2026-06-23`. Affected codes: CU-THEME, CU-VIS, CU-VIS-*, CU-PERF, CU-PERF-CORE/CR/DRIVE, CU-SEL, SH, SH-DISP, SH-FLOW, DM-RACE-MINIMAP, VT-CITY-IU, VT-TRACK-RW/UN, GM-DC-UN/CFG, GM-MP-MATCH/RACE/POST.
- [ ] 1.3 Add the Support subsystems table (SUP-*, unchanged) below the product table.
- [ ] 1.4 Update `Docs/_legacy_F-map.md`: add note "No further F01-F17 codes added since 2026-06-15; the F## system is now closed."
- [ ] 1.5 Update both feature-catalog pages (`Docs/structurizr/docs/04-feature-catalog.md` and `Docs/portal/src/content/docs/architecture/feature-catalog.md`) to match the new flat table. ← (verify: tables match traceability.md exactly, no rows missing or extra)

## 2. Create ld/ and audit/ skeletons for new Features

- [ ] 2.1 Create `Docs/ld/CU-THEME_theme_change.md` — gap doc pattern
- [ ] 2.2 Create `Docs/ld/CU-VIS_car_customize_visual.md` — one ld file, with `### CU-VIS-BODY`, `### CU-VIS-PAINT`, `### CU-VIS-PREV`, `### CU-VIS-CAM`, `### CU-VIS-TEST` sub-sections
- [ ] 2.3 Create `Docs/ld/CU-PERF_car_customize_performance.md` — with `### CU-PERF-CORE`, `### CU-PERF-CR`, `### CU-PERF-DRIVE` sub-sections
- [ ] 2.4 Create `Docs/ld/CU-SEL_car_selection.md` — gap doc pattern
- [ ] 2.5 Create `Docs/ld/SH_shop_iap.md` — Epic-level ld doc; with `### SH-DISP`, `### SH-FLOW` sections. For SH-FLOW reference the existing `UCommerceSubsystem` code.
- [ ] 2.6 Create `Docs/ld/DM-RACE-MINIMAP_minimap.md` — gap doc pattern
- [ ] 2.7 Create `Docs/ld/VT-CITY-IU_item_unlock.md` — gap doc pattern
- [ ] 2.8 Create `Docs/ld/VT-TRACK-RW_track_rewards.md` — partial impl doc; reference `URewardCenterSubsystem`
- [ ] 2.9 Create `Docs/ld/VT-TRACK-UN_track_unlock.md` — impl doc; reference `UProgressionSubsystem::UnlockNext`
- [ ] 2.10 Create `Docs/ld/GM-DC-UN_challenge_unlock.md` and `Docs/ld/GM-DC-CFG_challenge_config.md` — gap doc patterns (or as sub-sections if parent Feature already has a ld doc — check: GM-DC_daily_challenge.md exists, add as sections)
- [ ] 2.11 Create `Docs/ld/GM-MP-MATCH_multiplayer_match.md`, `Docs/ld/GM-MP-RACE_multiplayer_race.md`, `Docs/ld/GM-MP-POST_multiplayer_post.md` — gap doc patterns (check if GM-MP.md exists — yes, add as sections)
- [ ] 2.12 Create corresponding `Docs/audit/<CODE>_<name>.md` files for every new code above, following "Missing — code chưa impl" pattern for ❌ status items. ← (verify: every new Mã has both a ld/ and audit/ file; sub-sections inside parent files count as having coverage)

## 3. Portal pages for new Features

- [ ] 3.1 For each new Mã above, create `Docs/portal/src/content/docs/features/<Mã>.mdx` — porting content from the `Docs/ld/` sibling
- [ ] 3.2 Update `Docs/portal/astro.config.mjs` — add sidebar entries under the correct Epic group for each new page. ← (verify: no orphan .mdx — every new file has a sidebar entry)

## 4. c4 model + views

- [ ] 4.1 Add `epic` elements to `Docs/c4/model.c4` for Epic #272 GAME MODE, #298 CUSTOMIZE, #366 SHOP & IAP (epic elements already exist for others)
- [ ] 4.2 Add `feature` elements to `Docs/c4/model.c4` for every new Mã
- [ ] 4.3 Add `<Mã>_Components` views to `Docs/c4/views.c4` for each new Feature
- [ ] 4.4 Copy `Docs/c4/model.c4` to `Docs/portal/likec4/model.c4` and `Docs/c4/views.c4` to `Docs/portal/likec4/views.c4`
- [ ] 4.5 Run `cd Docs/c4 && npx --no-install likec4 validate .` → exit 0 ← (verify: likec4 exits 0; no element or relationship errors)

## 5. structurizr workspace

- [ ] 5.1 Rename every `F##_Components` view in `Docs/structurizr/workspace.dsl` to its corresponding `<CODE>_Components`: F01→DM-PHYS, F02→DM-RACE, etc. (crosswalk from `Docs/_legacy_F-map.md`)
- [ ] 5.2 Add `<CODE>_Components` views for each new Mã not mapping from an old F##
- [ ] 5.3 Run structurizr CLI validate ← (verify: `java -cp ".tools/cli/lib/*" com.structurizr.cli.StructurizrCliApplication validate -workspace workspace.dsl` exits 0)

## 6. Final verification

- [ ] 6.1 Run `cd Docs/portal && npm run build` → exit 0, page count ~37→~50
- [ ] 6.2 Run `node c4/render-ld.mjs` → renders successfully (~25→~40 html)
- [ ] 6.3 All 4 validate commands pass (likec4, structurizr, portal build, render-ld) ← (verify: every command listed above exits 0; if any fails, fix before declaring done)

## 7. Content corrections from CSV 06-23

- [ ] 7.1 Rename `#320 Main menu_Level` → `Main menu_Theme Change` in every doc where it appears (traceability.md, ld/CU-MENU_main_menu.md, portal features/CU-MENU.mdx, astro.config.mjs sidebar label, c4 model description, structurizr workspace name)