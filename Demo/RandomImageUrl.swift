import UIKit

/**

Returns URL to random image. Previously returned image names are kept in memory to avoid
returning same images in a row.

*/
class RandomImageUrl {
  var seenImageNames = [String]()
  
  /// Size of the 'memory' array where previousl image names are kept to avoid repetition
  private static let maxSeenImageCount = 8
  
  private static var hostAndPath = "http://evgenii.com/files/2015/06/moa_demo/"
  
  static var imageNames = [
    "AcanthochoerusGroteiSmit.jpg",
    "AnthusButleriSmit.jpg",
    "BradypterusSylvaticusSmit.jpg",
    "CervicapraThomasinaeSmit.jpg",
    "ChirogaleusMiliiSmit.jpg",
    "Chlorophonia_flavirostris.jpg",
    "DendrohyraxEminiSmit.jpg",
    "Hypothymis_coelestis_coelestis_Smit.jpg",
    "LeopardSmit.jpg",
    "MusSylvaticusSmit.jpg",
    "Psammobates_tentorius.jpg",
    "StrepsicerosImberbisSmit.jpg",
    "HerpestesFerrugineusSmit.jpg",
    "HolacanthusIgnatiusSmit.jpg",
    "LamprophisFiskiiSmit.jpg",
    "Metallura_eupogon_Smit.jpg",
    "PhalangistaLemuroidesSmit.jpg",
    "PytiliaAfraSmit.jpg",
    "Tupaia_tana_J_Smit.jpg"
  ]
  
  init() { }

  
  var randomUnseenImageName: String {
    let unseen = unseenImageNames()
    return iiRandom.random(unseen) ?? "AcanthochoerusGroteiSmit.jpg"
  }
  
  var url: String {
    let imageName = randomUnseenImageName
    rememberImageName(imageName)

    return RandomImageUrl.hostAndPath + imageName
  }
  
  func rememberImageName(url: String) {
    if contains(seenImageNames, url) { return }
    seenImageNames.append(url)
    
    if seenImageNames.count > RandomImageUrl.maxSeenImageCount {
      let sliceStart = (seenImageNames.count-RandomImageUrl.maxSeenImageCount)
      let slice = seenImageNames[sliceStart..<seenImageNames.count]
      
      seenImageNames = Array(slice)
    }
  }
  
  func unseenImageNames() -> [String] {
    var unseen = allUnseenImageNames
    
    if unseen.isEmpty {
      seenImageNames = []
      unseen = RandomImageUrl.imageNames
    }
    
    return unseen
  }
  
  private var allUnseenImageNames: [String] {
    return RandomImageUrl.imageNames.filter { [weak self] phrase in
      if let currentSelf = self {
        return !contains(currentSelf.seenImageNames, phrase)
      }
      return false
    }
  }
}