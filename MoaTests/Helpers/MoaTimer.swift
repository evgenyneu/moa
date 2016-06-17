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
  
  private init(interval: TimeInterval, repeats: Bool = false, callback: (MoaTimer)->()) {
    self.repeats = repeats
    
    super.init()
    
    self.callback = callback
    timer = Timer.scheduledTimerWithTimeInterval(interval, target: self,
      selector: #selector(MoaTimer.timerFired(_:)), userInfo: nil, repeats: repeats)
  }
  
  deinit {
    cancel()
  }
  
  func cancel() {
    timer?.invalidate()
    timer = nil
  }
  
  func timerFired(timer: Timer) {
    self.callback?(self)
    if !repeats { cancel() }
  }
  
  class func runAfter(interval: TimeInterval, repeats: Bool = false,
    callback: (MoaTimer)->()) -> MoaTimer {
      
    return MoaTimer(interval: interval, repeats: repeats, callback: callback)
  }
}
