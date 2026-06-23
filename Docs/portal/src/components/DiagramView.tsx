import { useEffect, useRef, useState, type ComponentType } from 'react';

/**
 * Type of the LikeC4 view component, imported lazily at runtime.
 *
 * IMPORTANT: we deliberately do NOT statically `import { LikeC4View } from
 * 'likec4:react'`. That virtual module pulls in the full LikeC4 engine
 * (xyflow/react-flow + the baked layout data for all 26 views) — a ~2.3 MB
 * client chunk. A static import folds those 2.3 MB into THIS component's
 * hydration chunk, so every `client:only` island on the architecture page
 * forces the browser to download + parse + execute all 2.3 MB on page load,
 * long before the first diagram can paint. Dynamic `import()` (below) splits the
 * engine into its own async chunk that loads once, only when a diagram nears the
 * viewport, without blocking text paint or island hydration.
 */
type LikeC4ViewComponent = ComponentType<{ viewId: string }>;

/**
 * One LikeC4 "project" per documentation version. Each project is a separate set
 * of `.c4` files under `likec4/<project>/` (see each folder's `likec4.config.json`)
 * and the Vite plugin compiles each into its own `likec4:react/<project>` virtual
 * module. We keep an explicit thunk map (not a computed `import()` path) because
 * Vite must see a literal module specifier to code-split each engine + its baked
 * layout data into its own async chunk.
 *
 * To add a new version: snapshot the model into `likec4/<slug>/`, then add a
 * `<slug>: () => import('likec4:react/<slug>')` entry here.
 */
const ENGINE_BY_PROJECT: Record<string, () => Promise<{ LikeC4View: unknown }>> = {
  current: () => import('likec4:react/current'),
  v1: () => import('likec4:react/v1'),
  multiplayer: () => import('likec4:react/multiplayer'),
};

/**
 * Map a LikeC4 feature element id (the camelCase view/element id) to its
 * Starlight feature page slug. These are the 25 L3 feature views defined in
 * `likec4/views.c4` after the 2026-06-15 OpenProject taxonomy restructure.
 *
 * The diagram nodes carry fully-qualified dotted ids on `data-nodeid`, e.g.
 * `client.epicDrive.dmPhys`, `client.epicDrive.dmPhys.f01_simcar`,
 * `client.cdnFeat`. We walk the segments and return the slug for the first
 * segment that is a known feature. `cdnFeat` is the one feature whose element
 * id differs from its page slug (`cdn`).
 */
const FEATURE_SLUG_BY_ID: Record<string, string> = {
  dmPhys: 'dm-phys', dmRace: 'dm-race', dmNos: 'dm-nos', dmRamp: 'dm-ramp',
  dmCam: 'dm-cam', dmSet: 'dm-set',
  vtMap: 'vt-map', vtCity: 'vt-city', vtTrack: 'vt-track',
  vtCarProg: 'vt-carprog', vtReward: 'vt-reward',
  gmMp: 'gm-mp', gmDc: 'gm-dc',
  cuRoom: 'cu-room', cuMenu: 'cu-menu',
  cdnFeat: 'cdn',
  supAi: 'sup-ai', supPool: 'sup-pool', supInv: 'sup-inv', supProf: 'sup-prof',
  supShop: 'sup-shop', supTut: 'sup-tut', supDbg: 'sup-dbg', supPerf: 'sup-perf',
};

/**
 * Derive the feature page slug from a LikeC4 node id.
 *
 * LikeC4 emits fully-qualified, dotted node ids on its `data-nodeid`
 * attribute, e.g. `client.epicDrive.dmPhys`, `client.epicDrive.dmPhys.f01_simcar`.
 * We split on '.' and return the slug of the first segment that maps to a real
 * feature page. Container/epic/external segments (`client`, `epicDrive`,
 * `nakama`) and leaf code ids (`f01_simcar`) yield no match and return null.
 *
 *   'client.epicDrive.dmPhys'            -> 'dm-phys'
 *   'client.epicDrive.dmPhys.f01_simcar' -> 'dm-phys'
 *   'client.cdnFeat'                     -> 'cdn'
 *   'client'                             -> null  (not a feature)
 *   'nakama'                             -> null  (not a feature)
 *
 * Returns null when the id does not map to a real feature page.
 */
export function featureSlugFromNodeId(rawId: string | null | undefined): string | null {
  if (!rawId) return null;
  for (const segment of rawId.split('.')) {
    const slug = FEATURE_SLUG_BY_ID[segment];
    if (slug) return slug;
  }
  return null;
}

interface Props {
  /** LikeC4 view id, e.g. 'index', 'containers', 'f02'. */
  viewId: string;
  /** Base path the site is served from (Astro import.meta.env.BASE_URL). */
  base: string;
  /**
   * Which versioned LikeC4 project to render from. Maps to `likec4:react/<project>`
   * via {@link ENGINE_BY_PROJECT}. Defaults to 'current' so existing (latest) pages
   * need no change; versioned snapshots pass their own slug (e.g. 'v1').
   */
  project?: string;
}

/**
 * Wraps an interactive LikeC4 diagram and adds 1-CLICK box -> LD page routing.
 *
 * LikeC4 1.58 renders every diagram node with a `data-nodeid` attribute, but the
 * nodes live inside per-island shadow roots, so the click event is retargeted to
 * the shadow host by the time it reaches our light-DOM wrapper. We attach a
 * single capturing click listener and inspect `event.composedPath()` (which still
 * contains the real shadow-DOM nodes, ordered target -> root). The first entry
 * carrying a `data-nodeid` is the innermost/most-specific node; we derive the
 * feature prefix from its (dotted, fully-qualified) id and, if it maps to a
 * feature LD page, navigate there. Clicks on non-feature nodes (or empty canvas)
 * fall through to LikeC4's own pan/zoom and in-diagram navigateTo behavior.
 */
export default function DiagramView({ viewId, base, project = 'current' }: Props) {
  const ref = useRef<HTMLDivElement>(null);

  // Lazy-LOAD the engine, not just lazy-mount the canvas. The LikeC4 engine is a
  // ~2.3 MB client chunk; eagerly importing it folds those bytes into this
  // island's hydration chunk and blocks the main thread for seconds after the
  // text paints (the architecture page hosts 26 of these islands). We hold the
  // component in state and only `import('likec4:react')` once the wrapper nears
  // the viewport, so the engine downloads once, asynchronously, and only
  // on-screen diagrams trigger it.
  const [LikeC4View, setLikeC4View] = useState<LikeC4ViewComponent | null>(null);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;

    let cancelled = false;
    const load = () => {
      // The virtual `likec4:react/<project>` module re-exports the engine + the
      // baked views for that version. Pick the engine for this island's project;
      // fall back to 'current' if an unknown slug is passed.
      const loader = ENGINE_BY_PROJECT[project] ?? ENGINE_BY_PROJECT.current;
      loader().then((mod) => {
        if (!cancelled) setLikeC4View(() => mod.LikeC4View as LikeC4ViewComponent);
      });
    };

    // Fallback for very old browsers: load immediately.
    if (typeof IntersectionObserver === 'undefined') {
      load();
      return () => {
        cancelled = true;
      };
    }

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries.some((e) => e.isIntersecting)) {
          load();
          observer.disconnect();
        }
      },
      // Start loading ~one viewport ahead so the diagram is ready by scroll.
      { rootMargin: '600px 0px' },
    );
    observer.observe(el);
    return () => {
      cancelled = true;
      observer.disconnect();
    };
  }, [project]);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;

    const onClick = (event: MouseEvent) => {
      // Nodes live in shadow DOM; event.target is retargeted to the shadow host.
      // Walk composedPath() (target -> root) and grab the first data-nodeid.
      let rawId: string | null = null;
      for (const entry of event.composedPath()) {
        const candidate = entry as Element;
        if (candidate && typeof candidate.getAttribute === 'function') {
          const id = candidate.getAttribute('data-nodeid');
          if (id) {
            rawId = id;
            break;
          }
        }
      }
      if (!rawId) return;

      const slug = featureSlugFromNodeId(rawId);
      if (!slug) return; // not a feature box -> let LikeC4 handle it

      // Build a base-aware absolute path: <base>/features/dm-phys.
      const normalizedBase = base.endsWith('/') ? base.slice(0, -1) : base;
      const href = `${normalizedBase}/features/${slug}`;

      // Real single-click navigation.
      event.preventDefault();
      event.stopPropagation();
      window.location.assign(href);
    };

    // Capture phase so we win before LikeC4's own handlers when the node is a feature.
    el.addEventListener('click', onClick, true);
    return () => el.removeEventListener('click', onClick, true);
  }, [base]);

  return (
    <div
      ref={ref}
      data-diagram-glue="feature-nav"
      style={{ width: '100%', height: '70vh', minHeight: '520px' }}
    >
      {LikeC4View ? (
        <LikeC4View viewId={viewId} />
      ) : (
        <div
          aria-hidden="true"
          style={{
            width: '100%',
            height: '100%',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            border: '1px solid var(--sl-color-gray-5)',
            borderRadius: '0.5rem',
            background: 'var(--sl-color-gray-6)',
            color: 'var(--sl-color-gray-3)',
            fontSize: '0.875rem',
          }}
        >
          Đang tải sơ đồ…
        </div>
      )}
    </div>
  );
}
