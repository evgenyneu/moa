🔨🔨🔨 This is work in progress. 🔨🔨🔨

# Moa, an image downloader for iOS/Swift

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![MIT License](https://img.shields.io/badge/license-MIT-yellow.svg?style=flat)](https://github.com/evgenyneu/moa/blob/master/LICENSE)


<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg' alt='Moa hunting' width='400'>

> "Lost, like the Moa is lost" - Maori proverb

## Setup

There are three ways you can add Moa to your Xcode project.

#### Add source (iOS 7+)

Simply add [MoaDistrib.swift](https://github.com/evgenyneu/moa/blob/master/Distrib/MoaDistrib.swift) file into your Xcode project.

#### Setup with Carthage (iOS 8+)

```
github "evgenyneu/moa" ~> 1.0
```

## Usage

```Swift
imageView.moa.url = "http://evgenii.com/bacteria.jpg"
```

Setting `moa.url` property of `UIImageView` instance starts asynchronous image download using NSURLSession class. When download is completed the image is automatically shows in the image view.

## Canceling download

Ongoing image download for the UIImageView is automatically cancelled when:

1. Image view is deallocated.
2. New image download is started: `imageView.moa.url = ...`.

Call `imageView.moa.cancel()` to manually cancel the download.


## Advanced features



### Supplying completion closure

Assign a closure that will be called when image is received.

```Swift
imageView.moa.onSuccessAsync = { image in
  return image
}

imageView.moa.url = "http://evgenii.com/ant.jpg"
```

The closure will be called *asynchronously* after download finishes and before the image
is assigned to the image view. This is a good place to manipulate the image before it is shown. The closure returns an image that will be shown in the image view. Return nil if you do not want the image to be shown.



### Supplying error closure

```Swift
imageView.moa.onErrorAsync = { error, response in
  // Handle error
}

imageView.moa.url = "http://evgenii.com/ant.jpg"
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
moa.url = "http://evgenii.com/moa.jpg"
```

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


