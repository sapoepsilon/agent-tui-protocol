// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Ismatulla Mansurov
import Foundation
import WhisperaAgents

/// HERDR captures the agent's terminal, including readable transcript marks.
/// Parsing is a best-effort projection, not a reconstructed chat history.
public struct HerdrTUIProvider: AgentTUIProvider {
    public let id = "herdr"
    public let displayName = "HERDR"
    public init() {}
    public func transcript(from snapshot: String) -> AgentTranscript {
        AgentTranscript(parsing: snapshot)
    }
    public func keys(for action: AgentTerminalAction) -> [String] {
        PlainTerminalProvider().keys(for: action)
    }

    /// The safe public projection of HERDR's agent_info wire object.
    public static func agent(_ info: [String: Any]) -> [String: Any] {
        func value(_ key: String) -> Any { info[key].flatMap { $0 is NSNull ? nil : $0 } ?? NSNull() }
        let status = (info["agent_status"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? "unknown"
        let cwd = (info["foreground_cwd"] as? String).flatMap { $0.isEmpty ? nil : $0 } ?? (info["cwd"] as? String)
        return ["id": value("pane_id"), "agent": value("agent"), "display_agent": value("display_agent"),
                "name": value("name"), "title": value("title"), "status": status, "cwd": cwd ?? NSNull(),
                "workspace_id": value("workspace_id"), "tab_id": value("tab_id"),
                "focused": (info["focused"] as? Bool) ?? false, "revision": value("revision"),
                "state_labels": info["state_labels"] as? [String: Any] ?? [:]]
    }
}
