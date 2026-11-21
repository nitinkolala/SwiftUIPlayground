# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

No package manager, linter, or formatter is configured. Build and test with `xcodebuild` (or Xcode, scheme `SwiftUI_CodingPractice`):

```bash
# Build for the simulator
xcodebuild -project SwiftUI_CodingPractice.xcodeproj -scheme SwiftUI_CodingPractice -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

# Run all unit and UI tests
xcodebuild -project SwiftUI_CodingPractice.xcodeproj -scheme SwiftUI_CodingPractice -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test

# Run a single test (Target/Class/method)
xcodebuild -project SwiftUI_CodingPractice.xcodeproj -scheme SwiftUI_CodingPractice -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SwiftUI_CodingPracticeTests/CounterTests/testIncrementAddsOne

# Run only the UI tests
xcodebuild -project SwiftUI_CodingPractice.xcodeproj -scheme SwiftUI_CodingPractice -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SwiftUI_CodingPracticeUITests
```

Notes:
- The scheme is auto-generated; there is no shared scheme file in the repo. `xcodebuild -list` shows it.
- If `iPhone 17 Pro` is not installed, pick one from `xcrun simctl list devices available`.

## Architecture

This is a single-target SwiftUI app with unit and UI test targets, all in one Xcode project under `SwiftUI_CodingPractice/`.

- **Entry point:** `SwiftUI_CodingPractice/SwiftUI_CodingPracticeApp.swift` defines the `@main` `App`, which hosts `ContentView` in a `WindowGroup`. This is the only scene.
- **Screen:** `SwiftUI_CodingPractice/Demo_@State.swift` (despite its name, it contains `struct ContentView`) is a counter screen with +, -, and Reset buttons. It owns the value with `@State private var counter = Counter()`. Its buttons call `Counter` methods, and Reset is disabled when `counter.canReset` is false.
- **Logic:** `Counter.swift` is a plain `struct` with `value`, `increment()`, `decrement()`, `reset()`, and `canReset`. It has no UI dependency, so keep counter behavior here rather than in the view. Decrement is not clamped at zero.
- **Tests:**
  - `SwiftUI_CodingPracticeTests/SwiftUI_CodingPracticeTests.swift` (class `CounterTests`) is a unit test target that uses `@testable import SwiftUI_CodingPractice`. It tests `Counter` directly.
  - `SwiftUI_CodingPracticeUITests` drives the real screen with `XCUIApplication`. It finds elements by accessibility text: `"Count: N"` for the label, and the buttons `"+"`, `"-"` (ASCII hyphen), and `"Reset"`.
  - `SwiftUI_CodingPracticeUITestsLaunchTests` runs the launch test for each UI configuration and attaches a screenshot.
- **Assets:** `Assets.xcassets` contains the app icon and accent color.

## Build settings that affect code

- `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`: top-level code and types are main-actor isolated by default. Mark types `nonisolated` if they must run off the main actor.
- `SWIFT_APPROACHABLE_CONCURRENCY = YES` and `SWIFT_VERSION = 5.0`.
- `ENABLE_PREVIEWS = YES`: views use `#Preview` blocks.
- `TARGETED_DEVICE_FAMILY = "1,2"` (iPhone and iPad). Layouts must work on both.
- `IPHONEOS_DEPLOYMENT_TARGET = 26.5`.
