import Foundation

/**

Specify settings for caching of downloaded images.

*/
public struct MoaSettingsCache {
  /// The memory capacity of the cache, in bytes. Default value is 20 MB.
  public var memoryCapacityBytes: Int = 20 * 1024 * 1024
  
  /// The disk capacity of the cache, in bytes. Default value is 100 MB.
  public var diskCapacityBytes: Int = 100 * 1024 * 1024
  
  /**

  The caching policy for the image downloads. The default value is .useProtocolCachePolicy.
  
  * .useProtocolCachePolicy - Images are cached according to the the response HTTP headers, such as age and expiration date. This is the default cache policy.
  * .reloadIgnoringLocalCacheData - Do not cache images locally. Always downloads the image from the source.
  * .returnCacheDataElseLoad - Loads the image from local cache regardless of age and expiration date. If there is no existing image in the cache, the image is loaded from the source.
  * .returnCacheDataDontLoad - Load the image from local cache only and do not attempt to load from the source.

  */
  public var requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
  
  /**
  
  The name of a subdirectory of the application’s default cache directory
  in which to store the on-disk cache.
  
  */
  public var diskPath = "moaImageDownloader"
}

func ==(lhs: MoaSettingsCache, rhs: MoaSettingsCache) -> Bool {
  return lhs.memoryCapacityBytes == rhs.memoryCapacityBytes
    && lhs.diskCapacityBytes == rhs.diskCapacityBytes
    && lhs.requestCachePolicy == rhs.requestCachePolicy
    && lhs.diskPath == rhs.diskPath
}

func !=(lhs: MoaSettingsCache, rhs: MoaSettingsCache) -> Bool {
  return !(lhs == rhs)
}
