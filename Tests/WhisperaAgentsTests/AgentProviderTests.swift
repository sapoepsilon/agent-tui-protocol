import XCTest
import WhisperaAgents
import WhisperaHerdr

final class AgentProviderTests: XCTestCase {
    func testImportableProviderAndTerminalFallback() {
        let registry = AgentTUIRegistry([HerdrTUIProvider()])
        XCTAssertEqual(registry.provider("herdr").transcript(from: "> hello\n\n⏺ Hello!").items,
                       [.prompt("hello"), .message("Hello!")])
        XCTAssertEqual(registry.provider("opencode").transcript(from: "unknown TUI").items, [.message("unknown TUI")])
        XCTAssertEqual(registry.provider("herdr").keys(for: .previousTab), ["shift+left"])
    }
    func testQuestionRetainsActualTerminalSelection() {
        let text = "╭────╮\n│ Proceed? │\n│ 1. Yes │\n│ ❯ 2. No │\n╰────╯"
        XCTAssertEqual(HerdrTUIProvider().transcript(from: text).items, [.question(title: ["Proceed?"], options: ["Yes", "No"], selectedOption: 1)])
    }
    func testAnsiAndSensitiveFields() {
        XCTAssertEqual(HerdrTUIProvider().transcript(from: "\u{001B}[32m⏺ hello\u{001B}[0m").items, [.message("hello")])
        let info = HerdrTUIProvider.agent(["pane_id": "w1:p1", "agent_status": "", "cwd": "/a", "foreground_cwd": "/b", "token": "private", "session": "private"])
        XCTAssertEqual(info["cwd"] as? String, "/b")
        XCTAssertEqual(info["status"] as? String, "unknown")
        XCTAssertNil(info["token"])
        XCTAssertNil(info["session"])
    }
}
