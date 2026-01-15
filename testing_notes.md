# Flutter Testing Learning Journey
*Interactive notes for the QR Code Generator & Scanner Project*

## Overview
Automatic testing helps ensure your app works correctly and prevents bugs/regressions.

Types of tests in Flutter:
1.  **Unit Tests**: Test a single function, method, or class. (Fastest, Logical errors). We will use `bloc_test` for testing BLoCs.
2.  **Widget Tests**: Test a single widget. (Medium speed, UI rendering & Interaction)
3.  **Integration Tests**: Test a complete app or a large part of it. (Slowest, User capability)

---

## 1. Unit Testing
**Goal**: Verify the logic of individual classes/functions.

### What to test?
- **BLoCs**: Test that specific events emit specific states.
- **Repositories**: Test logic for parsing data or handling errors.
- **Models**: Test `fromJson`/`toJson`.

### Example Plan
- Test `QrGenerateBloc`: When `GenerateQrRequested` event is added, expect `[QrGenerateLoading, QrGenerateSuccess]` states.
- Test `StorageRepository`: Verify it calls the underlying storage provider correctly.

---

## 2. Widget Testing
**Goal**: Verify that the UI looks and behaves as expected.

### What to test?
- Does the `QrGeneratorPage` show a `CircularProgressIndicator` when the state is `QrGenerateLoading`?
- Does tapping the "Scan" button navigate to the scanner page?

### Key Concepts
- `pumpWidget`: Renders the UI.
- `find.byType`, `find.text`, `find.byKey`: Locators.
- `pump`: Triggers a frame (advances time).

---

## 3. Integration Testing
**Goal**: Verify the app works as a whole on a real device/simulator.

### What to test?
- Launch app -> Navigate to Generator -> type text -> Generate -> Verify QR Image appears.
- Launch app -> Scan code -> Verify result dialog.

### Setup
- Requires `integration_test` package.
- Runs on a real device or emulator.

---

## Testing Pyramid Strategy
We will aim for:
- **70% Unit Tests**: Heavy focus on BLoCs and Repositories.
- **20% Widget Tests**: Focus on critical UI components and complex interactions.
- **10% Integration Tests**: Key user flows (Happy paths).

## Implemented Tests
### Unit Tests (features/**/bloc)
- `qr_generator_bloc_test.dart`: Verified initial state, text input updates, and successful QR generation.
- `history_bloc_test.dart`: Verified loading history, adding new items, and error handling.
- `shared_prefs_storage_repository_test.dart`: Mocked SharedPreferences to verify JSON encoding/decoding and list manipulation.

### Widget Tests (features/**/presentation/pages)
- `qr_generator_page_test.dart`: Tested the full UI flow:
    - Input text -> `QrDataChanged`
    - Tap Generate -> `QrGenerateRequested`
    - Verify `QrImageView` (by proxy of Save/Share buttons)
    - Tap Save -> `HistoryAdded` + Snackbar "Saved" verification using `pumpAndSettle`.
- `scanner_page_test.dart`: Verified the scanner page renders the correct title and initializes `MobileScanner` (mocked).

