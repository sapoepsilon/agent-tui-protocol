import XCTest
@testable import WhisperaAgents
final class AgentProviderTests: XCTestCase {
 func testRegistryFallbackAndKeyMapping() {
  let provider = AgentTUIRegistry([]).provider("future")
  XCTAssertEqual(provider.transcript(from: "raw terminal").items, [.message("raw terminal")])
  XCTAssertEqual(provider.keys(for: .confirm), ["enter"])
 }
 func testCommonTranscriptAndQuestionSelection() {
  XCTAssertEqual(AgentTranscript(parsing: "> hello\n\n⏺ Hello!").items, [.prompt("hello"), .message("Hello!")])
  let text = "╭────╮\n│ Proceed? │\n│ 1. Yes │\n│ ❯ 2. No │\n╰────╯"
  XCTAssertEqual(AgentTranscript(parsing: text).items, [.question(title: ["Proceed?"], options: ["Yes", "No"], selectedOption: 1)])
 }
}
