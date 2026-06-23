# PC — Project Config — Low-Level Design

> Source: DevOps/build infrastructure (not client runtime source).
> OpenProject: #148.

## Feature summary and boundaries

🔧 **Status: infra.** PC covers the DevOps, build pipeline and infrastructure configuration for VNRacing. This is not a client runtime feature and has no C++ subsystem — it lives in CI/CD scripts, build configs and tooling outside `PrototypeRacing/Source/`.

PC scope includes:
- Unreal build configuration (target files, ini configs, packaging rules).
- Chunk/pak splitting policy for CDN delivery (defines what goes into which pak chunk; the client runtime consumer is **CDN** #250).
- AWS bucket setup for chunk upload and distribution.
- k6 load testing scripts for backend/Nakama endpoint stress tests.

No embed diagram — infra/no C4 client component view for PC.

## Layer 1 — Implementation map

No C++ components to map. Infrastructure artefacts live outside `PrototypeRacing/Source/`:

| Artefact (proposed / known) | Responsibility |
|---|---|
| Build target / packaging rules | Controls pak splitting (primary + chunk N); feeds CDN pak files. |
| AWS upload scripts | Push pak chunks to S3/CDN bucket post-build. |
| k6 load test scripts | Stress-test Nakama endpoints; validates GM-MP backend capacity. |
| CI/CD pipeline definition | Automates build → package → upload → test cycle. |

## Layer 2 — Contract surface

PC produces artefacts consumed by CDN (#250) at runtime and by GM-MP (#273) indirectly (k6 validates backend capacity). There are no C++ entry points in PC itself.

## Links

- Portal: `Docs/portal/src/content/docs/features/pc.md`
- No audit file — infra feature, no client C++ code to audit.
- Cross-ref: CDN (#250) — runtime chunk download consumer; GM-MP (#273) — k6 load test target
