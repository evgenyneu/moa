🔨🔨🔨 This is work in progress. 🔨🔨🔨

# Moa, an image downloader for iOS/Swift

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg' alt='Moa hunting' width='400'>

> "Lost, like the Moa is lost" - Maori proverb

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

The closure will be called asynchronously after download finishes and before the image
is assigned to the image view. The closure's return value is an image that will be used in the
image view. No image will be shown if the return value is nil.

### Supplying error closure

```Swift
imageView.moa.onErrorAsync = { error, response in
  // Handle error
}

imageView.moa.url = "http://evgenii.com/ant.jpg"
```

The closure is called asynchronously if image download fails for following reasons:

#### Network error

Error reported by NSURLSession like "not connected to Internet".

*error.domain*:  "NSURLErrorDomain".

*error.code*: one of the [NSURLErrorDomain error codes](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/index.html#//apple_ref/doc/constant_group/URL_Loading_System_Error_Codes).

#### Incorrect URL

*error.domain*:  "MoaHttpErrorDomain"

*error.code*: `MoaHttpErrors.InvalidUrlString`

### HTTP response status code is not 200

*error.domain*:  "MoaHttpImageErrorDomain"

*error.code*: `MoaHttpImageErrors.HttpStatusCodeIsNot200`

### HTTP response content type is not an image.

*error.domain*:  "MoaHttpImageErrorDomain"

*error.code*: `MoaHttpImageErrors.MissingResponseContentTypeHttpHeader`

* Failed to convert response data to UIImage

*error.domain*:  "MoaHttpImageErrorDomain"

*error.code*: `MoaHttpImageErrors.FailedToReadImageData`

Closure arguments:

`error`: NSError instance.
`response`: NSHTTPURLResponse instance.

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


