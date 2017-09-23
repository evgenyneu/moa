//
// Creats a timer that executes code after delay.
//
// Usage
// -----
//   var timer: MoaTimer.runAfter?
//   ...
//
//   func myFunc() {
//     timer = MoaTimer.runAfter(0.010) { timer in
//        ... code to run
//     }
//   }
//
//
//  Cancelling the timer
//  --------------------
//
//  Timer is cancelled automatically whe it is deallocated. You can also cancel it manually:
//
//  let timer = MoaTimer.runAfter(0.010) { timer in ... }
//  timer.cancel()
//
//

import UIKit

final class MoaTimer: NSObject {
  private let repeats: Bool
  private var timer: Timer?
  private var callback: ((MoaTimer)->())?
  
  private init(interval: TimeInterval, repeats: Bool = false, callback: @escaping (MoaTimer)->()) {
    self.repeats = repeats
    
    super.init()
    
    self.callback = callback
    timer = Timer.scheduledTimer(timeInterval: interval, target: self,
      selector: #selector(timerFired), userInfo: nil, repeats: repeats)
  }
  
  deinit {
    cancel()
  }
  
  func cancel() {
    timer?.invalidate()
    timer = nil
  }
  
  @objc func timerFired(timer: Timer) {
    self.callback?(self)
    if !repeats { cancel() }
  }
  
  @discardableResult
  class func runAfter(_ interval: TimeInterval, repeats: Bool = false,
    callback: @escaping (MoaTimer)->()) -> MoaTimer {
      
    return MoaTimer(interval: interval, repeats: repeats, callback: callback)
  }
}
