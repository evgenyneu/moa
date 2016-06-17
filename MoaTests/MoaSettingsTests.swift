import UIKit
import XCTest

class MoaSettingsTests: XCTestCase {
  override func tearDown() {
    super.tearDown()
    
    Moa.settings.requestTimeoutSeconds = 30
    Moa.settings.maximumSimultaneousDownloads = 10
  }
  
  // MARK: - Cache settings
  
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
  
  // MARK: - Timeout settings
  
  func testChangeSettings_chagingTimeoutUpdatesHttpSession() {
    Moa.settings.requestTimeoutSeconds = 100
    let sessionBefore = MoaHttpSession.session
    
    Moa.settings.requestTimeoutSeconds = 200
    let sessionAfter = MoaHttpSession.session
    
    XCTAssert(sessionBefore !== sessionAfter)
    XCTAssertEqual(200, sessionAfter!.configuration.timeoutIntervalForResource)
    XCTAssertEqual(200, sessionAfter!.configuration.timeoutIntervalForRequest)
  }
  
  func testChangeSettings_chagingTimeoutWithSameValueDoesNotUpdateHttpSession() {
    Moa.settings.requestTimeoutSeconds = 100
    let sessionBefore = MoaHttpSession.session
    
    Moa.settings.requestTimeoutSeconds = 100
    let sessionAfter = MoaHttpSession.session
    
    XCTAssert(sessionBefore === sessionAfter)
  }
  
  // MARK: - Maximum downloads settings
  
  func testChangeSettings_chagingMaximumDownloadsUpdatesHttpSession() {
    Moa.settings.maximumSimultaneousDownloads = 100
    let sessionBefore = MoaHttpSession.session
    
    Moa.settings.maximumSimultaneousDownloads = 200
    let sessionAfter = MoaHttpSession.session
    
    XCTAssert(sessionBefore !== sessionAfter)
    XCTAssertEqual(200, sessionAfter!.configuration.httpMaximumConnectionsPerHost)
  }
  
  func testChangeSettings_chagingMaximumDownloadsWithSameValueDoesNotUpdateHttpSession() {
    Moa.settings.maximumSimultaneousDownloads = 100
    let sessionBefore = MoaHttpSession.session
    
    Moa.settings.maximumSimultaneousDownloads = 100
    let sessionAfter = MoaHttpSession.session
    
    XCTAssert(sessionBefore === sessionAfter)
  }
}
