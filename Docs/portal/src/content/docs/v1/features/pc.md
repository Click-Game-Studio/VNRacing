---
title: PC — Project Config
description: "Cấu hình dự án và hạ tầng DevOps: packaging, chia chunk CDN,
  upload AWS và k6 load test."
slug: v1/features/pc
---

> OpenProject: #148.

## Tổng quan

🔧 **Trạng thái: infra.** PC bao gồm DevOps, build pipeline và cấu hình hạ tầng cho VNRacing. Đây không phải feature runtime client và không có subsystem C++ — nó nằm trong CI/CD scripts, build config và tooling bên ngoài `PrototypeRacing/Source/`.

## Phạm vi

* Cấu hình build Unreal (target files, ini configs, packaging rules).
* Chính sách chia chunk/pak cho CDN (xác định nội dung nào vào pak chunk nào; phía client runtime sử dụng là **CDN** #250).
* Thiết lập AWS bucket cho upload và phân phối chunk.
* Scripts k6 load test cho backend/Nakama endpoint.

## Thành phần (hạ tầng)

| Artefact | Vai trò |
|---|---|
| Build target / packaging rules | Kiểm soát chia pak (primary + chunk N); tạo pak file cho CDN. |
| AWS upload scripts | Đẩy pak chunk lên S3/CDN bucket sau build. |
| k6 load test scripts | Stress-test Nakama endpoint; xác nhận năng lực backend GM-MP. |
| CI/CD pipeline | Tự động hóa chu trình build → package → upload → test. |

## Điểm cần lưu ý

Không có entry point C++ trong PC. PC tạo ra artefact được CDN (#250) sử dụng ở runtime và gián tiếp hỗ trợ GM-MP (#273) qua k6 load test backend.

Không có sơ đồ C4 component view cho PC — xem tổng quan kiến trúc hệ thống tại trang [Architecture](/v1/architecture/).

## Tham chiếu

* LD: `Docs/ld/PC_project_config.md`
* Cross-ref: CDN (#250) — runtime consumer chunk download; GM-MP (#273) — mục tiêu k6 load test
