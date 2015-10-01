# Usbong iOS
[![License](https://img.shields.io/badge/license-ALv2-blue.svg)](./LICENSE)

This is the Usbong app for iOS written in Swift.

## Build

- Xcode 7
- iOS 9 SDK
- Deployment Target: iOS 9 (will change to iOS 8 once [Phase 1](#phase-1) is finished)

This project uses [Carthage](https://github.com/Carthage/Carthage) as the dependency manager. [Install Carthage](https://github.com/Carthage/Carthage#installing-carthage) if it's not yet installed on your system. Run `carthage bootstrap`. Finally, open `usbong.xcodeproj`, then build the project.

## To-do

Check out the [Trello Board](https://trello.com/b/aHNqwHCu) for more detailed updates on progress.

### Phase 1
- [x] TextDisplay
- [x] ImageDisplay
- [x] TextImageDisplay
- [x] ImageTextDisplay
- [x] Read .utree
- [x] Read .xml

### Phase 2

- [x] Background audio
- [x] Voice-over (Audio file and text-to-speech)
- [ ] Translations
- [ ] Hints

### Extras

- [x] Smart unpacking of trees (used md5 hash to check for cached tree)
- [x] Clear cache of unpacked trees
- [ ] Travis CI
- [ ] Acknowledgements Page

## Components

- [ZipArchive](https://github.com/ZipArchive/ZipArchive)
  - ZipArchive is released under the [MIT license](https://github.com/ZipArchive/ZipArchive/blob/master/LICENSE.txt) and ZipArchive's modified version of [Minizip](http://www.winimage.com/zLibDll/minizip.html) 1.1 is licensed under the [Zlib license](http://www.zlib.net/zlib_license.html).
- [SWXMLHash](https://github.com/drmohundro/SWXMLHash)
  - SWXMLHash is released under the [MIT license](https://github.com/drmohundro/SWXMLHash/blob/master/LICENSE).

## License

Copyright 2015 Usbong Social Systems, Inc.

Licensed under the [Apache License, Version 2.0](./LICENSE) (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
