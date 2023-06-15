<h1 align="middle">Chatsen</h1>

<div align="middle" float="left">
  <a href="https://chatsen.app/discord"><img src="https://img.shields.io/discord/758710852756570153.svg?label=&logo=discord&logoColor=ffffff&color=5865F2&labelColor=5C5C5C"></a>
  <a href="https://hanadigital.github.io/grev/?user=chatsen&repo=chatsen"><img src="https://img.shields.io/github/downloads/chatsen/chatsen/total?color=23B14D"></a>
  <a><img src="https://img.shields.io/github/license/chatsen/chatsen"></a>
  <img src="https://badges.crowdin.net/chatsen/localized.svg">
</div>

<div align="middle" float="left">
  <a href="https://apps.apple.com/us/app/chatsen/id1574037007"><img height="75" src="assets/app_store_badge.png"></a>
  <a href="https://play.google.com/store/apps/details?id=com.chatsen.chatsen"><img height="75" src="assets/play_store_badge.png"></a>
</div>

# 🛠️ Building the application
```sh
# Initialize the project
flutter create .
rm -rf test

# Build auto-generated source files
flutter pub run build_runner build --delete-conflicting-outputs

# Build the application on your desired platform
flutter build ios --no-codesign # for iOS
flutter build android # for Android
```

# 📜 Licensing
Chatsen is distributed under the AGPLv3 licence. A copy may be found in the LICENCE file in that repository. All the dependencies remain under their original licenses.
