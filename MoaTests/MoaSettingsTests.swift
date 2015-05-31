import UIKit
import XCTest

class MoaSettingsTests: XCTestCase {
  func testChangeSettings_chagingSettingsUpdatesHttpSession() {
    Moa.settings.cache.memoryCapacityBytes = 100
    let sessionBefore = MoaHttpSession.session
    
    Moa.settings.cache.memoryCapacityBytes = 200
    let sessionAfter = MoaHttpSession.session

    XCTAssert(sessionBefore !== sessionAfter)
  }
  
  func testChangeSettings_chagingSettingsWithSameValueDoesNotUpdateHttpSession() {
    Moa.settings.cache.memoryCapacityBytes = 100
    let sessionBefore = MoaHttpSession.session
    
    Moa.settings.cache.memoryCapacityBytes = 100
    let sessionAfter = MoaHttpSession.session
    
    XCTAssert(sessionBefore === sessionAfter)
  }
}