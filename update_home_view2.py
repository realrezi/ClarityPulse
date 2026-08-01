import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'r') as f:
    content = f.read()

# 1. Update Typography on Top Title
old_title = """                    Text("Clear the fog. Return to your best self.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)"""

new_title = """                    Text("Clear the fog. Return to your best self.")
                        .font(.title)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)"""
content = content.replace(old_title, new_title)

# 2. Update Log Daily Session Button
old_hero_btn = """                        Button(action: {
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

new_hero_btn = """                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            activeConfig = .nback
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Log Daily Session")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Test your baseline today")
                                        .font(.subheadline)
                                        .opacity(0.9)
                                }
                                Spacer()
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 40))
                            }
                            .padding(20)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.teal)
                        .cornerRadius(20)
                        .shadow(color: .teal.opacity(0.2), radius: 10, x: 0, y: 5)"""
content = content.replace(old_hero_btn, new_hero_btn)

# 3. Update N-Back and Stroop Cards
# They currently have:
# .background(Color(uiColor: .secondarySystemGroupedBackground))
# .cornerRadius(16)
# .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)

content = content.replace(
    '.background(Color(uiColor: .secondarySystemGroupedBackground))\n                                .cornerRadius(16)\n                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)',
    '.background(.regularMaterial)\n                                .cornerRadius(16)\n                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))\n                                .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)'
)

# Also update the coming soon cards
content = content.replace(
    '.background(Color.gray.opacity(0.1))\n                            .cornerRadius(16)',
    '.background(.regularMaterial)\n                            .cornerRadius(16)\n                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))\n                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)'
)

# 4. Haptics on NBack and Stroop buttons
content = content.replace('HapticManager.playLightImpact()', 'UIImpactFeedbackGenerator(style: .medium).impactOccurred()')

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'w') as f:
    f.write(content)
