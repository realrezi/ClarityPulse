# Data Models & Storage Schema
## Local Device Storage (SwiftData - iOS 17+)

### Model 1: UserSession (@Model)
*   `id` (UUID) 
*   `date` (Date)
*   `durationSeconds` (Int)
*   `@Relationship(deleteRule: .cascade) var results: [ExerciseResult]?` - CRITICAL: Must be Optional to avoid iOS 17/18 Observation bugs.

### Model 2: ExerciseResult (@Model)
*   `id` (UUID)
*   `exerciseType` (String)
*   `accuracyPercentage` (Double)
*   `averageReactionTimeMS` (Double)
*   `session` (UserSession?) - Optional backlink.

### The Concurrency & Memory Rule (iOS 18 Hardened)
1. Create an `@Observable` class `ActiveSessionManager` to hold `accuracy` and `reactionTimeMS` in memory while the timer runs. This class must only hold primitive data types to prevent iOS 18 "dirty memory" terminations.
2. When the exercise finishes, use a `@ModelActor` to safely batch-save the `UserSession` and its `ExerciseResult`s in the background.

### JSON Data Structure (Bundled Asset)
`quotes.json` file structured as: `[ { "id": "UUID", "text": "Quote string", "category": "Relaxation" } ]`