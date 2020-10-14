# Sodium

![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20iOS-lightgrey.svg)
![Carthage](https://img.shields.io/badge/Carthage-compatible-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

This project simply wraps libsodium into a dynamic framework for iOS and macOS.

Current libsodium version used: 1.0.18

## Installation

You have a few different options:

### Manual installation

 *  Include the Sodium.xcodeproj as a dependency in your project. This is what the projects under ```Examples/``` are doing. Doing this means Sodium.framework will be compiled alongside your project, including after every clean.  
 *  Use a pre-built Sodium.framework. You can find them under [Releases](https://github.com/OuterCorner/Sodium/releases).

### SwiftPM

In your `Package.swift`, add `Sodium` as a dependency:
```swift
dependencies: [
  .package(url: "https://github.com/OuterCorner/Sodium", from: "1.0.18")
],
```

Associate the dependency with your target:
```swift
targets: [
  .target(name: "App", dependencies: ["Sodium"])
]
```

## Usage

After importing the umbrella header:

```ObjC
#import <Sodium/Sodium.h>
```
You can simply start using libsodium APIs as usual.

```ObjC
crypto_secretbox_keygen(key);
randombytes_buf(nonce, sizeof(nonce));
```

See example projects under ```Examples/```.

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE).

Note the underlying libsodium library [LICENSE](https://github.com/jedisct1/libsodium/blob/master/LICENSE) still applies when using this project.
