import re

# Update ClarityPulseApp.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/ClarityPulseApp.swift', 'r') as f:
    app = f.read()

app = app.replace(
    '        .modelContainer(for: [UserSession.self, ExerciseResult.self])',
    '        .modelContainer(for: [UserSession.self, ExerciseResult.self, MicroTrial.self])'
)
app = app.replace(
    """                if hasSeenDisclaimer {
                    HomeView()
                        .environment(sessionManager)
                } else {""",
    """                if hasSeenDisclaimer {
                    MainTabView()
                        .environment(sessionManager)
                } else {"""
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/ClarityPulseApp.swift', 'w') as f:
    f.write(app)

# Update HomeView.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'r') as f:
    home = f.read()

old_hero_card = """                        NavigationLink(destination: ProgressDashboardView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Cognitive Dashboard")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#2C3E50"))
                                    Text("View your progress and insights")
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: "#2C3E50").opacity(0.8))
                                }
                                Spacer()
                                Image(systemName: "chart.xyaxis.line")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "#2C3E50"))
                            }
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        .simultaneousGesture(TapGesture().onEnded { HapticManager.playLightImpact() })
                        .accessibilityLabel("View Progress Dashboard")"""

new_hero_card = """                        Button(action: {
                            HapticManager.playLightImpact()
                            activeConfig = .nback
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Log Daily Session")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#2C3E50"))
                                    Text("Test your baseline today")
                                        .font(.subheadline)
                                        .foregroundColor(Color(hex: "#2C3E50").opacity(0.8))
                                }
                                Spacer()
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "#2C3E50"))
                            }
                            .padding(20)
                            .background(.ultraThinMaterial)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        .accessibilityLabel("Log Daily Session")"""

if old_hero_card in home:
    home = home.replace(old_hero_card, new_hero_card)
else:
    print("Could not find old hero card!")

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'w') as f:
    f.write(home)

