export function isEnvBrowser(): boolean {
  return !(window as any).invokeNative
}

export async function fetchNui<T = unknown>(
  eventName: string,
  data?: unknown,
): Promise<T> {
  const resourceName =
    (window as any).GetParentResourceName?.() ?? 'pr_bridge'

  const response = await fetch(`https://${resourceName}/${eventName}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=UTF-8' },
    body: JSON.stringify(data ?? {}),
  })

  try {
    return (await response.json()) as T
  } catch {
    return undefined as T
  }
}

type NuiHandler = (data: any) => void

/** Converts escaped Lua/JSON line separators without enabling HTML rendering. */
export function normalizeMultilinePayload<T>(payload: T): T {
  if (typeof payload === 'string') {
    return payload.replace(/\\r\\n/g, '\n').replace(/\\n/g, '\n').replace(/\\r/g, '\n') as T
  }

  if (Array.isArray(payload)) {
    return payload.map((item) => normalizeMultilinePayload(item)) as T
  }

  if (payload && typeof payload === 'object') {
    const normalized: Record<string, unknown> = {}
    for (const [key, value] of Object.entries(payload as Record<string, unknown>)) {
      normalized[key] = normalizeMultilinePayload(value)
    }
    return normalized as T
  }

  return payload
}

const handlers = new Map<string, Set<NuiHandler>>()

export function onNuiMessage(action: string, handler: NuiHandler): () => void {
  if (!handlers.has(action)) {
    handlers.set(action, new Set())
  }
  handlers.get(action)!.add(handler)

  return () => {
    handlers.get(action)?.delete(handler)
  }
}

window.addEventListener('message', (event) => {
  const payload = event.data
  if (!payload || typeof payload.action !== 'string') return

  const set = handlers.get(payload.action)
  if (!set) return

  for (const handler of set) {
    handler(normalizeMultilinePayload(payload.data))
  }
})
