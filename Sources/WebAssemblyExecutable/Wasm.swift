import SwiftSyntaxHighlight

@_expose(wasm, "wacro_malloc")
@_cdecl("wacro_malloc")
public func macroMalloc(_ size: UInt32) -> UnsafeMutablePointer<UInt8> {
    UnsafeMutablePointer<UInt8>.allocate(capacity: Int(size))
}

@_expose(wasm, "wacro_free")
@_cdecl("wacro_free")
public func macroFree(_ pointer: UnsafeMutablePointer<UInt8>?) {
    pointer?.deallocate()
}

/// Syntax highlight Swift source code.
///
/// - Returns: Pascal-style string in UTF-8 with a 32-bit length prefix (little endian).
///   The caller must free the returned pointer.
@_expose(wasm, "syntax_highlight")
@_cdecl("syntax_highlight")
public func syntaxHighlight(
    _ message: UnsafeMutablePointer<UInt8>?,
    _ size: UInt32
) -> UnsafeMutablePointer<UInt8>? {
    let buffer = UnsafeBufferPointer(start: message, count: Int(size))
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
