# Thmanyah iOS App

A production-grade iOS app built with **SwiftUI** (Home) and **UIKit** (Search), following **Clean Architecture**, **MVVM**, **SOLID**, and **protocol-oriented design**. Data is loaded from remote APIs and displayed in dynamic, API-driven sections.

## Requirements

- **Swift 5.9+**
- **Xcode 15+**
- **iOS 16+** (project may be set to a higher deployment target; code is compatible with iOS 16+)
- **Swift Package Manager** only (no CocoaPods)

## Architecture

The app is structured in three main layers:

```
thmanyah/
├── Core/           # Networking, DI, utilities
├── Domain/         # Entities, use cases, repository protocols
├── Data/           # API, DTOs, mappers, repository implementations
└── Presentation/
    ├── Home/       # SwiftUI views and ViewModels
    └── Search/     # UIKit SearchViewController + SwiftUI wrapper
```

### Clean Architecture

- **Domain**: Pure business models (`Section`, `SectionItem`, `ContentType`, `LayoutType`) and protocols (`HomeRepositoryProtocol`, `SearchRepositoryProtocol`). Use cases (`FetchHomeSectionsUseCase`, `SearchContentUseCase`) orchestrate data flow.
- **Data**: DTOs match API JSON; mappers convert DTOs to domain entities. Repositories implement domain protocols and call API services.
- **Presentation**: ViewModels depend on use cases (injected); Views/ViewControllers observe ViewModels. Home is SwiftUI; Search is UIKit with `UIViewControllerRepresentable` for navigation from SwiftUI.

### Key Decisions

- **Single `SectionItem` model**: The API returns different content shapes (podcast, episode, audiobook, article). The data layer uses one DTO with optional fields and mappers produce a unified `SectionItem` so the UI stays layout-driven (by `LayoutType`) instead of content-type branches.
- **LayoutType normalization**: The API can send `"big square"` (with space); `LayoutType(rawValue:)` normalizes to `big_square` so layout logic is consistent.
- **Debounced search**: Search uses a 200 ms debounce implemented with `Task.sleep` and `Task.cancel`: each new keystroke cancels the previous task and starts a new one, avoiding duplicate and outdated requests.
- **Dependency injection**: `AppContainer` holds `APIClient`, repositories, and `ImageLoader`. ViewModels receive use cases built from the container; tests inject mock repositories.

## API Endpoints

| Purpose   | URL |
|----------|-----|
| Home sections | `https://api-v2-b2sit6oh3a-uc.a.run.app/home_sections` |
| Search   | `https://mock.apidog.com/m1/735111-711675-default/search` |

Home supports pagination via `?page=`; section order and layout types come from the API.

## Features

- **Home (SwiftUI)**  
  - Vertically scrollable list of sections.  
  - Section layouts: horizontal list (square, big_square, queue), two-line grid.  
  - Pull-to-refresh and infinite scroll (next page).  
  - Loading, error, and retry.  
  - Search button in toolbar → pushes Search.

- **Search (UIKit)**  
  - `UISearchBar` with 200 ms debounce.  
  - Previous request cancelled on new input; duplicate queries avoided by debounce.  
  - Results shown in the same section-style layouts as Home (compositional layout).  
  - Empty and loading states.

- **Theme & typography**  
  - **Theme manager** (`Core/Theme/`): Central `AppTheme` (dark background, yellow/gold accent, white and gray text) and `AppTypography` (semantic styles). Applied via view modifiers (e.g. `.appBackground()`, `.appAccent()`) and `UIColor`/`UIFont` extensions for UIKit.  
  - **Font**: System fonts (SF Pro for Latin, SF Arabic for Arabic) are used via `AppTypography` for a clean, modern look with full Arabic support and no extra dependencies.

- **Audio & video playback**  
  - When the API returns `audio_url` (and optionally `video_url`), playable items show a **play button** on cards.  
  - **PlaybackService** (single shared instance): Plays audio or video via `AVPlayer`, supports play/pause, seek, skip ±15/30s.  
  - **Mini player**: Sticky bar at the bottom with artwork, title, progress, and controls; tap to open full player.  
  - **Full player**: Sheet with artwork, title, progress slider, and Audio/Video toggle when both URLs are present.  
  - Domain model `SectionItem` includes `audioURL` and `videoURL`; DTO and mapper pass them through from the API.

- **Networking**  
  - Generic `APIClient` with `async/await`, `Decodable`, HTTP status checks, and cancellation.

- **Testing**  
  - Unit tests for ViewModels, use cases, DTO decoding, and API client (with `URLProtocol` stub).  
  - Mock repositories for isolation.  
  - UI tests: launch, home sections, search navigation.

## Running the App

1. Open `thmanyah.xcodeproj` in Xcode.
2. Select a simulator or device (e.g. iPhone 17).
3. Build and run (⌘R).

## Tests

- **Unit tests**: `thmanyahTests`  
  - Run: **Product → Test** (⌘U), or:
    ```bash
    xcodebuild test -scheme thmanyah -sdk iphonesimulator \
      -destination 'platform=iOS Simulator,name=iPhone 17' \
      -only-testing:thmanyahTests
    ```
- **UI tests**: `thmanyahUITests`  
  - Same scheme; run all tests or only `thmanyahUITests`.

**Test coverage**

- Enable: **Edit Scheme → Test → Options → Code Coverage**.  
- After running tests, **Report Navigator** (last tab) → **Coverage** shows per-file coverage.  
- Goal: maintain **40%+** coverage on Domain and key Presentation/Data paths.

## Challenges and Notes

1. **Mixed content in one section**: The API returns a single `content` array that can mix types (e.g. podcast vs episode). The app treats each section as having one `content_type` and maps items accordingly; if the API ever sends mixed types per section, mapping would need to be per-item.
2. **Search API shape**: The mock search API may return different field names or types; the same DTOs and mappers as Home are reused. If the real search API diverges, a dedicated Search DTO/mapper would be needed.
3. **SwiftUI + UIKit**: Search is UIKit for the requirement “UIKit for one screen.” Integration is via `SearchViewControllerWrapper` (SwiftUI) that creates a `UINavigationController` with `SearchViewController` and presents it in the SwiftUI navigation stack.
4. **Layout type “big square”**: Handled by normalizing the string (e.g. replace space with underscore) before matching `LayoutType`.

## Possible Improvements

- **Image caching**: Use the existing `ImageLoader` actor (or a library) in SwiftUI/UIKit cells to cache images and avoid repeated network requests.
- **Skeleton loading**: Add placeholder/shimmer views while sections load.
- **Error/empty states**: Dedicated empty-state view for “no results” and clearer error messages with retry.
- **Accessibility**: Labels and hints for section headers and content cards; VoiceOver-friendly order.
- **Localization**: Move strings to `Localizable.xcstrings` (or equivalent) for Arabic/English.
- **Modularization**: Move Core/Domain/Data into Swift packages for clearer boundaries and reuse.

## Summary

The solution delivers a **dynamic, API-driven Home** in SwiftUI and a **debounced Search** in UIKit, with **Clean Architecture**, **protocol-based DI**, **async/await** networking, and **testable** use cases and ViewModels. All requirements (MVVM, SOLID, protocol-oriented design, SPM-only, SwiftUI Home, UIKit Search, 200 ms debounce, cancellation, unit and UI tests) are addressed.
