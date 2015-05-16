🔨🔨🔨 This is work in progress. 🔨🔨🔨

# Moa, an image downloader for iOS/Swift

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg' alt='Moa hunting' width='400'>

> "Lost, like the Moa is lost" - Maori proverb

## Usage

```Swift
imageView.moa.url = "http://evgenii.com/bacteria.jpg"
```

Setting `moa.url` will instantly trigger the image download.
Download is done asynchronously using NSURLSession class.
When download is completed the image is automatically assigned to the image view.

## Cancelling download

Ongoing image download for the UIImageView is automatically cancelled when:

1. Image view is deallocated.
2. New image download is started: `imageView.moa.url = ...`.

Call `imageView.moa.cancel()` to manually cancel the download.

## Using error image

If you supply an error image it will be shown when downloads fails.

```Swift
imageView.moa.errorImage = UIImage(named: "error.jpg")
imageView.moa.url = "http://evgenii.com/ant.jpg"
```


## Advanced features

### Supplying completion closure

Assign a closure before setting `imageView.moa.url` property.

```Swift
imageView.moa.onSuccessAsync = { image in
  return image
}

imageView.moa.url = "http://evgenii.com/ant.jpg"
```

The closure will be called asynchronously after download finishes and before the image
is assigned to the image view. The closure's return value is an image that is used in the
image view. No image will be shown if the return value is nil.

### Supplying error closure

```Swift
imageView.moa.onErrorAsync = {
  return errorImage // or nil
}

imageView.moa.url = "http://evgenii.com/ant.jpg"
```

The closure can return an image that will be assigned to the image view.
The closure is called asynchronously.

### Download image without UIImageView

An instance of `Moa` class can also be used without an image view.

```Swift
let moa = Moa()
moa.didFinishDownoadAsync = { image in
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


