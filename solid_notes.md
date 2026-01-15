# SOLID Principles Learning Journey
*Interactive notes for the QR Code Generator & Scanner Project*

## Introduction
SOLID is a set of five design principles intended to make software designs more understandable, flexible, and maintainable.
- **S** - Single Responsibility Principle
- **O** - Open/Closed Principle
- **L** - Liskov Substitution Principle
- **I** - Interface Segregation Principle
- **D** - Dependency Inversion Principle

---

## 1. Single Responsibility Principle (SRP)
**"A class should have one, and only one, reason to change."**

### Theory
Every module, class, or function should have responsibility over a single part of the functionality provided by the software.

### In Our Project
- **Bad Practice**: A single `QrBloc` that calculates QR data, saves to file, AND manages UI state for the scanner.
- **Good Practice**: 
    - `QrGeneratorRepository`: Handles data generation logic.
    - `StorageRepository`: Handles file saving.
    - `QrGenerateBloc`: Manages the UI state for the generator screen, delegating work to the repositories.

### Notes & Observations
*(Add your learning notes here as we implement features)*

---

## 2. Open/Closed Principle (OCP)
**"Entities should be open for extension, but closed for modification."**

### Theory
You should be able to add new functionality without changing existing code.

### In Our Project
- **Bad Practice**: A `QrStyleRenderer` widget with a big `switch` statement for styles.
- **Good Practice**: An abstract `QrStyle` class. We can create `GradientQrStyle`, `DotQrStyle`, etc. The renderer accepts `QrStyle` and works with any subclass without modification.

---

## 3. Liskov Substitution Principle (LSP)
**"Subtypes must be substitutable for their base types."**

### Theory
Objects of a superclass shall be replaceable with objects of its subclasses without breaking the application.

### In Our Project
If we have an abstract `ScannerRepository` and a `MobileScannerRepository`, the UI should be able to use `MobileScannerRepository` seamlessly. It shouldn't unexpectedly throw "NotImplemented" errors or require specific setup that the base interface doesn't document.

---

## 4. Interface Segregation Principle (ISP)
**"Clients should not be forced to depend upon interfaces that they do not use."**

### Theory
Many client-specific interfaces are better than one general-purpose interface.

### In Our Project
- **Bad Practice**: A giant `IAppRepository` containing methods for QR generation, Scanning, Settings, and Auth.
- **Good Practice**: Split into specific interfaces:
    - `IQrGenerator`
    - `IScanner`
    - `ISettings`
    The `ScannerBloc` only needs `IScanner`, not the rest.

---

## 5. Dependency Inversion Principle (DIP)
**"Depend upon abstractions, not concretions."**

### Theory
High-level modules should not depend on low-level modules. Both should depend on abstractions.

### In Our Project
- **Bad Practice**: Our BLoC directly instantiates `SharedPreferencesStorage`. `final storage = SharedPreferencesStorage();`
- **Good Practice**: 
    1. Define an interface `IStorageRepository`.
    2. The BLoC accepts `IStorageRepository` in its constructor.
    3. **Dependency Injection**: We use `RepositoryProvider` (from `flutter_bloc`) at the top of our widget tree to inject the concrete implementation (`SharedPreferencesStorage`) into the BLoC.
