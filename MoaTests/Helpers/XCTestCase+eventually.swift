import XCTest

extension XCTestCase {
  func moa_eventually(
    @autoclosure(escaping) condition: () -> Bool,
    timeout: TimeInterval = 1,
    callback: ()->()) {
    
    let moaExpectation = expectation(withDescription: "moa expectation")
    
    let timer = MoaTimer.runAfter(0.01, repeats: true) { timer in
      if condition() { moaExpectation.fulfill() }
    }
    
    waitForExpectations(timeout) { error in }
      
    timer.cancel()
    
    callback()
  }
  
  func moa_eventually(timeout: TimeInterval = 0.1, callback: ()->()) {
    let moaExpectation = expectation(withDescription: "moa expectation")
    
    let _ = MoaTimer.runAfter(timeout) { timer in
      moaExpectation.fulfill()
    }
    
    waitForExpectations(timeout * 2) { error in }
    
    callback()
  }
}

