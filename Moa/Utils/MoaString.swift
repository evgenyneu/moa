import Foundation

//
// Helpers for working with strings
//

struct MoaString {
  static func contains(text: String, substring: String,
    ignoreCase: Bool = false,
    ignoreDiacritic: Bool = false) -> Bool {
            
    var options = NSStringCompareOptions()
    
    if ignoreCase { options.insert(NSStringCompareOptions.CaseInsensitiveSearch) }
    if ignoreDiacritic { options.insert(NSStringCompareOptions.DiacriticInsensitiveSearch) }
    
    return text.rangeOfString(substring, options: options) != nil
  }
}