
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
}

