import Foundation

/// Contains functions for managing NSURLSession.
public struct MoaHttpSession {
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
    
    configuration.timeoutIntervalForRequest = Moa.settings.requestTimeoutSeconds
    configuration.timeoutIntervalForResource = Moa.settings.requestTimeoutSeconds
    configuration.HTTPMaximumConnectionsPerHost = Moa.settings.maximumSimultaneousDownloads
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
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory,
      NSSearchPathDomainMask.UserDomainMask, true)
    
    if paths.count > 0 {
      basePath = paths[0]
    }
    
    return (basePath as NSString).stringByAppendingPathComponent(dirName)
  }
  
  static func cacheSettingsChanged(oldSettings: MoaSettingsCache) {
    if oldSettings != Moa.settings.cache {
      session = nil
    }
  }
  
  static func settingsChanged(oldSettings: MoaSettings) {
    if oldSettings != Moa.settings  {
      session = nil
    }
  }
  
  /// Calls `finishTasksAndInvalidate` on the current session. A new session will be created for future downloads.
  public static func clearSession() {
    currentSession?.finishTasksAndInvalidate()
    currentSession = nil
  }
}