//
// Creats a timer that executes code after delay.
//
// Usage
// -----
//
//   MoaTimer.runAfter(0.010) { timer in
//     ... code to run
//   }
//
//
//  Cancelling the timer
//  --------------------
//
//  let timer = MoaTimer.runAfter(0.010) { timer in ... }
//  ...
//  timer.cancel()
//
//

import UIKit

final class MoaTimer: NSObject {
  private static var timers = [UInt32: MoaTimer]()
  
  private let id: UInt32
  private let repeats: Bool
  private var timer: NSTimer?
  private var codeToRun: ((MoaTimer)->())?
  
  private init(interval: NSTimeInterval, repeats: Bool = false, codeToRun: (MoaTimer)->()) {
    id = arc4random_uniform(UInt32.max)
    self.repeats = repeats
    
    super.init()
    
    MoaTimer.timers[id] = self

    self.codeToRun = codeToRun
    timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self,
      selector: "timerFired:", userInfo: nil, repeats: repeats)
  }
  
  deinit {
    cancel()
  }
  
  func cancel() {
    timer?.invalidate()
    timer = nil
    MoaTimer.timers.removeValueForKey(id)
  }
  
  func timerFired(timer: NSTimer) {
    self.codeToRun?(self)
    if !repeats { cancel() }
  }
  
  class func runAfter(interval: NSTimeInterval, repeats: Bool = false,
    codeToRun: (MoaTimer)->()) -> MoaTimer {
      
    return MoaTimer(interval: interval, repeats: repeats, codeToRun: codeToRun)
  }
}