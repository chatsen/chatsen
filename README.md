<p align="middle">
<img align="middle" height="96" src="assets/ayyybubu/forsenShrimp/original.png">
<p>
<h1 align="middle">Chatsen</h1>

<p align="middle" float="left">
  <a href="https://chatsen.app/discord"><img src="https://img.shields.io/discord/758710852756570153.svg?label=&logo=discord&logoColor=ffffff&color=5865F2&labelColor=5C5C5C"></a>
  <a href="https://hanadigital.github.io/grev/?user=chatsen&repo=chatsen"><img src="https://img.shields.io/github/downloads/chatsen/chatsen/total?color=23B14D"></a>
  <a><img src="https://img.shields.io/github/license/chatsen/chatsen"></a>
</p>
<p align="middle" float="left">
  <a href="https://apps.apple.com/us/app/chatsen/id1574037007"><img height="75" src="https://raw.githubusercontent.com/chatsen/chatsen/dev/assets/app_store_badge.png"></a>
  <a href="https://play.google.com/store/apps/details?id=com.chatsen.chatsen"><img height="75" src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png"></a>
</p>

Chatsen is a cross-platform application that allows you to chat on Twitch with support for 3rd-party services such as 7TV, BTTV and FFZ.  
It also features a built-in video player and a variety of other features, such as auto-completion, notifications (on supported platforms), whispers, and more to come!

# Media
<p align="middle" float="left">
  <img src="https://raw.githubusercontent.com/chatsen/resources/master/assets/screenshots/1.png" width="200" />
  <img src="https://raw.githubusercontent.com/chatsen/resources/master/assets/screenshots/2.png" width="200" />
  <img src="https://raw.githubusercontent.com/chatsen/resources/master/assets/screenshots/3.png" width="200" />
  <img src="https://raw.githubusercontent.com/chatsen/resources/master/assets/screenshots/4.png" width="200" />
</p>

The Chatsen logo was graciously made by @ayyybubu! You can find him on [Twitter](https://twitter.com/ayyybubu) or [Twitch](https://twitch.tv/ayyybubu)

# Downloads
You can find the latest release for supported platforms (iOS, Android) [here](https://github.com/Chatsen/chatsen/releases).

# Store Releases
- [x] [Play Store](https://play.google.com/store/apps/details?id=com.chatsen.chatsen)
- [x] [App Store](https://apps.apple.com/us/app/chatsen/id1574037007)
- [x] [Apple TestFlight](https://testflight.apple.com/join/I7Fm27MH)

# Supported platforms
- [x] Android 5+ (>=4.1 && <5.0 also supported but without login/video player)
- [x] iOS 12.2+

# Support and donations
Support the project on Patreon and get some cool badges next to your username in return!
https://www.patreon.com/chatsen
  
<!-- # iOS Sideloading Guide
- Install AltStore on your device https://altstore.io/
- Download the .ipa file available on the [release page](https://github.com/Chatsen/chatsen/releases)
- Open the .ipa file with AltStore on your iPhone

Note: the .ipa file is not signed but will be signed automatically with AltStore on your device. -->

# Build instructions
To build Chatsen, all you should need is the Flutter SDK on the **master** branch and it's required dependencies for your platform (Android Studio for Android and Xcode for iOS).  
Running the following commands should allow you to build the application successfully:

```bash
flutter create .
rm -rf test

# Android
sed -i '/<\/manifest>/i \ \ \ \ <uses-sdk tools:overrideLibrary="io.flutter.plugins.webviewflutter"/>' ./android/app/src/main/AndroidManifest.xml
sed -i '/.*package=".*".*/i \ \ \ \ xmlns:tools="http://schemas.android.com/tools"' ./android/app/src/main/AndroidManifest.xml
sed -i '/.*package=".*".*/a \ \ \ <uses-permission android:name="android.permission.INTERNET"/>' ./android/app/src/main/AndroidManifest.xml
sed -i '/.*release {.*/a \ \ \ \ \ \ \ \ \ \ \ \ shrinkResources false\n\ \ \ \ \ \ \ \ \ \ \ \ minifyEnabled false' ./android/app/build.gradle
flutter pub run flutter_launcher_icons:main
flutter build apk

# iOS
flutter pub run flutter_launcher_icons:main
flutter build ios --no-codesign
```

You may also check the Github Actions file [here](https://github.com/chatsen/chatsen/blob/master/.github/workflows/main.yml) for more details.

# Licensing
Chatsen is distributed under the AGPLv3 licence. A copy may be found in the LICENCE file in that repository. All the dependencies remain under their original licenses.

# Usage
This project and it's releases are provided as-is, no support is provided. Use at your own discretion.

# Privacy Policy
Chatsen does not collect any personal or identifying information whatsoever. There are no servers, services or backend running related to the project either.  
Since Chatsen interfaces with Twitch however, you are subject to their Privacy Policy available at https://www.twitch.tv/p/en/legal/privacy-notice/

# Contributions
Chatsen currently does *not* take any pull requests or contributions. When this may change in the future, this notice will be updated and PR guidelines will be defined.

# Contact
- Discord: https://chatsen.app/discord
