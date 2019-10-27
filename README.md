# Moa, an image downloader written in Swift for iOS, tvOS and macOS

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/moa.svg?style=flat)](http://cocoadocs.org/docsets/moa)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![License](https://img.shields.io/cocoapods/l/moa.svg?style=flat)](http://cocoadocs.org/docsets/moa)
[![Platform](https://img.shields.io/cocoapods/p/moa.svg?style=flat)](http://cocoadocs.org/docsets/moa)

Moa is an image download library written in Swift. It allows to download and show an image in an image view by setting its `moa.url` property.

```Swift
imageView.moa.url = "https://bit.ly/moa_image"
```

* Images are downloaded asynchronously.
* Uses URLSession for networking and caching.
* Allows to configure cache size and policy.
* Can be used without an image view.
* Provides closure properties for image manipulation and error handling.
* Includes unit testing mode for faking network responses.
* Contains logging capabilities for debugging network problems.

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg' alt='Moa hunting' width='400'>

> "Lost, like the Moa is lost" - Maori proverb

*'Hunting Moa' drawing by Joseph Smit (1836-1929). File source: [Wikimedia Commons](http://commons.wikimedia.org/wiki/File:Hunting_Moa.jpg).*



## Setup

There are multiple ways you can add Moa to your Xcode project.

#### Add source (iOS 7+)

Simply add [MoaDistrib.swift](https://github.com/evgenyneu/moa/blob/master/Distrib/MoaDistrib.swift) file into your Xcode project.

#### Setup with Carthage (iOS 8+)

Alternatively, add `github "evgenyneu/moa" ~> 12.0` to your Cartfile and run `carthage update`.

#### Setup with CocoaPods (iOS 8+)

If you are using CocoaPods add this text to your Podfile and run `pod install`.

```
use_frameworks!
target 'Your target name'
pod 'moa', '~> 12.0'
```

#### Setup with Swift Package Manager

* In Xcode 11+ select *File > Packages > Add Package Dependency...*.
* Enter this project's URL: https://github.com/evgenyneu/moa.git


### Legacy Swift versions

Setup a [previous version](https://github.com/evgenyneu/moa/wiki/Legacy-Swift-versions) of the library if you use an older version of Swift.


## Usage

1. Add `import moa` to your source code (unless you used the file setup method).

1. Drag an Image View to your view in the storyboard. Create an outlet property for this image view in your view controller. Alternatively, instead of using the storyboard you can create a `UIImageView` object in code.

1. Set `moa.url` property of the image view to start asynchronous image download. The image will be automatically displayed when download is finished.

```Swift
imageView.moa.url = "https://bit.ly/moa_image"
```

## Loading images from insecure HTTP hosts

If your image URLs are not *https* you will need to [add an exception](http://evgenii.com/blog/loading-data-from-non-secure-hosts-in-ios9-with-nsurlsession/) to the **Info.plist** file. This will allow the App Transport Security to load the images from insecure HTTP hosts.

## Canceling download

Ongoing image download for the image view is automatically canceled when:

1. Image view is deallocated.
2. New image download is started: `imageView.moa.url = ...`.

Call `imageView.moa.cancel()` to manually cancel the download.


## Supply an error image

You can supply an error image that will be used if an error occurs during image download.

```Swift
imageView.moa.errorImage = UIImage(named: "ImageNotFound.jpg")
imageView.moa.url = "https://bit.ly/moa_image"
```

Alternatively, one can supply a global error image that will be used for all failed image downloads.

```Swift
Moa.errorImage = UIImage(named: "ImageNotFound.jpg")
```

## Show a placeholder image

Here is how to show a placeholder image in the image view. The placeholder will be replaced by the image from the network when it arrives.

```Swift
imageView.image = placeholderImage
imageView.moa.url = "https://bit.ly/moa_image"
```

## Advanced features


### Supplying completion closure

Assign a closure that will be called when image is received.

```Swift
imageView.moa.onSuccess = { image in
  return image
}

imageView.moa.url = "https://bit.ly/moa_image"
```

* The closure will be called after download finishes and before the image is assigned to the image view.
* This is a good place to manipulate the image before it is shown.
* The closure returns an image that will be shown in the image view. Return nil if you do not want the image to be shown.
* The closure as called in the *main queue*. Use `onSuccessAsync` property instead if you need to do time consuming operations.
* When `errorImage` is supplied and an error occurs the success closures are called.


### Supplying error closure

```Swift
imageView.moa.onError = { error, response in
  // Handle error
}

imageView.moa.url = "https://bit.ly/moa_image"
```

* The closure is called in the *main queue* if image download fails. Use `onErrorAsync` property instead if you need to do time consuming operations.
* See the "logging" section if you need to find out the type of the error.

### Download an image without an image view

An instance of `Moa` class can also be used without an image view. A strong reference to `Moa` instance needs to be kept.

```Swift
let moa = Moa()
moa.onSuccess = { image in
  // image is loaded
  return image
}
moa.url = "https://bit.ly/moa_image"
```

### Clearing HTTP session

The following method calls `finishTasksAndInvalidate` on the current URLSession object. A new session object will be created for future image downloads.

```Swift
MoaHttpSession.clearSession()
```

You may never need to call this method in your app. I needed to call it periodically to workaround a strange [URLSession bug](http://stackoverflow.com/questions/32493339/sending-400-http-requests-result-in-the-request-timed-out-errors-with-nsurlse) which you may not encounter.

## Image caching

Use the `Moa.settings.cache` to change caching settings. For more information please refer to the [moa image caching manual](https://github.com/evgenyneu/moa/wiki/Moa-image-caching).

```Swift
// By default images are cached according to their response HTTP headers.
Moa.settings.cache.requestCachePolicy = .useProtocolCachePolicy

// Always cache images locally regardless of their response HTTP headers
Moa.settings.cache.requestCachePolicy = .returnCacheDataElseLoad

// Change the name of the cache directory. Useful for sharing cache with the rest of the app.
Moa.settings.cache.diskPath = "MyAppSharedCache"
```

## Settings

Use `Moa.settings` property to change moa image download settings.

```Swift

// Set the maximum number of simultaneous image downloads. Default: 4.
Moa.settings.maximumSimultaneousDownloads = 5

// Change timeout for image requests. Default: 10.
Moa.settings.requestTimeoutSeconds = 20
```

## Logging

You can use the moa logger to see how/when the images are loaded or debug a network problem. One can use a pre-made `MoaConsoleLogger` function to see the log messages in the Xcode console or write a custom logger. See the [logging manual](https://github.com/evgenyneu/moa/wiki/Logging-with-Moa) for more information.

```Swift
// Log to console
Moa.logger = MoaConsoleLogger

// Load an image
imageView.moa.url = "https://bit.ly/moa_image"

// Attempt to load a missing image
imageView.moa.url = "https://bit.ly/moa_image_missing.jpg"
```

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/screenshots/logging_to_console_moa_swift_2.png' alt='Logging to console with moa' width='541'>




## Unit testing

Sometimes it is useful to prevent code from making real HTTP requests. Moa includes `MoaSimulator` class for testing image downloads and faking network responses. See [unit test manual](https://github.com/evgenyneu/moa/wiki/Unit-testing-with-Moa) for more information.

```Swift
// Autorespond with the given image to all image requests
MoaSimulator.autorespondWithImage("www.site.com", image: UIImage(named: "35px.jpg")!)
```

## Demo app

The demo iOS app shows how to load images in a collection view with Moa.

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/demo_app_screenshot.png'
alt='Moa image downloader demo iOS app' width='250'>



## Alternative solutions

Here is the list of other image download libraries for Swift.

* [cbot/Vincent](https://github.com/cbot/Vincent)
* [daltoniam/Skeets](https://github.com/daltoniam/Skeets)
* [Haneke/HanekeSwift](https://github.com/Haneke/HanekeSwift)
* [hirohisa/ImageLoaderSwift](https://github.com/hirohisa/ImageLoaderSwift)
* [natelyman/SwiftImageLoader](https://github.com/natelyman/SwiftImageLoader)
* [onevcat/Kingfisher](https://github.com/onevcat/Kingfisher)
* [zalando/MapleBacon](https://github.com/zalando/MapleBacon)

## Credits

* Demo app includes other drawings by Joseph Smit. Source: [Wikimedia Commons](http://commons.wikimedia.org/w/index.php?title=Category:Joseph_Smit&fileuntil=FuligulaNationiSmit.jpg#mw-category-media).

* macOS support is added by [phimage](https://github.com/phimage).


## License

Moa is released under the [MIT License](LICENSE).

## Feedback is welcome

If you notice any issue, got stuck or just want to chat feel free to create an issue. I will be happy to help you.

## •ᴥ•

This project is dedicated to [the moa](https://en.wikipedia.org/wiki/Moa), species of flightless birds that lived in New Zealand and became extinct in 15th century.
