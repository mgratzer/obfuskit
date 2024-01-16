/// A structure representing an obfuscator.
struct O {
	/// A private constant array of UInt8.
	private let c: [UInt8]
	/// The length of the array `c`.
	private let l: Int
	/// Initializes the obfuscator with a string.
	/// The string is converted to an array of UInt8 and stored in `c`.
	/// The count of the array is stored in `l`.
	init(_ s: String) {
		self.init([UInt8](s.utf8))
	}

	/// Initializes the obfuscator with an array of UInt8.
	/// The array is stored in `c` and its count is stored in `l`.
	init(_ c: [UInt8]) {
		self.c = c; l = c.count
	}

	/// Obfuscates a string.
	/// The string is converted to an array of UInt8 and each element is XORed with an element from `c`.
	/// The index of the element from `c` is the index of the element from the string modulo `l`.
	@inline(__always)
	func o(_ v: String) -> [UInt8] {
		[UInt8](v.utf8).enumerated().map { $0.element ^ c[$0.offset % l] }
	}

	/// Reverses the obfuscation of an array of UInt8.
	/// Each element is XORed with an element from `c` and the result is converted back to a string.
	/// The index of the element from `c` is the index of the element from the array modulo `l`.
	@inline(__always)
	func r(_ value: [UInt8]) -> String {
		String(bytes: value.enumerated().map { $0.element ^ c[$0.offset % l] }, encoding: .utf8) ?? ""
	}
}