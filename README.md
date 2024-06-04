# The Minute, a one-minute timer app using SwiftUI and Combine

This app is a simple one-minute timer, with time display in minutes : seconds : milliseconds, and an animated ring for progress.

It uses SwiftUI for creating its views, and the Combine framework for logic implementation.
Basic dependency injection via constructors is used, but if the project got larger a more robust solution such as Swinject could be employed.
The notification handling is built into a NotificationService, which also has a mock version for use in Preview.
The ring uses built-in SwiftUI animation, whereas the time display uses a 10-millisecond periodic timer.
