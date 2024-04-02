# ObfusKit
ObfusKit is a ruby script that generates obfuscated secrets for `Swift` and `Kotlin`.

## Installation and usage

Install the latest version of the gem using:

```sh
gem install obfuskit
```

Call `obfuskit -h` for help.

```sh
Usage: obfuskit [options]

Specific options:
    -l, --language [LANGUAGE]        Output language (swift, kotlin). Kotlin requires a package parameter.
    -k SECRET_1,SECRET_2,SECRET_3,   List of environment variable keys
        --keys
    -p, --package [PACKAGE]          Package name for Kotlin
    -t, --type [TYPE]                Output type name. Defaults to `ObfusKit`
    -e, --env [PATH]                 Path to an alternative .env file

Common options:
    -h, --help                       Show this message
    -v, --version                    Show version
```

### Swift

To generate Swift code, run the following command:

```sh
obfuskit -l swift -k SECRET_1,SECRET_2 > generated.swift
```

It will create the file `generated.swift` containing an obfuscated version of the environment variables `SECRET_1` and `SECRET_2`. 
This file should be excluded from the git repository and generated at build time. 
The obfuscation salt is regenerated for each run.

```swift
import Foundation

enum ObfusKit {
	static let SECRET_1: String = _o.r([30, 113, 37, 119, 32, 37, 36])
	static let SECRET_2: String = _o.r([24, 117, 35, 119, 38, 33, 34])

	private class _3f3eccd2e5ea46b39738e5502bda6bef { }
	private static let _o = O(String(describing: _3f3eccd2e5ea46b39738e5502bda6bef.self))
}
// ...
```

### Kotlin 

The same concept applies to the Kotlin language using:

```sh
obfuskit -l kotlin -p com.myapp.configuration.environment -k SECRET_1,SECRET_2 > generated.kt
```
It will create the Kotlin version `generated.kt`.

```kotlin
package com.myapp.configuration.environment

object ObfusKit {
        private val _o = O(_6572131328ef462d9d4a05cf4b2a2516::class.java.simpleName)
        private class _6572131328ef462d9d4a05cf4b2a2516

        val SECRET_1: String = _o.r(byteArrayOf(30, 116, 118, 115, 119, 119, 116))
        val SECRET_2: String = _o.r(byteArrayOf(24, 112, 112, 115, 113, 115, 114))
}
// ...
```

## Customizations

### The output type name

The default generated type name in the target language is `ObfusKit`. Customize this name with the `-t` option to generate the Swift type `Secrets` instead of `ObfusKit`.

```swift
import Foundation

enum Secrets {
// ..
```

### Use a custom .env file location

Use the `-e` option to define the path to a different `.env` file, e.g., if you want to reuse the `fastlane/.env` file.

```sh
obfuskit -l swift -k SECRET_3,SECRET_4 -e fastlane/.env > generated.swift
```

## Features
- [x] Generate Swift
- [x] Generate Kotlin
- [x] Read Secrets from the Environment 
- [x] Add dynamic salt for obfuscation
- [x] Support for .env files
- [x] Use template engine for code generation
- [ ] Read secrets from 1Password CLI