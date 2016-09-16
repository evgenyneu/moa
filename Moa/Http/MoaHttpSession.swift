import Foundation

/// Contains functions for managing URLSession.
public struct MoaHttpSession {
  private static var currentSession: URLSession?
  
  static var session: URLSession? {
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
  
  private static func createNewSession() -> URLSession {
    let configuration = URLSessionConfiguration.default
    
    configuration.timeoutIntervalForRequest = Moa.settings.requestTimeoutSeconds
    configuration.timeoutIntervalForResource = Moa.settings.requestTimeoutSeconds
    configuration.httpMaximumConnectionsPerHost = Moa.settings.maximumSimultaneousDownloads
    configuration.requestCachePolicy = Moa.settings.cache.requestCachePolicy
    
    #if os(iOS) || os(tvOS)
      // Cache path is a directory name in iOS
      let cachePath = Moa.settings.cache.diskPath
    #elseif os(OSX)
      // Cache path is a disk path in OSX
      let cachePath = osxCachePath(Moa.settings.cache.diskPath)
    #endif
    
    let cache = URLCache(
      memoryCapacity: Moa.settings.cache.memoryCapacityBytes,
      diskCapacity: Moa.settings.cache.diskCapacityBytes,
      diskPath: cachePath)
    
    configuration.urlCache = cache
    
    return URLSession(configuration: configuration)
  }
  
  // Returns the cache path for OSX.
  private static func osxCachePath(_ dirName: String) -> String {
    var basePath = NSTemporaryDirectory()
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory,
      FileManager.SearchPathDomainMask.userDomainMask, true)
    
    if paths.count > 0 {
      basePath = paths[0]
    }
    
    return (basePath as NSString).appendingPathComponent(dirName)
  }
  
  static func cacheSettingsChanged(_ oldSettings: MoaSettingsCache) {
    if oldSettings != Moa.settings.cache {
      session = nil
    }
  }
  
  static func settingsChanged(_ oldSettings: MoaSettings) {
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
