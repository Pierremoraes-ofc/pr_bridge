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
    handler(payload.data)
  }
})
