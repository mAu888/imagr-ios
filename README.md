# Imagr

This is a demo project showing the benefit of combining signals when fetching data from different sources resolving into the same entities. The application queries both the flickr and the 500px API to fetch photos for a given query string.

Besides that it was a little training for me trying ReactiveCocoa in combination with Swift.

## Getting started

* Install the latest Beta of Xcode 7
* Run `carthage bootstrap --platform iOS` to build the dependencies.
* Get an API key both for [flickr](https://www.flickr.com/services/apps/create/apply) and for [500px](https://500px.com/settings/applications)

The API keys should reside in their own Swift file. Create a file called `Keys.swift` within the `Ancillary Files` group with the following content.

    let FlickrAPIKey = "YOUR_FLICKR_API_KEY"
    let FpxAPIKey = "YOUR_500PX_API_KEY"
