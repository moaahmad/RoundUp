# StarlingRoundUp

StarlingRoundUp is an iOS application that leverages the [Starling Bank API](https://developer.starlingbank.com/docs) to help users save more effectively. The app aggregates all transactions within a given week, rounds each transaction up to the nearest pound, and allows users to allocate the rounded-up amount to one of their savings goals.

**Please note: Before running the app, please add the API Access Token for your customer to `Debug.xcconfig` otherwise a `fatalError` will be thrown. Unit tests can still be run without the token configured.**

## Requirements

These requirements were derived from the project challenge document and additional considerations for a seamless user experience:

- [x] Display the user's account information, balance, and transactions.
- [x] Inform the user when transactions are empty.
- [x] Display the user's savings goals and notify them if there are none.
- [x] Allow the creation of savings goals within the app.
- [x] Enable users to round up their transactions from a given week and allocate the total to a selected savings goal.
- [x] Show appropriate alerts for any errors encountered during operations.

## Technical Specifications

- **Frameworks**: UIKit and Combine are used extensively throughout the app to manage UI elements and handle asynchronous data streams.
- **iOS Deployment Target**: 15.2 (N-2 compatibility)
- **Development Environment**: Xcode 15+ is required for compiling and running the application.
- **Code Quality**: [SwiftLint](https://github.com/realm/SwiftLint) is used as a code linter to enforce consistent coding standards and improve code quality across the project.
- **Constraints Management**: The app uses [SnapKit](https://github.com/SnapKit/SnapKit) for concise and readable Auto Layout constraints, simplifying UI layout management and reducing boilerplate code.

## Known Issues

- **Round Up**:
  - It's currently possible to present the `RoundUpViewController` with a total of £0.00 (e.g., if the transactions do not fall within the current week) and still attempt to save this amount to a savings goal. The app alerts the user that the amount must be positive, but the overall user experience could be enhanced by preventing the save action when the total is zero.  

- **Savings Goals Feed**:
  - Swipe-to-delete functionality is not yet implemented for individual savings goals. This would enhance user experience by allowing easy removal of unwanted goals directly from the feed.
  
- **Create Savings Goal**:
  - The current implementation of `targetAmountTextField` in `CreateSavingsGoalsViewController` currently has basic logic to restrict inputs to valid numeric values. More validation and testing is required to ensure no invalid or undesired data is allowed.
  
## Future Improvements

- Enhance the UI/UX with additional animations and micro-interactions to improve user engagement.
- Expand unit test coverage to additional features beyond the Home feature, Networking stack, and round-up calculations.
- Comprehensive error handling across the app allowing users to retry network calls etc.
- To enhance code organisation, scalability, and reusability, the app should be modularised by moving distinct groups of code, such as Coordinators, Design components, and Networking logic, into their own modules. This can be achieved using Swift Packages, which would allow for a more maintainable project structure, better separation of concerns, and the ability to reuse or replace modules independently across different parts of the app or in future projects.
- VoiceOver support has not yet been implemented. However, the app leverages system fonts and colours, which align with built-in accessibility features like Dynamic Type and system-wide colour adjustments for better readability and user experience.
- Snapshot testing and UI testing to ensure a consistent and reliable user interface.
- iPad support for a broader range of devices. 

## Unit Testing and Coverage

- **Unit Test Coverage**: Due to time constraints, unit tests were primarily included for key components of the application:
- **Home Feature**: Tests ensure that the Home ViewModel, Service, and Coordinator all behave as they should, validating the flow of data, user interactions, and navigation logic.
- **Networking Stack**: Tests validate the networking logic, including the HTTP client and response handling, ensuring that the app communicates correctly with the Starling Bank API.
- **Round-Up Calculations**: Tests cover the round-up functionality, verifying that transactions are accurately rounded up to the nearest pound and properly calculated for savings goals.

Although comprehensive coverage across all features was not possible within the timeframe, the implemented tests focus on critical paths to ensure reliability and correctness of the core functionality.

## Architecture

The app is built using the Model-View-ViewModel-Coordinator (MVVM-C) architecture, which provides a clear separation of concerns and a scalable codebase:

- **Model**: Represents the data structures. Models are responsible for data management and manipulation, often interacting with services or APIs.
  
- **View**: Responsible for presenting UI elements and handling user interactions. Views are kept as simple as possible and do not contain business logic. They are bound to ViewModels which supply the data needed for display.

- **ViewModel**: Acts as a mediator between the Model and the View. It handles business logic, data formatting, and communicates with the View to update UI elements. ViewModels also respond to user actions from the View and provide the necessary data through binding mechanisms like Combine.

- **Coordinator**: Manages the navigation flow of the app. Coordinators handle the presentation logic, such as showing new screens or dismissing existing ones, thereby decoupling navigation responsibilities from ViewControllers and ViewModels. This approach improves the reusability of Views and ViewModels and helps keep them focused on their core tasks without being cluttered by navigation code.

  - **Benefits of MVVM-C**:
    - **Separation of Concerns**: MVVM-C enforces a clear separation of UI, business logic, and navigation, making the codebase more maintainable and testable.
    - **Reusability**: ViewModels can be reused across different Views, and Coordinators can manage complex navigation flows.
    - **Scalability**: The architecture scales well with the app's growth, allowing the addition of new features with minimal impact on existing components.
    - **Testability**: The clear separation between ViewModels and Views makes it easier to unit test business logic without dealing with UI code.
