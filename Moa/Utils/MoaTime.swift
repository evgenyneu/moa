import Foundation

struct MoaTime {
  /// Converts date to format used in logs in UTC time zone.
  static func logTime(date: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    let timeZone =  NSTimeZone(name: "UTC")
    dateFormatter.timeZone = timeZone
    let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    
    return dateFormatter.stringFromDate(date)
  }
  
  /// Returns current time in format used in logs in UTC time zone.
  static var nowLogTime: String {
    return logTime(NSDate())
  }
}