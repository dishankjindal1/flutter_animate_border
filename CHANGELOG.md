## 1.2.3

- Bug Fix: Only update dimensions when `renderBox.hasSize` to avoid using size before layout (e.g. Image before load)
- Improvement: Defer build-time size calculation with `Future.microtask` and optional `doSetState` in `_calculate()` for cleaner handling of dynamically sized children

## 1.2.2 [IMPROVEMENT RELEASE]

- Bug Fix: Guard `_calculate()` with `globalKey.currentContext != null` to avoid null reference when wrapping dynamically built widgets (e.g. Image)

## 1.2.1

- Bug Fix, if the wrapping with Image like widgets, as they are made dynamically
- Added new feature, now you can freeze the animation use it as colorful border with gradient, check screenshots to learn more

## v1.0.2

- Bug Fix, dependency updates

## v1.0.1

- Made the color property nullable, handle nullable color

## v1.0.0

- Breaking changes, please check out the example code

## v0.2.3

- BugFix - Animation controller ticker leak

## v0.2.2

- BugFix - Animation controller ticker leak

## v0.2.1

- Updated docs

## v0.2.0

- Removed the padding and decoration.
- Added gradient.
- Added linePadding.
- Added new example and screenshot.

## v0.1.0

- Added a controller to customize the ui and behavior.
- Added start and stop behavior.

## v0.0.2

- Improved animate border logic with edge-cases.
- Added screenshot on the doc for a quick glance.

## v0.0.1

- Initial commit with animate border code
