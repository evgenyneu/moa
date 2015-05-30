import UIKit

struct RandomImage {
  
  private static var urlPath = "https://dl.dropboxusercontent.com/u/11143285/github_images/moa/thumbnails/"
  
  private static var imageNames = [
    "NothocercusNigricapillusSmit-edit.jpg"
//    "MusSylvaticusSmit.jpg",
//    "MidasGeoffroiiSmit.jpg",
//    "Lonchura_forbesi_-_Joseph_Smit.jpg",
//    "LaniariusSmit.jpg"
  ]
  
  private static var name: String {
    return iiRandom.random(imageNames) ?? "Lonchura_forbesi_-_Joseph_Smit.jpg"
  }
  
  static var url: String {
//    return "http://evgenii.com/image/drawings/thumbnails/72b6.2014-03-22-branch-and-a-leaf-8.jpg"
//    return urlPath + name
    
    return "https://drive.google.com/file/d/0B8UknowN9xmxTWdxMFFLeDJHVzg/view?usp=sharing"
  }
}