
import Foundation

/**

Simulates download of images in unit test. This downloader is used instead of the HTTP downloaded when the moa simulator is started: MoaSimulator.start().

*/
final class MoaSimulatedImageDownloader: MoaImageDownloader {
  
  let url: String

  init?(url: String) {
    self.url = url

    if !MoaSimulator.isSimulated(url) { return nil }
        
    MoaSimulator.downloaders.append(self)
  }
  
  func startDownload(url: String, onSuccess: (MoaImage)->(),
    onError: (NSError, NSHTTPURLResponse?)->()) {
      
  }
  
  func cancel() {
    
  }
}