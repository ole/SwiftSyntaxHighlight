import SystemPackage
import WasmKit
import WasmKitWASI

@main
struct App {
    static func main() throws {
        // Parse a WASI-compliant WebAssembly module from a file.
        let wasmModulePath = FilePath(#filePath)
            .removingLastComponent()
            .appending("../../.build/wasm32-unknown-wasi/release/WebAssemblyExecutable.wasm")
            .lexicallyNormalized()
        let module = try parseWasm(filePath: wasmModulePath)
        let wasi = try WASIBridgeToHost()
        let engine = Engine()
        let store = Store(engine: engine)
        var imports = Imports()
        wasi.link(to: &imports, store: store)
        let instance = try module.instantiate(store: store, imports: imports)

        print("Wasm instance:", instance)
        _ = try wasi.start(instance)

        let exports = instance.exports
        guard case .memory(let memory) = exports["memory"] else {
            fatalError("bad memory")
        }
        guard case .function(let malloc) = exports["wacro_malloc"] else {
            fatalError("bad wacro_malloc")
        }
        guard case .function(let free) = exports["wacro_free"] else {
            fatalError("bad wacro_free")
        }
        guard case .function(let syntax_highlight) = exports["syntax_highlight"] else {
            fatalError("bad syntax_highlight")
        }

        let sourceCode = """
            print("Hello world")
            """
        print("""
            Input source code:
            \(sourceCode)
            
            """)
        let inputData = sourceCode.utf8
        let inputLength = inputData.count
        let inAddr = try malloc.invoke([.i32(UInt32(inputLength))])[0].i32
        print("inAddr:", inAddr)
        memory.withUnsafeMutableBufferPointer(offset: UInt(inAddr), count: inputLength) { buffer in
            buffer.copyBytes(from: inputData)
        }
        let outAddr = try syntax_highlight.invoke([.i32(inAddr), .i32(UInt32(inputLength))])[0].i32
        print("outAddr:", outAddr)
        let outputLength = memory.withUnsafeMutableBufferPointer(offset: UInt(outAddr), count: 4) { buffer in
            let length =
              (UInt32(buffer[0]) << 0) |
              (UInt32(buffer[1]) << 8) |
              (UInt32(buffer[2]) << 16) |
              (UInt32(buffer[3]) << 24)
            return length
        }
        let output = memory.withUnsafeMutableBufferPointer(offset: UInt(outAddr) + 4, count: Int(outputLength)) { buffer in
            String(decoding: buffer, as: UTF8.self)
        }
        print("""
            
            Formatted source code:
            \(output)
            """)
    }
}