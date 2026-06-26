# VNRacing Structurizr Review

Canonical workspace: `E:/WS/admin_iconic_Visual_9594/Docs/structurizr/workspace.dsl`

## Validate locally

From the workspace root (`E:/WS/admin_iconic_Visual_9594`) or the Structurizr folder, run the bundled CLI if available:

```bash
/e/WS/admin_iconic_Visual_9594/Docs/structurizr/.tools/cli/structurizr.sh validate -workspace /e/WS/admin_iconic_Visual_9594/Docs/structurizr/workspace.dsl
```

On Windows, the bundled CLI may also expose a `.bat` or `.cmd` launcher under `.tools/cli`; use the equivalent `validate -workspace ...` command.

## Review with rich docs and ADRs

Use Structurizr Lite, Cloud or on-prem pointed at `workspace.dsl`. This workspace imports:

```dsl
!docs docs
!adrs adrs
```

The rich review path is required because diagrams, arc42 docs and ADRs are meant to be read together.

## Static export limitation

Static export is only a diagram snapshot. It does not preserve the full docs/decision review experience from Structurizr Lite/Cloud/on-prem. Do not treat static export output as the canonical architecture package.

## Known Lite path note on Windows

If Structurizr Lite cannot resolve the workspace path, start it with an absolute path using forward slashes, for example `E:/WS/admin_iconic_Visual_9594/Docs/structurizr`, or launch from the `Docs/structurizr` directory and select `workspace.dsl` explicitly.
