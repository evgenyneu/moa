import Foundation
import XCTest

class MoaStringTests: XCTestCase {
  // MARK: - Contains substring
  
  func testContains() {
    XCTAssert(MoaString.contains("Niels Bohr", substring: "Bohr"))
    XCTAssertFalse(MoaString.contains("Niels Bohr", substring: "Einstein"))
  }
  
  func testContains_ignoreCase() {
    XCTAssertFalse(MoaString.contains("Niels Bohr", substring: "bohr"))
    XCTAssert(MoaString.contains("Niels Bohr", substring: "bohr", ignoreCase: true))
  }
  
  func testContains_ignoreDiactric() {
    XCTAssertFalse(MoaString.contains("Für Elise", substring: "Fur", ignoreCase: false))
    
    XCTAssert(MoaString.contains("Für Elise", substring: "Fur", ignoreCase: false,
      ignoreDiacritic: true))
  }
  
  func testEdgeCases() {
    XCTAssertFalse(MoaString.contains("", substring: "electrons"))
    XCTAssertFalse(MoaString.contains("electrons", substring: "")) // This is intentional
    XCTAssertFalse(MoaString.contains("", substring: ""))
    XCTAssert(MoaString.contains("atomic nucleus", substring: " "))
  }
}