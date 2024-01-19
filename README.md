# ObfusKit

ObfusKit is a ruby script to generate obfuscated secrets for `Swift` and `Kotlin`.

## Installation and usage

Install the latest version of the gem using:

```
gem install obfuskit
```

To generate Swift code run the following command:

```sh
obfuskit swift SECRET_1 SECRET_2 > generated.swift
```

It will will create the file `generated.swift` containing an obfuscated version of the environment variables `SECRET_1` and `SECRET_2`. 
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

struct O { private let c: [UInt8]; private let l: Int; init(_ s: String) { self.init([UInt8](s.utf8)) }; init(_ c: [UInt8]) { self.c = c; l = c.count }; @inline(__always) func o(_ v: String) -> [UInt8] { [UInt8](v.utf8).enumerated().map { $0.element ^ c[$0.offset % l] } }; @inline(__always) func r(_ value: [UInt8]) -> String { String(bytes: value.enumerated().map { $0.element ^ c[$0.offset % l] }, encoding: .utf8) ?? "" } }
```

The same concept applies for the `kotlin` language using:

```sh
obfuskit kotlin com.myapp.configuration.environment SECRET_1 SECRET_2 > generated.kt
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

class O{private val a:ByteArray;private val b:Int;constructor(s:String){a=s.toByteArray(Charsets.UTF_8);b=a.size};fun o(v:String):ByteArray{val d=v.toByteArray(Charsets.UTF_8);return ByteArray(d.size){i->(d[i].toInt() xor a[i%b].toInt()).toByte()}};fun r(value:ByteArray):String{return String(ByteArray(value.size){i->(value[i].toInt() xor a[i%b].toInt()).toByte()},Charsets.UTF_8)}}

```

## Features
- [x] Generate Swift
- [x] Generate Kotlin
- [x] Read secrets from the Environment 
- [x] Add dynamic salt for obfuscation
- [x] Support for .env files
- [x] Use template engine for code generation
- [ ] Read secrets from 1Password CLI