
/**

Settings for Moa image downloader.

*/
public struct MoaSettings {
  /// Settings for caching of the images.
  public var cache = MoaSettingsCache() {
    didSet {
      MoaHttpSession.cacheSettingsChanged(oldValue)
    }
  }
  
  /// Timeout for image requests in seconds. This will cause a timeout if a resource is not able to be retrieved within a given timeout. Default timeout: 10 seconds.
  public var requestTimeoutSeconds: Double = 10
  
  /// Maximum number of simultaneous image downloads. Default: 4.
  public var maximumSimultaneousDownloads: Int = 4
}

func ==(lhs: MoaSettings, rhs: MoaSettings) -> Bool {
  return lhs.requestTimeoutSeconds == rhs.requestTimeoutSeconds
    && lhs.maximumSimultaneousDownloads == rhs.maximumSimultaneousDownloads
    && lhs.cache == rhs.cache
}

func !=(lhs: MoaSettings, rhs: MoaSettings) -> Bool {
  return !(lhs == rhs)
}

