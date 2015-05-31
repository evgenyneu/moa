# Moa, an image downloader for iOS/Swift

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)][carthage]
[![CocoaPods Version](https://img.shields.io/cocoapods/v/moa.svg?style=flat)][cocoadocs]
[![License](https://img.shields.io/cocoapods/l/moa.svg?style=flat)][cocoadocs]
[![Platform](https://img.shields.io/cocoapods/p/moa.svg?style=flat)][cocoadocs]
[cocoadocs]: http://cocoadocs.org/docsets/moa
[carthage]: https://github.com/Carthage/Carthage

Moa is an image download library for iOS written in Swift.
It allows to download and show an image in `UIImageView` by setting its `moa.url` property.

* Images are downloaded asynchronously.
* Uses NSURLSession for networking and caching.
* Allows to change cache size and policy.
* Can be used without UIImageView.
* Provides closure properties for image manipulation and error handling.

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg' alt='Moa hunting' width='400'>

> "Lost, like the Moa is lost" - Maori proverb

## Setup

There are three ways you can add Moa to your Xcode project.

**Add source (iOS 7+)**

Simply add [MoaDistrib.swift](https://github.com/evgenyneu/moa/blob/master/Distrib/MoaDistrib.swift) file into your Xcode project.

**Setup with Carthage (iOS 8+)**

Alternatively, add `github "evgenyneu/moa" ~> 1.0` to your Cartfile and run `carthage update`.

**Setup with CocoaPods (iOS 8+)**

If you are using CocoaPods add this text to your Podfile and run `pod install`.

    use_frameworks!
    pod 'moa', '~> 1.0'

## Usage

1. Add `import moa` to your source code if you used Carthage or CocoaPods setup methods.

1. Set `moa.url` property of `UIImageView` to start asynchronous image download. The image will be automatically displayed when download is finished.

```Swift
imageView.moa.url = "http://site.com/image.jpg"
```

## Canceling download

Ongoing image download for the UIImageView is automatically canceled when:

1. Image view is deallocated.
2. New image download is started: `imageView.moa.url = ...`.

Call `imageView.moa.cancel()` to manually cancel the download.


## How image caching works

Moa uses the built-in NSURLSession caching methods. It creates a dedicated cache storage that is separate from the app's shared url cache.



## Changing cache settings

You can change the cache settings at any moment by setting the `Moa.settings.cache` property.


### Change cache request policy

By default images are cached locally according to their response HTTP headers: Cache-Control, Expires and ETag.
This is useful when you can change the image caching settings on the server side.

If your images are comming the source that you don't control you can still cache the images by setting the `requestCachePolicy` setting to `.ReturnCacheDataElseLoad`.

```Swift
Moa.settings.cache.requestCachePolicy = .ReturnCacheDataElseLoad
```

[Read this](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) excellent article by Ilya Grigorik.


### Change size of memory cache


```Swift
Moa.settings.cache.memoryCapacityBytes = 20 * 1024 * 1024
```

Default size of memory cache is 20 MB.


### Change size of disk cache


```Swift
Moa.settings.cache.diskCapacityBytes = 100 * 1024 * 1024
```

Default size of disk cache is 100 MB.


## Advanced features



### Supplying completion closure

Assign a closure that will be called when image is received.

```Swift
imageView.moa.onSuccessAsync = { image in
  return image
}

imageView.moa.url = "http://site.com/image.jpg"
```

The closure will be called *asynchronously* after download finishes and before the image
is assigned to the image view. This is a good place to manipulate the image before it is shown. The closure returns an image that will be shown in the image view. Return nil if you do not want the image to be shown.



### Supplying error closure

```Swift
imageView.moa.onErrorAsync = { error, response in
  // Handle error
}

imageView.moa.url = "http://site.com/image.jpg"
```

The closure is called *asynchronously* if image download fails. [See Wiki](https://github.com/evgenyneu/moa/wiki/Moa-errors) for the list of possible error codes.

**Closure arguments**:

*error*: NSError instance.

*response*: NSHTTPURLResponse instance.



### Download an image without UIImageView

An instance of `Moa` class can also be used without an image view.

```Swift
let moa = Moa()
moa.onSuccessAsync = { image in
  return image
}
moa.url = "http://site.com/image.jpg"
```


### Demo app

The demo app demonstrates loading of collection view images with Moa.

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

* 'Hunting Moa' image: Extinct Monsters by Rev. H. N. Hutchinson, illustrations by Joseph Smit (1836-1929) and others. 4th ed., 1896. Plate XXIII between pages 232 and 233. File source: [Wikimedia Commons](http://commons.wikimedia.org/wiki/File:Hunting_Moa.jpg).

* Demo app includes drawings by Joseph Smit. Source: [Wikimedia Commons](http://commons.wikimedia.org/w/index.php?title=Category:Joseph_Smit&fileuntil=FuligulaNationiSmit.jpg#mw-category-media).

## License

Moa is released under the [MIT License](LICENSE).


