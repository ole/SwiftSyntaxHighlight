import SwiftSyntaxHighlight

// Inspired by kaioberai/Wacro <https://github.com/kabiroberai/Wacro>

@_expose(wasm, "sh_malloc")
@_cdecl("sh_malloc")
public func wasmMalloc(_ size: UInt32) -> UnsafeMutablePointer<UInt8> {
    UnsafeMutablePointer<UInt8>.allocate(capacity: Int(size))
}

@_expose(wasm, "sh_free")
@_cdecl("sh_free")
public func wasmFree(_ pointer: UnsafeMutablePointer<UInt8>?) {
    pointer?.deallocate()
}

/// Syntax highlight Swift source code.
///
/// - Parameters:
///   - message: The source code to highlight. Pointer to UTF-8 text data.
///   - length: Length of the UTF-8 text in bytes.
/// - Returns: Pointer to the formatted source code with prefixed length.
///   The first 4 bytes are the length of the string in bytes (little endian).
///   The remainder is the string data in UTF-8.
///   The caller must free the returned pointer by calling the exported
///   ``free`` function.
@_expose(wasm, "syntax_highlight")
@_cdecl("syntax_highlight")
public func wasmSyntaxHighlight(
    _ message: UnsafeMutablePointer<UInt8>?,
    _ length: UInt32
) -> UnsafeMutablePointer<UInt8>? {
    let buffer = UnsafeBufferPointer(start: message, count: Int(length))
    let input = String(decoding: buffer, as: UTF8.self)
    let output = highlight(sourceCode: input, as: HTML.self)

    let byteCount = output.utf8.count
    let outPointer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: 4 + byteCount)
    var count = UInt32(output.count).littleEndian
    withUnsafeBytes(of: &count) {
        _ = outPointer.initialize(from: $0)
    }
    _ = outPointer[4...].initialize(from: output.utf8)

    return outPointer.baseAddress
}
