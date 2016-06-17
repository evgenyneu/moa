import UIKit
import XCTest

class MoaSettingsCacheTests: XCTestCase {
  // MARK: - Compare cache settings
  
  func testCompareSettings_equal() {
    var one = MoaSettingsCache()
    one.memoryCapacityBytes = 10
    one.diskCapacityBytes = 10
    one.requestCachePolicy = .useProtocolCachePolicy
    one.diskPath = "test path"
    
    var two = MoaSettingsCache()
    two.memoryCapacityBytes = 10
    two.diskCapacityBytes = 10
    two.requestCachePolicy = .useProtocolCachePolicy
    two.diskPath = "test path"
    
    XCTAssert(one == two)
    XCTAssertFalse(one != two)
  }
  
  func testCompareSettings_differentMemoryCapacity() {
    var one = MoaSettingsCache()
    one.memoryCapacityBytes = 10
    one.diskCapacityBytes = 10
    one.requestCachePolicy = .useProtocolCachePolicy
    one.diskPath = "test path"
    
    var two = MoaSettingsCache()
    two.memoryCapacityBytes = 20
    two.diskCapacityBytes = 10
    two.requestCachePolicy = .useProtocolCachePolicy
    two.diskPath = "test path"
    
    XCTAssertFalse(one == two)
    XCTAssert(one != two)
  }
  
  func testCompareSettings_differentDiskCapacity() {
    var one = MoaSettingsCache()
    one.memoryCapacityBytes = 10
    one.diskCapacityBytes = 10
    one.requestCachePolicy = .useProtocolCachePolicy
    one.diskPath = "test path"
    
    var two = MoaSettingsCache()
    two.memoryCapacityBytes = 10
    two.diskCapacityBytes = 20
    two.requestCachePolicy = .useProtocolCachePolicy
    two.diskPath = "test path"
    
    XCTAssertFalse(one == two)
    XCTAssert(one != two)
  }
  
  func testCompareSettings_differentRequestCahePolicies() {
    var one = MoaSettingsCache()
    one.memoryCapacityBytes = 10
    one.diskCapacityBytes = 10
    one.requestCachePolicy = .useProtocolCachePolicy
    one.diskPath = "test path"
    
    var two = MoaSettingsCache()
    two.memoryCapacityBytes = 10
    two.diskCapacityBytes = 10
    two.requestCachePolicy = .returnCacheDataElseLoad
    two.diskPath = "test path"
    
    XCTAssertFalse(one == two)
    XCTAssert(one != two)
  }
  
  func testCompareSettings_differentDiskPath() {
    var one = MoaSettingsCache()
    one.memoryCapacityBytes = 10
    one.diskCapacityBytes = 10
    one.requestCachePolicy = .useProtocolCachePolicy
    one.diskPath = "test path"
    
    var two = MoaSettingsCache()
    two.memoryCapacityBytes = 10
    two.diskCapacityBytes = 10
    two.requestCachePolicy = .useProtocolCachePolicy
    two.diskPath = "different path"
    
    XCTAssertFalse(one == two)
    XCTAssert(one != two)
  }
}
