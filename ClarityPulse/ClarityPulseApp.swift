import SwiftUI
import SwiftData

@main
struct ClarityPulseApp: App {
    @AppStorage("hasSeenDisclaimer") private var hasSeenDisclaimer: Bool = false
    
    // Inject the session manager globally
    @State private var sessionManager = ActiveSessionManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenDisclaimer {
                    SplashView()
                        .environment(sessionManager)
                        .tint(.teal)
                } else {
                    DisclaimerView()
                }
            }
             // Dark Mode safety for pastel colors
        }
        .modelContainer(for: [UserSession.self, ExerciseResult.self, MicroTrial.self])
    }
}
