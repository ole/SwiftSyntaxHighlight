
# Requires a current main-branch development toolchain of Swift and
# a compatible WASI SDK from https://github.com/swiftwasm/swift/releases.
#
# Example:
#
#     $ swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-12-23-a/swift-wasm-DEVELOPMENT-SNAPSHOT-2024-12-23-a-wasm32-unknown-wasi.artifactbundle.zip --checksum 3086a095892c752fbe42122469616d70c0e17e28f692c475a9e045c1daeefb2a
#
# Activate the toolchain with:
#
#     export TOOLCHAINS=$(plutil -extract CFBundleIdentifier raw ~/Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist)
#
# (or similar)
wasmlib:
	# Build as a WebAssembly reactor module (the default is 'command').
	# See https://github.com/WebAssembly/WASI/blob/main/legacy/application-abi.md
	swift build \
		--swift-sdk wasm32-unknown-wasi \
		--product SwiftSyntaxHighlight-wasm \
		-c release \
		-Xswiftc -Xclang-linker -Xswiftc -mexec-model=reactor \
		-Xswiftc -Osize
	cp -a .build/wasm32-unknown-wasi/release/SwiftSyntaxHighlight-wasm.wasm SwiftSyntaxHighlight.wasm
	type -p wasm-opt && wasm-opt -Os --strip-debug SwiftSyntaxHighlight.wasm -o SwiftSyntaxHighlight.wasm || :
