
import Foundation
import XCTest

class MoaTimeTests: XCTestCase {
  func testLogTimeDate() {
    let calendar = Calendar.current()
    let components = NSDateComponents()
    components.year = 2027
    components.month = 11
    components.day = 21
    components.hour = 13
    components.minute = 51
    components.second = 41
    
    let date = calendar.date(from: components as DateComponents)!
    
    let result = MoaTime.logTime(date)
    
    XCTAssertEqual("2027-11-21 02:51:41.000", result)
  }
}
