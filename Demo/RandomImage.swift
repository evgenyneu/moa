import UIKit

struct RandomImage {
  private static var imageNames = [
    "NothocercusNigricapillusSmit-edit.jpg",
    "MusSylvaticusSmit.jpg",
    "MidasGeoffroiiSmit.jpg",
    "Mastodonsaurus.jpg",
    "Lonchura_forbesi_-_Joseph_Smit.jpg"
  ]
  
  static var name: String {
    return iiRandom.random(imageNames) ?? "Lonchura_forbesi_-_Joseph_Smit.jpg"
  }
  
  static var image: UIImage? {
    return UIImage(named: name)
  }
}