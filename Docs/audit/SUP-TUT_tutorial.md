# SUP-TUT — Tutorial / Onboarding

## Phạm vi
Bước tutorial theo script, pool tooltip, điều kiện trigger, khóa điều khiển.

## Module/class C++ liên quan (file thật, `TutorialSystem/`)
- `TutorialManagerSubsystem.cpp` — `UTutorialManagerSubsystem` (674 dòng): state tutorial, pool tooltip, dispatch trigger, lock/unlock control.
- `TriggerCondition/TriggerCondition.cpp` + `TriggerCondition_CheckpointPassed.cpp` — điều kiện trigger.
- `ScriptTutorialWidget.cpp`, `TooltipTutorialWidget.cpp`, `TutorialTypes.cpp`, `DebugCmdTutorial.cpp`, `TutorialSaveGame.cpp`.

## Blueprint liên quan (đã xác minh tick qua VibeUE)
- **WBP_ScriptTutorial** (`/Game/UI/Tutorials`): 137 node, **Event Tick = KHÔNG có** → event-driven, tốt.
- **WBP_TooltipTutorial** (`/Game/UI/Tutorials`): 74 node, **Event Tick = KHÔNG có** → tốt.
- BP_Trigger_PassCheckpoint_* — trigger theo overlap, không tick.

## Điểm nóng hiệu năng cụ thể
- Trigger từ gameplay: `RaceTrackManager.cpp:264-266` gọi `TutorialManagerSubsystem->TriggerOnCheckpointPassed(*PlayerRaceState)` mỗi lần qua checkpoint (chỉ cho xe người chơi, không phải mỗi frame) → chi phí thấp, hợp lý.
- **`FindRow` tra cứu tooltip/step** — `TutorialManagerSubsystem.cpp:105` `TooltipMessageDataTable->FindRow<FTooltip>(...)`, `:207` `ScriptStepDataTable->FindRow<FTutorialStepData>(...)`. Chỉ chạy khi hiện tooltip/đổi step (event), không phải vòng nóng. Chấp nhận được.

Không có per-frame hotspot. Hai widget tutorial chính đã xác nhận không có Event Tick.

## Nợ kỹ thuật cụ thể
- File 674 dòng gộp nhiều trách nhiệm (state machine + pool + lock control + dispatch). Cân nhắc tách, nhưng không cấp bách.
- Cần null-check kết quả `FindRow` ở boundary (`:105`, `:207`) — có dùng `if (Row)` nên ổn.

## Audit Blueprint
ĐÃ kiểm tra live qua VibeUE: 2 widget tutorial chính event-driven, không Event Tick. Đạt.

## Mức ưu tiên: **P2**
Lý do: kiến trúc event-driven sạch, không hotspot. Chỉ là nợ tổ chức code (file lớn).
