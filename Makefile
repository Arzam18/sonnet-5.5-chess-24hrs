# Android ARM64/NEON build for Sonnet 5.5 chess 24hrs.
# Set ANDROID_NDK_HOME to an installed Android NDK (r27.2 recommended).

ANDROID_API ?= 24
ANDROID_NDK_HOME ?= $(ANDROID_NDK_ROOT)
ANDROID_TOOLCHAIN := $(ANDROID_NDK_HOME)/toolchains/llvm/prebuilt/linux-x86_64/bin
ANDROID_CXX := $(ANDROID_TOOLCHAIN)/aarch64-linux-android$(ANDROID_API)-clang++
NNUE_FILE := $(abspath source/nets/n8a.nnue)
ANDROID_ENGINE := release/Sonnet55chess24hrs-arm64-android-neon
ANDROID_CXXFLAGS := -O3 -std=c++17 -DNDEBUG -flto -march=armv8-a+simd -pthread -static-libstdc++

.PHONY: android-arm64 clean

android-arm64:
	@test -n "$(ANDROID_NDK_HOME)" || { echo "ANDROID_NDK_HOME is not set" >&2; exit 1; }
	@test -x "$(ANDROID_CXX)" || { echo "Android NDK compiler not found: $(ANDROID_CXX)" >&2; exit 1; }
	@test -s "$(NNUE_FILE)" || { echo "Missing NNUE network: $(NNUE_FILE)" >&2; exit 1; }
	mkdir -p release
	"$(ANDROID_CXX)" $(ANDROID_CXXFLAGS) -DNET_FILE=\"$(NNUE_FILE)\" -o "$(ANDROID_ENGINE)" source/src/main.cpp

clean:
	rm -f "$(ANDROID_ENGINE)"
