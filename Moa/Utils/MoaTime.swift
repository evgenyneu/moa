import Foundation

struct MoaTime {
  /// Converts date to format used in logs in UTC time zone.
  static func logTime(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    let timeZone = TimeZone(identifier: "UTC")
    dateFormatter.timeZone = timeZone
    let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    
    return dateFormatter.string(from: date)
  }
  
  /// Returns current time in format used in logs in UTC time zone.
  static var nowLogTime: String {
    return logTime(Date())
  }
}
