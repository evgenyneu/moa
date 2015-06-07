#if os(iOS)
  import UIKit
  public typealias MoaImage = UIImage
  public typealias MoaImageView = UIImageView
#elseif os(OSX)
  import AppKit
  public typealias MoaImage = NSImage
  public typealias MoaImageView = NSImageView
#endif

/**
Downloads an image by url.

Setting `moa.url` property of an image view instance starts asynchronous image download using NSURLSession class.
When download is completed the image is automatically shown in the image view.

    // iOS
    let imageView = UIImageView()
    imageView.moa.url = "http://site.com/image.jpg"

    // OS X
    let imageView = NSImageView()
    imageView.moa.url = "http://site.com/image.jpg"


The class can be instantiated and used without an image view:

    let moa = Moa()
    moa.onSuccessAsync = { image in
      return image
    }
    moa.url = "http://site.com/image.jpg"

*/
public final class Moa {
  private var imageDownloader: MoaImageDownloader?
  private weak var imageView: MoaImageView?

  /// Image download settings.
  public static var settings = MoaSettings()

  /**

  Instantiate Moa when used without an image view.

      let moa = Moa()
      moa.onSuccessAsync = { image in }
      moa.url = "http://site.com/image.jpg"

  */
  public init() { }

  init(imageView: MoaImageView) {
    self.imageView = imageView
  }

  /**

  Assign an image URL to start the download.
  When download is completed the image is automatically shown in the image view.

      imageView.moa.url = "http://mysite.com/image.jpg"

  Supply `onSuccessAsync` closure to receive an image when used without an image view:

      moa.onSuccessAsync = { image in
        return image
      }

  */
  public var url: String? {
    didSet {
      cancel()

      if let url = url {
        startDownload(url)
      }
    }
  }

  /**

  Cancels image download.

  Ongoing image download for the image view is *automatically* cancelled when:

  1. Image view is deallocated.
  2. New image download is started: `imageView.moa.url = ...`.

  Call this method to manually cancel the download.

      imageView.moa.cancel()

  */
  public func cancel() {
    imageDownloader?.cancel()
    imageDownloader = nil
  }

  /**

  The closure will be called *asynchronously* after download finishes and before the image
  is assigned to the image view.

  This is a good place to manipulate the image before it is shown.

  The closure returns an image that will be shown in the image view.
  Return nil if you do not want the image to be shown.

      moa.onSuccessAsync = { image in
        // Manipulate the image
        return image
      }

  */
  public var onSuccessAsync: ((MoaImage)->(MoaImage?))?


  /**

  The closure is called *asynchronously* if image download fails.
  [See Wiki](https://github.com/evgenyneu/moa/wiki/Moa-errors) for the list of possible error codes.

      onErrorAsync = { error, httpUrlResponse in
        // Report error
      }

  */
  public var onErrorAsync: ((NSError, NSHTTPURLResponse?)->())?

  private func startDownload(url: String) {
    cancel()
    imageDownloader = MoaImageDownloader()

    imageDownloader?.startDownload(url,
      onSuccess: { [weak self] image in
        self?.onHandleSuccess(image)
      },
      onError: { [weak self] error, response in
        self?.onErrorAsync?(error, response)
      }
    )
  }

  private func onHandleSuccess(image: MoaImage) {
    var imageForView: MoaImage? = image

    if let onSuccessAsync = onSuccessAsync {
      imageForView = onSuccessAsync(image)
    }

    if let imageView = imageView {
      dispatch_async(dispatch_get_main_queue()) {
        imageView.image = imageForView
      }
    }
  }
}