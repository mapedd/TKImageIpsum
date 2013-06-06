#TKImageIpsum

***

##About


TKImageIpsum is a small helper class which can download random images with given from [http://lorempixel.com/](http://lorempixel.com/) or other similar service. Fetched images are cached in memory with the `key` and `group` parametes as identifiers.

##How it works
It uses a `NSOperationQueue` that consumes `NSBlockOperation` blocks to check the `NSCache` and if cache is empty to download an image from the given formatURL using `[NSData dataWithContentsOfURL:]`. Caches can be cleaned in low memory situations.

##Usage
To get a random UIImage with size of `CGSize size` simply call:

		[TKImageIpsum getRandomImageWithSize:(CGSize)size withCompletionBlock:^(UIImage *image){}];


and then use the returned UIImage instance from within the block how you want :D
You can also use 

			+ (void)getRandomImageWithSize:(CGSize)size group:(id<NSCopying>)group key:(id<NSCopying>)key withCompletionBlock:(void (^)(UIImage *image))completionBlock;
			
with `group` and `key` parameter if you want to have few UITable/UICollectionViews filled with random images, see demo for a idea how to use it.

##Demo project
✔ Attached

##ARC
✔ yup

##Contact

- [@mapedd](https://twitter.com/mapedd)
- [mapedd@mapedd.com](mapedd@gmail.com/ "Title")

##License
Apache