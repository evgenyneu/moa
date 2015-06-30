import XCTest

extension XCTestCase {
  func moa_eventually(
    @autoclosure(escaping) condition: () -> Bool,
    timeout: NSTimeInterval = 1,
    callback: ()->()) {
    
    let moaExpectation = expectationWithDescription("moa expectation")
    
    let timer = MoaTimer.runAfter(0.01, repeats: true) { timer in
      if condition() { moaExpectation.fulfill() }
    }
    
    waitForExpectationsWithTimeout(timeout) { error in }
      
    timer.cancel()
    
    callback()
  }
  
  func moa_eventually(timeout: NSTimeInterval = 0.1, callback: ()->()) {
    let moaExpectation = expectationWithDescription("moa expectation")
    
    let _ = MoaTimer.runAfter(timeout) { timer in
      moaExpectation.fulfill()
    }
    
    waitForExpectationsWithTimeout(timeout * 2) { error in }
    
    callback()
  }
}

