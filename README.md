# Agent TUI Protocol

`WhisperaAgents` is a Foundation-only Swift library for apps that display agent terminals.
`WhisperaHerdr` supplies the first adapter. Both support iOS 17 and macOS 14;
no Whispera account, UIKit, AppKit, process launcher or credential is required.

```swift
import WhisperaAgents
import WhisperaHerdr

let providers = AgentTUIRegistry([HerdrTUIProvider()])
let adapter = providers.provider("herdr")
let conversation = adapter.transcript(from: terminalSnapshot)
let keys = adapter.keys(for: .nextTab)
// The host sends keys only after an explicit user action.
```

To add a provider such as OpenCode, implement `AgentTUIProvider` and register it.
The adapter owns terminal interpretation and key mapping. The host owns its
transport, permissions, launch policy and UI. Unregistered providers retain raw
text through `PlainTerminalProvider`; the raw terminal should remain available
for every provider because terminal snapshots are not complete chat histories.

This is the public Swift adapter interface, not a new HERDR socket protocol.
HERDR's existing `agent.read` and `agent.send_keys` APIs remain the transport.
Licensed under MIT; see [LICENSE](LICENSE).

## Install

Add the package to Xcode or Swift Package Manager:

```swift
.package(url: "https://github.com/sapoepsilon/agent-tui-protocol", from: "0.1.0")
```

Use `.product(name: "WhisperaAgents", package: "agent-tui-protocol")` for the interface,
or `.product(name: "WhisperaHerdr", package: "agent-tui-protocol")` for HERDR.
Run `swift test` to verify the parser, key mapping, raw fallback and safe metadata projection.

## Provider contract

A provider is a pure, Sendable value: `id`, `displayName`,
`transcript(from:)`, and `keys(for:)`. Register instances explicitly with
`AgentTUIRegistry`. No executable discovery or automatic keystrokes occur.
An OpenCode adapter can implement the same interface in another package without
modifying the interface or host UI. OpenCode is not implemented in this release.

The included parser understands common transcript markers and terminal question boxes.
Its output is a best-effort view of one snapshot; keep the original terminal available.
Hosts own authentication, connectivity, user confirmation, and dispatching returned keys.
