# Antigravity Agent Prompting Guide

Use these structured, atomic prompts to guide the agent step-by-step.

### Phase 1: Regulatory Onboarding & Project Setup
**Prompt:** "Create a new iOS Xcode project named 'ClarityPulse' using Swift and SwiftUI for iOS 17.0. Set the App Category to 'Lifestyle'. Create a `DisclaimerView` with this text: 'This app is designed for educational and wellness purposes only and is not intended to diagnose, treat, or cure any medical condition. Our daily wellness quotes are curated offline using AI. No personal data ever leaves your device.' Add an 'I Understand' button that toggles an `@AppStorage("hasSeenDisclaimer")` boolean to true. Make this the root view if false. Ensure all text strictly uses SwiftUI Dynamic Type modifiers."

### Phase 2: JSON Parsing & Calm Home Screen
**Prompt:** "Create a `quotes.json` file in the bundle with 5 placeholder relaxing quotes. Write an asynchronous Swift service to decode this in the background. Build a `HomeView` with a linear gradient background from `#DCEBDE` to `#E1EBF5`. Prominently feature the subtitle/motto text: 'Clear the fog. Return to your best self.' Display a random daily quote and a 'Start Daily Exercises' button using `#2C3E50` for the text and button fills."

### Phase 3: The Data Layer & Concurrency
**Prompt:** "Implement SwiftData. Create `@Model` classes: 'ExerciseResult' and 'UserSession'. CRITICAL: Make the `[ExerciseResult]` array inside `UserSession` Optional. Create an `@Observable` class `ActiveSessionManager` to track reaction times purely in memory using strictly primitive types. Write a `@ModelActor` that takes data from `ActiveSessionManager` at the end of a session and batch-inserts it into the database off the main thread."

### Phase 4: Adaptive N-Back Exercise (Hardware-Synced)
**Prompt:** "Build a SwiftUI View for an N-Back working memory exercise bound to `ActiveSessionManager`. Use STRICTLY native SF Symbols (no custom images) for visual stimuli. Use a `Combine` publisher for the 2-second timer, and manually call `.cancel()` in `onDisappear` to prevent memory leaks. Track reaction times using `DispatchTime.now().uptimeNanoseconds`, NOT the UI Date. If accuracy drops below 60%, automatically reduce 'N' by 1. Use `.sensoryFeedback(.success)` when correct, and `.warning` when incorrect."

### Phase 5: Feedback & Swift Charts Reporting
**Prompt:** "Build a `ProgressDashboardView` using the `Swift Charts` framework. Create a simple line chart mapping the user's `averageReactionTimeMS` over their past sessions. In this same summary view, implement `@Environment(\.requestReview)` to call the StoreKit review prompt ONLY IF `@AppStorage("totalSessionsCompleted")` equals exactly 5."

### Phase 6: Gentle Retention (Local Notifications)
**Prompt:** "Implement the `UserNotifications` framework. Create a manager that requests permission. When a `UserSession` successfully saves, schedule exactly ONE local push notification for 24 hours later with the text: 'Your daily moment of calm and cognitive wellness is ready.' Explicitly clear any pending notifications before scheduling the new one."