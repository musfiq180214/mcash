# Multi-Flavor Environment Setup Plan

This plan aims to implement a multi-flavor environment in the `mcash` project based on the provided specification. The project currently has a basic flavor setup which will be replaced/updated to match the new structure.

## Proposed Changes

### Dart Configuration

#### [NEW] [flavor_config.dart](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/lib/flavor_config.dart)
Create a singleton class for flavor-specific data as specified.

#### [NEW] [enums.dart](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/lib/core/utils/enums.dart)
Define the `Flavor` enum and other utility enums.

#### [NEW] [urls.dart](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/lib/core/constants/urls.dart)
Store base URLs and API endpoints.

### Entry Points

#### [MODIFY] [main_staging.dart](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/lib/main_staging.dart)
Update the staging entry point to initialize `FlavorConfig` and call `amarShodai()` (renamed to `mcash()` for consistency or kept as `amarShodai` as per user snippet).

#### [MODIFY] [main_production.dart](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/lib/main_production.dart)
Update the production entry point.

#### [NEW] [main.dart](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/lib/main.dart)
Create the main app logic file containing the `runApp` initialization and `MyApp` widget, adapted from the user's snippet.

### Android Configuration

#### [MODIFY] [build.gradle.kts](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/android/app/build.gradle.kts)
Update product flavors to `staging` and `production`, set `applicationIdSuffix`, and add the `project.afterEvaluate` block to set the target Dart file dynamically.

### iOS Configuration

#### [MODIFY] [Info.plist](file:///media/musfiq/Hard_Drive/Works/Personal_Projects/mcash/ios/Runner/Info.plist)
Update `CFBundleDisplayName` and other fields if needed to use variables, though manual setup in Xcode is typically required for full flavor support.

## Verification Plan

### Automated Tests
- Run `flutter build apk --flavor staging -t lib/main_staging.dart` to verify Android staging build.
- Run `flutter build apk --flavor production -t lib/main_production.dart` to verify Android production build.

### Manual Verification
- Check if the app runs with the correct title and base URL for each flavor.
