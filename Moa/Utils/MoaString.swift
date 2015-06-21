//
// Helpers for working with strings
//

import UIKit

struct MoaString {
  static func contains(text: String, substring: String,
    ignoreCase: Bool = false,
    ignoreDiacritic: Bool = false) -> Bool {
            
    var options = NSStringCompareOptions.allZeros
    
    if ignoreCase { options |= NSStringCompareOptions.CaseInsensitiveSearch }
    if ignoreDiacritic { options |= NSStringCompareOptions.DiacriticInsensitiveSearch }
    
    return text.rangeOfString(substring, options: options) != nil
  }
}