
import Foundation

/**

Simulates download of images in unit test. This downloader is used instead of the HTTP downloaded when the moa simulator is started: MoaSimulator.start().

*/
struct MoaSimulatedImageDownloader: MoaImageDownloader {

  init?(url: String) {
    if !MoaSimulator.isSimulated(url) { return nil }
  }
  
  func startDownload(url: String, onSuccess: (MoaImage)->(),
    onError: (NSError, NSHTTPURLResponse?)->()) {
      
  }
  
  func cancel() {
    
  }
}