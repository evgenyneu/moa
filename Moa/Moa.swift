#if os(iOS) || os(tvOS)
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

Setting `moa.url` property of an image view instance starts asynchronous image download using URLSession class.
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
  public static var settings = MoaSettings() {
    didSet {
      MoaHttpSession.settingsChanged(oldValue)
    }
  }
  
  /// Supply a callback closure for getting request, response and error logs
  public static var logger: MoaLoggerCallback?

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
  
  The closure will be called after download finishes and before the image
  is assigned to the image view. The closure is called in the main queue.
  
  The closure returns an image that will be shown in the image view.
  Return nil if you do not want the image to be shown.
  
      moa.onSuccess = { image in
        // Image is received
        return image
      }
  
  */
  public var onSuccess: ((MoaImage)->(MoaImage?))?

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
  
  The closure is called in the main queue if image download fails.
  [See Wiki](https://github.com/evgenyneu/moa/wiki/Moa-errors) for the list of possible error codes.
  
      onError = { error, httpUrlResponse in
        // Report error
      }
  
  */
  public var onError: ((Error?, HTTPURLResponse?)->())?
  
  /**

  The closure is called *asynchronously* if image download fails.
  [See Wiki](https://github.com/evgenyneu/moa/wiki/Moa-errors) for the list of possible error codes.

      onErrorAsync = { error, httpUrlResponse in
        // Report error
      }

  */
  public var onErrorAsync: ((Error?, HTTPURLResponse?)->())?
  
  
  /**
  
  Image that will be used if error occurs. The image will be assigned to the image view. Callbacks `onSuccess` and `onSuccessAsync` will  be called with the supplied image. Callbacks `onError` and `onErrorAsync` will also be called.
  
  */
  public var errorImage: MoaImage?
  
  /**
  
  A global error image that will be used if error occurs in any of the image downloads. The image will be assigned to the image view. Callbacks `onSuccess` and `onSuccessAsync` will  be called with the supplied image. Callbacks `onError` and `onErrorAsync` will also be called.
  
  */
  public static var errorImage: MoaImage?

  private func startDownload(_ url: String) {
    cancel()
    
    let simulatedDownloader = MoaSimulator.createDownloader(url)
    imageDownloader = simulatedDownloader ?? MoaHttpImageDownloader(logger: Moa.logger)
    let simulated = simulatedDownloader != nil
    
    imageDownloader?.startDownload(url,
      onSuccess: { [weak self] image in
        self?.handleSuccessAsync(image, isSimulated: simulated)
      },
      onError: { [weak self] error, response in
        self?.handleErrorAsync(error, response: response, isSimulated: simulated)
      }
    )
  }

  /**

  Called asynchronously by image downloader when image is received.
  
  - parameter image: Image received by the downloader.
  - parameter isSimulated: True if the image was supplied by moa simulator rather than real network.

  */
  private func handleSuccessAsync(_ image: MoaImage, isSimulated: Bool) {
    var imageForView: MoaImage? = image

    if let onSuccessAsync = onSuccessAsync {
      imageForView = onSuccessAsync(image)
    }

    if isSimulated {
      // Assign image in the same queue for simulated download to make unit testing simpler with synchronous code
      handleSuccessMainQueue(imageForView)
    } else {
      DispatchQueue.main.async { [weak self] in
        self?.handleSuccessMainQueue(imageForView)
      }
    }
  }
  
  /**
  
  Called by image downloader in the main queue when image is received.
  
  - parameter image: Image received by the downloader.
  
  */
  private func handleSuccessMainQueue(_ image: MoaImage?) {
    var imageForView: MoaImage? = image
    
    if let onSuccess = onSuccess, let image = image {
      imageForView = onSuccess(image)
    }
    
    imageView?.image = imageForView
  }
  
  /**
  
  Called asynchronously by image downloader if imaged download fails.
  
  - parameter error: Error object.
  - parameter response: HTTP response object, can be useful for getting HTTP status code.
  - parameter isSimulated: True if the image was supplied by moa simulator rather than real network.
  
  */
  private func handleErrorAsync(_ error: Error?, response: HTTPURLResponse?, isSimulated: Bool) {
    if let errorImage = globalOrInstanceErrorImage {
      handleSuccessAsync(errorImage, isSimulated: isSimulated)
    }
    
    onErrorAsync?(error, response)
    
    if let onError = onError {
      DispatchQueue.main.async {
        onError(error, response)
      }
    }
  }
  
  private var globalOrInstanceErrorImage: MoaImage? {
    get {
      return errorImage ?? Moa.errorImage
    }
  }
}
