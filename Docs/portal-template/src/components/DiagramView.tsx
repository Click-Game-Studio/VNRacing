import { useCallback, useEffect, useRef, useState, type ComponentType } from 'react';

type LikeC4ViewComponent = ComponentType<{
  viewId: string;
  pannable: boolean;
  zoomable: boolean;
}>;
type EngineModule = { LikeC4View: LikeC4ViewComponent };

const ENGINE_BY_PROJECT: Record<string, () => Promise<EngineModule>> = {
  current: () => import('likec4:react/current') as Promise<EngineModule>,
  v1: () => import('likec4:react/v1') as Promise<EngineModule>,
  preview: () => import('likec4:react/preview') as Promise<EngineModule>,
};

interface Props {
  viewId: string;
  project: string;
  base: string;
  label: string;
  nodeLinks: Record<string, string>;
}

function withBase(base: string, path: string): string {
  const prefix = base === '/' ? '' : `/${base.replace(/^\/+|\/+$/g, '')}`;
  return `${prefix}/${path.replace(/^\/+/, '')}`;
}

export default function DiagramView({ viewId, project, base, label, nodeLinks }: Props) {
  const wrapper = useRef<HTMLDivElement>(null);
  const [readyToLoad, setReadyToLoad] = useState(false);
  const [attempt, setAttempt] = useState(0);
  const [View, setView] = useState<LikeC4ViewComponent | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const element = wrapper.current;
    if (!element) return;
    if (typeof IntersectionObserver === 'undefined') {
      setReadyToLoad(true);
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        if (entries.some(({ isIntersecting }) => isIntersecting)) {
          setReadyToLoad(true);
          observer.disconnect();
        }
      },
      { rootMargin: '600px 0px' },
    );
    observer.observe(element);
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    if (!readyToLoad) return;
    let cancelled = false;
    setView(null);
    setError(null);

    const loader = ENGINE_BY_PROJECT[project];
    if (!loader) {
      setError(`Unknown diagram project: ${project}`);
      return;
    }

    loader()
      .then(({ LikeC4View }) => {
        if (!cancelled) setView(() => LikeC4View);
      })
      .catch((reason: unknown) => {
        if (!cancelled) {
          const detail = reason instanceof Error ? reason.message : String(reason);
          setError(`Could not load ${label}. ${detail}`);
        }
      });
    return () => {
      cancelled = true;
    };
  }, [attempt, label, project, readyToLoad]);

  const retry = useCallback(() => {
    setReadyToLoad(true);
    setAttempt((value) => value + 1);
  }, []);

  useEffect(() => {
    const element = wrapper.current;
    if (!element) return;

    const navigate = (event: MouseEvent) => {
      for (const entry of event.composedPath()) {
        if (!(entry instanceof Element)) continue;
        const nodeId = entry.getAttribute('data-nodeid');
        if (!nodeId) continue;
        const target = nodeLinks[nodeId];
        if (!target) return;
        event.preventDefault();
        event.stopPropagation();
        window.location.assign(withBase(base, target));
        return;
      }
    };
    element.addEventListener('click', navigate, true);
    return () => element.removeEventListener('click', navigate, true);
  }, [base, nodeLinks]);

  return (
    <div
      ref={wrapper}
      role="region"
      aria-label={label}
      style={{ minHeight: '28rem', width: '100%' }}
    >
      {error ? (
        <div role="alert">
          <p>{error}</p>
          <button type="button" onClick={retry}>Retry diagram</button>
        </div>
      ) : View ? (
        <View viewId={viewId} pannable zoomable />
      ) : (
        <p role="status" aria-live="polite">Loading {label}…</p>
      )}
    </div>
  );
}
