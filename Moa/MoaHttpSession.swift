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
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    configuration.requestCachePolicy = Moa.settings.cache.requestCachePolicy
    
    #if os(iOS)
      // Cache path is a directory name in iOS
      let cachePath = Moa.settings.cache.diskPath
    #elseif os(OSX)
      // Cache path is a disk path in OSX
      let cachePath = osxCachePath(Moa.settings.cache.diskPath)
    #endif
    
    let cache = NSURLCache(
      memoryCapacity: Moa.settings.cache.memoryCapacityBytes,
      diskCapacity: Moa.settings.cache.diskCapacityBytes,
      diskPath: cachePath)
    
    configuration.URLCache = cache
    
    return NSURLSession(configuration: configuration)
  }
  
  // Returns the cache path for OSX.
  private static func osxCachePath(dirName: String) -> String {
    var basePath = NSTemporaryDirectory()
    if let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory,
      NSSearchPathDomainMask.UserDomainMask, true) as? [String]
      where paths.count > 0 {
        
      basePath = paths[0]
    }
    
    return basePath.stringByAppendingPathComponent(dirName)
  }
  
  static func cacheSettingsChanged(oldSettings: MoaSettingsCache) {
    if oldSettings != Moa.settings.cache {
      session = nil
    }
  }
}