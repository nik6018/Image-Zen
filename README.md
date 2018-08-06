# Image-Zen

A Basic Flickr client which uses the RESTFUL endpoints of the Flickr API. 
The App has 3 Screens :  Interesting Photos, Search and Favourites.

The App has 2 CocoaPods for Network Communication and Image Caching.

#### Alamofire
This Pod provides a nice wrapper around the URL Session class to make request to the Flickr API endpoints.

#### Alamofire Image
For image caching the App uses the Alamofire Image Pod, which caches images upto 120 MB, once the limit is reached the
auto purging mechanism reduces the cache size upto 60MB.
Once the images are downloaded from the Flickr's servers they are added to the cache and it the App tries to fetch the same image
again instead of doing a Network Call the App load's the image from the cache.

## APP Screens

### Interesting Photos

Here the some random interesting photos from the Flickr API are fetched.
<p align="left">
  <img src="img/interesting.png" width="250" title="Interesting Photos">
</p>

### Search

You can search for any image that may be available in the Flickr datasource.
<p align="left">
  <img src="img/search.png" width="250" title="Search">
</p>

### Favourites

Favourites allows you to save any image from the Search or Interesting Photos section to be 
saved on your device.
<p align="left">
  <img src="img/favourite.png" width="250" title="Favourite">
</p>

