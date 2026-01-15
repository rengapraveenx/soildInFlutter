# Flutter & Architecture Q&A

## 1. Local vs Global BlocProvider
**Question**: Why do we provide `QrGeneratorBloc` in `QrGeneratorPage` instead of `main.dart`?
**Answer**:
*   **Lifecycle & Memory**: When you leave the `QrGeneratorPage`, the `BlocProvider` automatically **closes** (disposes) the `QrGeneratorBloc`. This frees up memory. If it were in `main.dart`, it would stay in memory forever, even when you aren't using the feature.
*   **State Reset**: Every time you open the Generator page, you usually want a fresh state (empty text field). If it's global, the old text/QR would still be there from the last time.
*   **Rule of Thumb**: 
    *   **Global (`main.dart`)**: Data needed across the *entire* app (User Session, Settings/Theme, History that is shown in multiple tabs).
    *   **Local (`Page`)**: Data needed *only* for that screen (Form inputs, temporary loading states).

---

## 2. BlocProvider vs RepositoryProvider
*   **RepositoryProvider**: Used for **Dependencies** (Data Layer). It holds classes that fetch data (API, Database). These usually don't have active "state" that changes rapidly for the UI.
*   **BlocProvider**: Used for **State Management** (Logic Layer). It holds BLoCs that managing the UI state. `BlocProvider` has special logic to `.close()` streams when a widget is destroyed.

## 3. How to use BlocBuilder?
It listens to a Bloc. Whenever the Bloc emits a new state, the `builder` function runs again to redraw the UI.
```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    if (state.isLoading) return CircularProgressIndicator();
    return Text(state.data);
  }
)
```

## 4. Why UseCase?
*   **Clean Architecture Concept**. It sits between the BLoC and the Repository.
*   **Purpose**: Encapsulates a single specific business rule, e.g., `CalculateTaxUseCase` or `LoginUserUseCase`.
*   **Why we skipped it**: For simpler apps, it can be boilerplate. The BLoC calling the Repository directly is often fine (`Pragmatic Clean Architecture`).

## 5. What is a Repository?
*   **The "Middleman"**: It sits between your App Logic (Bloc) and your Data Sources (API, specific Database).
*   **Benefit**: Your BLoC asks for `getHistory()`. It doesn't care if the data comes from Firebase, SQLite, or SharedPreferences. The Repository handles the "How".

## 6. Why Equatable?
*   **Problem**: In Dart, `class A {}` and `class A {}` are NOT equal by default (different memory location).
*   **Solution**: `Equatable` compares the *values* inside.
*   **Why for Bloc**: BlocBuilder only rebuilds if `newState != oldState`. With Equatable, if you emit `Success("A")` and then `Success("A")` again, it knows they are equal and skips the unnecessary rebuild.

## 7. Why Freezed?
*   A popular package that generates code for `copyWith`, `toString`, `==` (equality), and Union Types.
*   It makes writing BLoC states/events much less verbose. (We used manual Equatable here to understand the basics first).

## 8. Why Sealed Classes?
*   **Dart 3 Feature**. It creates a strict hierarchy.
*   **Benefit**: If you have `sealed class State {}` with subclasses `Success`, `Error`, `Loading`. The compiler *forces* you to handle ALL 3 cases in a switch statement. You can't forget one.

## 9. Stream vs Future
*   **Future**: **One** value, delivered later. (Like ordering a package 📦 -> It arrives once).
    *   *Usage*: HTTP request, Read file once.
*   **Stream**: **Many** values, delivered over time. (Like a water pipe 🚰 -> Water keeps flowing).
    *   *Usage*: WebSockets, User clicks, Stopwatches, Bluetooth data.

## 10. Emit vs Yield
*   **Emit**: Used in `Bloc`. It's a function `emit(NewState())`. It's safe and works well with async code.
*   **Yield**: Used in `async*` generators (Stream generators). It's the native Dart way to output data to a stream.
*   **Context**: Older Bloc versions used `mapEventToState` which was `async*` and used `yield`. Modern Bloc uses `on<Event>` handlers with `emit`.

## 11. Async, Await, Async*
*   **async**: Marks a function that returns a `Future`. Allows using `await`.
*   **await**: Pauses code execution until the Future completes.
*   **async***: Marks a function that returns a `Stream`. Allows using `yield` to push multiple values.
