[![Swift 5.3](https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat)](https://swift.org)
[![CI](https://github.com/jcoynel/app-store-reviews-swift/workflows/CI/badge.svg)](https://github.com/jcoynel/app-store-reviews-swift/actions)
[![codecov](https://codecov.io/gh/jcoynel/app-store-reviews-swift/branch/main/graph/badge.svg?token=VT4I7ZSZWH)](https://codecov.io/gh/jcoynel/app-store-reviews-swift)
[![SPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)

## About AppStoreReviews

AppStoreReviews is a Swift Package to download user reviews from the iTunes Store and the Mac App Store.

It supports:

* All countries
* All apps on the iTunes Store
* All apps on the Mac App Store

This module uses the public feed to customer reviews: `https://itunes.apple.com/rss/customerreviews/page=1/id=1510826067/sortby=mostrecent/json?l=en&cc=gb`

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

Adding AppStoreReviews as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/jcoynel/app-store-reviews-swift.git", .upToNextMajor(from: "1.0.0")),
]
```

### [Mint](https://github.com/yonaskolb/mint)

```sh
$ mint install jcoynel/app-store-reviews-swift
```

## Usage

### As a command line tool when installed with Mint

`app-store-reviews` includes several subcommands and options:

```
OVERVIEW: Fetch user reviews from the Apple App Stores.

USAGE: app-store-reviews [--version] <subcommand>

OPTIONS:
  -v, --version           Print the version and exit. 
  -h, --help              Show help information.

SUBCOMMANDS:
  reviews                 Fetch all the reviews from the App Store Reviews feed for the provided app ID and territory.
  page                    Fetch the App Store Reviews feed page for the provided app ID, territory and page number.
  territories             Print the list of territories reviews can be fetched for.

  See 'app-store-reviews help <subcommand>' for detailed help.
```

#### territories

```
OVERVIEW: Print the list of territories reviews can be fetched for.

USAGE: app-store-reviews territories

OPTIONS:
  -h, --help              Show help information.
```

Examples:

```sh
$ app-store-reviews territories
```

#### reviews

```
OVERVIEW: Fetch all the reviews from the App Store Reviews feed for the provided app ID and territory.

USAGE: app-store-reviews reviews <app-id> <territory> <file-output>

ARGUMENTS:
  <app-id>                The ID of the app. 
  <territory>             App Store country or region. 
  <file-output>           The reviews file output. 

OPTIONS:
  -h, --help              Show help information.
```

Examples:

```sh
$ app-store-reviews reviews 555731861 GB reviews_555731861_GB.json
$ app-store-reviews reviews 497799835 US reviews_497799835_US.json
```

#### page

```
OVERVIEW: Fetch the App Store Reviews feed page for the provided app ID, territory and page number.

USAGE: app-store-reviews page <app-id> <territory> <page> <file-output>

ARGUMENTS:
  <app-id>                The ID of the app. 
  <territory>             App Store country or region. 
  <page>                  The page number. 
  <file-output>           The reviews file output. 

OPTIONS:
  -h, --help              Show help information.
```

Examples:

```sh
$ app-store-reviews page 555731861 GB 1 page_555731861_1_GB.json
$ app-store-reviews page 497799835 US 1 page_497799835_1_US.json
$ app-store-reviews page 497799835 US 5 page_497799835_5_US.json
```

### As a library

Add the following to your Package.swift file's dependencies:

```swift
.package(url: "https://github.com/jcoynel/app-store-reviews-swift.git", .upToNextMajor(from: "1.0.0")),
```

And then import wherever needed:

```swift
import AppStoreReviews
```