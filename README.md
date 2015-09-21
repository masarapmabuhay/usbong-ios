# Usbong iOS

This is the Usbong app for iOS written in Swift.

## Build

- Xcode 7
- iOS 9 SDK
- Deployment Target: iOS 9 (will change to iOS 8 once [Phase 1](#phase-1) is finished)

Open `usbong.xcodeproj`, then build the project. The recommended dependency manager is [Carthage](https://github.com/Carthage/Carthage), though, it is not yet used in this project.

## To-do
### Phase 1
- [x] TextDisplay
- [x] ImageDisplay
- [x] TextImageDisplay
- [x] ImageTextDisplay
- [x] Read .utree
- [ ] Read .xml

### Extras

- [x] Smart unpacking of trees (used md5 hash to check for cached tree)
- [ ] Clear cache of unpacked trees

## Components

- [ZipArchive](https://github.com/ZipArchive/ZipArchive)
  - ZipArchive is released under the [MIT license](https://github.com/ZipArchive/ZipArchive/raw/master/LICENSE.txt) and ZipArchive's modified version of [Minizip](http://www.winimage.com/zLibDll/minizip.html) 1.1 is licensed under the [Zlib license](http://www.zlib.net/zlib_license.html).

## License

This software is distributed under the [Apache License Version 2.0](./LICENSE)
