/**

Specify settings for caching of downloaded images.

*/
public struct MoaSettingsCache {
  /// The memory capacity of the cache, in bytes. Default: 20 MB.
  public var memoryCapacityBytes: Int = 20 * 1024 * 1024
  
  /// The disk capacity of the cache, in bytes. Default: 100 MB.
  public var diskCapacityBytes: Int = 100 * 1024 * 1024
  
  /**
  
  The name of a subdirectory of the application’s default cache directory
  in which to store the on-disk cache.
  
  */
  var diskPath = "moaImageDownloader"
}

func ==(lhs: MoaSettingsCache, rhs: MoaSettingsCache) -> Bool {
  return lhs.memoryCapacityBytes == rhs.memoryCapacityBytes
    && lhs.diskCapacityBytes == rhs.diskCapacityBytes
    && lhs.diskPath == rhs.diskPath
}

func !=(lhs: MoaSettingsCache, rhs: MoaSettingsCache) -> Bool {
  return !(lhs == rhs)
}
