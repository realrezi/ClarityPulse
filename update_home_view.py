import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'r') as f:
    content = f.read()

# Replace background gradient
content = re.sub(
    r'LinearGradient\(\s*colors: \[Color\(hex: "#DCEBDE"\), Color\(hex: "#E1EBF5"\)\],\s*startPoint: \.top,\s*endPoint: \.bottom\s*\)',
    'Color(uiColor: .systemGroupedBackground)',
    content
)

# Fix title
old_title = """                    Text("Clear the fog. Return to your best self.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#2C3E50"))
                        .padding(.horizontal)
                        .minimumScaleFactor(0.8)"""

new_title = """                    Text("Clear the fog. Return to your best self.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)"""
content = content.replace(old_title, new_title)

# Update "Log Daily Session" button styling
old_hero_btn = """                        Button(action: {
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
                        }"""

new_hero_btn = """                        Button(action: {
                            HapticManager.playLightImpact()
                            activeConfig = .nback
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Log Daily Session")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text("Test your baseline today")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                Spacer()
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            .padding(20)
                            .background(
                                LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(20)
                            .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                        }"""
content = content.replace(old_hero_btn, new_hero_btn)

# Replace remaining Color(hex: "#2C3E50") with Color.primary
content = content.replace('Color(hex: "#2C3E50")', 'Color.primary')

# Replace N-Back and Stroop cards backgrounds and shadows
content = content.replace('.background(Color.white.opacity(0.6))', '.background(Color(uiColor: .secondarySystemGroupedBackground))')
content = content.replace('.shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)', '.shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)')

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'w') as f:
    f.write(content)
