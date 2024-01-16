# ObfusKit

ObfusKit is a ruby script to generate obfuscated secrets for `Swift` and `Kotlin`.

## Usage

Running the command 

```sh
ruby obfuskit.rb swift SECRET_1 SECRET_2 > generated.swift
```

will create the file `generated.swift` containing an obfuscated version of the environment variables `SECRET_1` and `SECRET_2`. This file should be exculded from the git repository and generated at build time. The obfuscation salt is regnerated for each run.

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
ruby obfuskit.rb kotlin SECRET_1 SECRET_2 > generated.kt
```

## Features
- [x] Generate Swift
- [x] Generate Kotlin
- [x] Read secrets from the Environment 
- [x] Add dynamic salt for obfuscation
- [x] Support for .env files
- [ ] Use template engine for code generation
- [ ] Read secrets from 1Password CLI