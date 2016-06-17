import UIKit
import XCTest

class MoaHttpSessionTests: XCTestCase {
  // MARK: - Instances
  
  func testChangeSettings_cachesSession() {
    let session1 = MoaHttpSession.session
    let session2 = MoaHttpSession.session
    
    XCTAssert(session1 === session2) // same instance
  }
  
  func testChangeSettings_createDifferentInstances() {
    let session1 = MoaHttpSession.session
    MoaHttpSession.session = nil
    let session2 = MoaHttpSession.session
    
    XCTAssert(session1 !== session2) // same instance
  }
  
  // MARK: - Cache
  
  func testUseMoaCacheSettingsForDiskCapacity() {
    Moa.settings.cache.diskCapacityBytes = 123_456
    XCTAssertEqual(123_456, MoaHttpSession.session!.configuration.urlCache!.diskCapacity)
  }
  
  func testUseMoaCacheSettingsForMemoryCapacity() {
    Moa.settings.cache.memoryCapacityBytes = 928_312
    XCTAssertEqual(928_312, MoaHttpSession.session!.configuration.urlCache!.memoryCapacity)
  }
  
  // Clear session
  
  func testClearSession() {
    let session1 = MoaHttpSession.session
    MoaHttpSession.clearSession()
  
    let session2 = MoaHttpSession.session // Should create new session object
    
    XCTAssert(session1 !== session2)
  }
}
