import Foundation

//
// Helpers for working with strings
//

struct MoaString {
  static func contains(_ text: String, substring: String,
    ignoreCase: Bool = false,
    ignoreDiacritic: Bool = false) -> Bool {
            
    var options = NSString.CompareOptions()
    
    if ignoreCase { _ = options.insert(NSString.CompareOptions.caseInsensitive) }
    if ignoreDiacritic { _ = options.insert(NSString.CompareOptions.diacriticInsensitive) }
    
    return text.range(of: substring, options: options) != nil
  }
}
