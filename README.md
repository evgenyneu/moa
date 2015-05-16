🔨🔨🔨 This is work in progress. 🔨🔨🔨

# Moa, an image downloader for iOS/Swift

<img src='https://raw.githubusercontent.com/evgenyneu/moa/master/Graphics/Hunting_Moa.jpg' alt='Moa hunting' width='400'>

> "Lost, like the Moa is lost" - Maori proverb

## Usage

```Swift
imageView.moa.url = "http://evgenii.com/bacteria.jpg"
```

Setting `moa.url` will instantly trigger the image download.
Download is done using NSURLSession class.
When download is completed the image is automatically assigned to the image view.

## Cancelling download

Ongoing image download for the UIImageView is automatically cancelled when:

1. Image view is deallocated.
2. New image download is started: `imageView.moa.url = ...`.

Call `imageView.moa.cancel()` to manually cancel the download.

## Using placeholder image

Placeholder is shown in the beginning and then replaced by the downloaded image.

```Swift
imageView.image = UIImage(named: "placeholder.jpg")
imageView.moa.url = "http://evgenii.com/octopus.jpg"
```

## Using error image

If you supply an error image it will be shown if downloads fails.

```Swift
imageView.moa.errorImage = UIImage(named: "error.jpg")
imageView.moa.url = "http://evgenii.com/ant.jpg"
```


## Advanced features

### Supplying completion closure

Assign a closure to `willCompleteDownloadAsync` property before setting `imageView.moa.url`.

```Swift
imageView.moa.didFinishDownoadAsync = { image, isSuccessful in
  return image
}

imageView.moa.url = "http://evgenii.com/ant.jpg"
```

The closure will be called asynchronously after download has been complete and before the image
is assigned to the image view. The closure's return value is an image that will be assigned to the
image view. No image will be assigned if the returned value is `nil`.

### Download image without UIImageView

An instance of `Moa` class can also be used without an image view.

```Swift
let moa = Moa()
moa.didFinishDownoadAsync = { image, isSuccessful in
  return image
}
moa.url = "http://evgenii.com/moa.jpg"
```

# Credits

* 'Hunting Moa' image: Extinct Monsters by Rev. H. N. Hutchinson, illustrations by Joseph Smit (1836-1929) and others. 4th ed., 1896. Plate XXIII between pages 232 and 233. File source: [Wikimedia Commons](http://commons.wikimedia.org/wiki/File:Hunting_Moa.jpg).


