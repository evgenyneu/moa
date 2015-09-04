import Foundation

struct MoaTime {
  /// Converts date to ISO 8601 format in UTC time zone.
  static func iso8601Utc(date: NSDate) -> String {
    let dateFormatter = NSDateFormatter()
    let timeZone =  NSTimeZone(name: "UTC")
    dateFormatter.timeZone = timeZone
    let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    return dateFormatter.stringFromDate(date)
  }
  
  /// Returns current time in ISO 8601 format in UTC time zone.
  static var nowIso8601Utc: String {
    return iso8601Utc(NSDate())
  }
}