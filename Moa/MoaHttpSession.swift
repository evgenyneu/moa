import Foundation

struct MoaHttpSession {
  private static var currentSession: NSURLSession?
  
  static var session: NSURLSession? {
    get {
      if currentSession == nil {
        currentSession = createNewSession()
      }
    
      return currentSession
    }
    
    set {
      currentSession = newValue
    }
  }
  
  private static func createNewSession() -> NSURLSession {
    
    println("Creating new session")
  
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    configuration.requestCachePolicy = Moa.settings.cache.requestCachePolicy
    
    let cache = NSURLCache(
      memoryCapacity: Moa.settings.cache.memoryCapacityBytes,
      diskCapacity: Moa.settings.cache.diskCapacityBytes,
      diskPath: Moa.settings.cache.diskPath)
    
    configuration.URLCache = cache
    
    return NSURLSession(configuration: configuration)
  }
  
  static func cacheSettingsChanged(oldSettings: MoaSettingsCache) {
    if oldSettings != Moa.settings.cache {
      session = nil
    }
  }
}