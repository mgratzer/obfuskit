/**
 * This class is used for obfuscation and de-obfuscation of strings and byte arrays.
 * The obfuscation is done by XORing each byte of the input with a byte from a constant byte array `c`.
 * The index of the byte from `c` is the index of the byte from the input modulo the length of `c`.
 */
class O {
    private val c: ByteArray
    private val l: Int

    /**
     * Constructor that takes a string, converts it to a byte array and stores it in `c`.
     * The length of `c` is stored in `l`.
     *
     * @param s The string to be stored as a byte array in `c`.
     */
    constructor(s: String) {
        c = s.toByteArray(Charsets.UTF_8)
        l = c.size
    }

    /**
     * This function takes a string, converts it to a byte array,
     * and returns a new byte array where each byte is the XOR of the corresponding byte in the input
     * and a byte from `c`.
     *
     * @param v The string to be obfuscated.
     * @return The obfuscated byte array.
     */
    fun o(v: String): ByteArray {
        val a = v.toByteArray(Charsets.UTF_8)
        return ByteArray(a.size) { i -> (a[i].toInt() xor c[i % l].toInt()).toByte() }
    }

    /**
     * This function takes a byte array and returns a string where each character is the XOR of the corresponding byte in the input
     * and a byte from `c`.
     *
     * @param value The byte array to be de-obfuscated.
     * @return The de-obfuscated string.
     */
    fun r(value: ByteArray): String {
        return String(ByteArray(value.size) { i -> (value[i].toInt() xor c[i % l].toInt()).toByte() }, Charsets.UTF_8)
    }
}