# LocationSearch-in-SwiftUI-and-Composable-Architecture.

#### Simple Location search text field using SwiftUI and composable Architecture.

#### SwiftUI: 
SwiftUI is an innovative, exceptionally simple way to build user interfaces across all Apple platforms with the power of Swift. Build user interfaces for any Apple device using just one set of tools and APIs.

#### Composable Architecture: 
The Composable Architecture (TCA, for short) is a library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind. It can be used in SwiftUI, UIKit, and more, and on any Apple platform (iOS, macOS, tvOS, and watchOS).

To build a feature using the Composable Architecture you define some types and values that model your domain:

- State: A type that describes the data your feature needs to perform its logic and render its UI.
- Action: A type that represents all of the actions that can happen in your feature, such as user actions, notifications, event sources and more.
- Environment: A type that holds any dependencies the feature needs, such as API clients, analytics clients, etc.
- Reducer: A function that describes how to evolve the current state of the app to the next state given an action. The reducer is also responsible for returning any   effects that should be run, such as API requests, which can be done by returning an Effect value.
- Store: The runtime that actually drives your feature. You send all user actions to the store so that the store can run the reducer and effects, and you can     observe state changes in the store so that you can update UI.

#### Functionality:
- A small feature to learn composable architecture
- SwiftUI Practice
- Webservice implementation
- Error handling
- UI/State managements.
