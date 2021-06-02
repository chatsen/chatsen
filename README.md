[<img height="64" src="assets/forseniPhone.png">](assets/forseniPhone.png)
Chatsen
============

Chatsen is a cross-platform application that allows you to chat on Twitch with support for 3rd-party services such as 7TV, BTTV and FFZ.  
It also features a built-in video player (on supported platforms) and a variety of other features, such as auto-completion, notifications, whispers, and more to come!

# Downloads

You can find the latest release for supported platforms (iOS, Android) [here](https://github.com/Chatsen/chatsen/releases).

# Media

**_TODO: Add screenshots_**

# Store Releases

- [x] [Play Store](https://play.google.com/store/apps/details?id=com.chatsen.chatsen) (currently a very old version, do **NOT** use)
- [ ] F-Droid Store
- [ ] App Store (alternative installation method available down the readme, even for non-jailbroken users, in the iOS Installation Guide section)

[<img height="75" src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png">](https://play.google.com/store/apps/details?id=com.chatsen.chatsen)

# Supported platforms

- [x] Android 5+ (>=4.1 && <5.0 also supported but without login/video player)
- [x] iOS 12.2+
- [ ] Browser extension
- [ ] Windows
- [ ] macOS
- [ ] Linux

# Support and donations

Donations are currently not open but would be appreciated in the future!
I currently do not own an iPhone and community members have had to test the application for me which makes eliminating bugs on the platform rather difficult, so the current primary goals would be to be able to afford Apple devices and pay for their high developer fees in order to deploy the application on the App Store.

# Features

**TODO: Complete**

# iOS Installation Guide

As mentioned in the Support and donations section, I unfortunately do not own an Apple Developer license nor the required hardware to develop the application.
However, there is still a way for you to install the iOS application, even on non-jailbroken devices!

- Install AltStore on your device https://altstore.io/
- Download the .ipa file available on the [release page](https://github.com/Chatsen/chatsen/releases)
- Open the .ipa file with AltStore on your iPhone

Note: the .ipa file is not signed but will be signed automatically with AltStore on your device.

# Build instructions

To build Chatsen, all you should need is the Flutter SDK on the **master** branch and it's require dependencies for your platform (Android Studio for Android and XCode for iOS).  
Running the following commands should allow you to build the application successfully:

```bash
flutter create .
rm -rf test

# Android
sed -e 's/android:label=".*"/android:label="Chatsen"/' -e '/.*package=".*".*/a \ \ \ <uses-permission android:name="android.permission.INTERNET"/>' ./android/app/src/main/AndroidManifest.xml > ./android/app/src/main/AndroidManifest2.xml
mv -f ./android/app/src/main/AndroidManifest2.xml ./android/app/src/main/AndroidManifest.xml
sed -e '/.*release {.*/a \ \ \ \ \ \ \ \ \ \ \ \ shrinkResources false\n\ \ \ \ \ \ \ \ \ \ \ \ minifyEnabled false' -e 's/minSdkVersion 16/minSdkVersion 19/' ./android/app/build.gradle > ./android/app/build2.gradle
mv -f ./android/app/build2.gradle ./android/app/build.gradle
flutter pub run flutter_launcher_icons:main
flutter build apk

# iOS
sed -e 's/<string>chatsen<\/string>/<string>Chatsen<\/string>/' ./ios/Runner/Info2.plist
mv -f ./ios/Runner/Info2.plist ./ios/Runner/Info.plist
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
There might be completly anonymous and opt-in optional analytics in the future but nothing as of yet.

# Contact

- Discord: **_TODO: Discord link_**
