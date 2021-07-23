# not-Here

A simple mobile application to quickly find the crime rates in a particular area in the UK. 

<img src="https://github.com/hoangvu01/not_here/raw/master/docs/android_preview.gif" height=500) />

## 📈 Data

All figures and statistics shown are taken from most recent 6 months. 
Locations shown are only approximations of where the crimes occurred, for more information, see:
- 🚔 [Police API](https://data.police.uk/docs/)

## 🎆  Usage

*Note*: The app is currently NOT YET available on Google Play Store or App Store.

To build and run the app on your own device, follow these steps:
1. 🔑 Get an API key from [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding/overview#before-you-begin).
2. (Optional). Restrict the API key and only enable the `Geocoding API` from your `Google Cloud Console`. 
3. Copy the API key into the `GEOCODING_API_KEY` field in the file `.env`. 
4. Install the app into your device by following the Flutter guides:
    - Android: [Install an APK on device](https://flutter.dev/docs/deployment/android#install-an-apk-on-a-device)
    - iOS: [Setting up XCode](https://help.apple.com/xcode/mac/current/#/dev5a825a1ca)