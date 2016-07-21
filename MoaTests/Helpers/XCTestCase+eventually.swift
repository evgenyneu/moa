import XCTest

extension XCTestCase {
  func moa_eventually(
    _ condition: @autoclosure(escaping)() -> Bool,
    timeout: TimeInterval = 1,
    callback: ()->()) {
    
    let moaExpectation = expectation(description: "moa expectation")
    
    let timer = MoaTimer.runAfter(0.01, repeats: true) { timer in
      if condition() { moaExpectation.fulfill() }
    }
    
    waitForExpectations(timeout: timeout) { error in }
      
    timer.cancel()
    
    callback()
  }
  
  func moa_eventually(_ timeout: TimeInterval = 0.1, callback: ()->()) {
    let moaExpectation = expectation(description: "moa expectation")
    
    let _ = MoaTimer.runAfter(timeout) { timer in
      moaExpectation.fulfill()
    }
    
    waitForExpectations(timeout: timeout * 2) { error in }
    
    callback()
  }
}

