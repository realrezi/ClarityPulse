import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ExperimentsView.swift', 'r') as f:
    content = f.read()

# 1. Update Buttons
# Start New Trial
old_start_btn = """            Button(action: {
                newTitle = ""
                newTagA = ""
                newTagB = ""
                showingNewTrialSheet = true
            }) {
                Text("Start New Trial")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(16)
            }"""
new_start_btn = """            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                newTitle = ""
                newTagA = ""
                newTagB = ""
                showingNewTrialSheet = true
            }) {
                Text("Start New Trial")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(.teal)"""
content = content.replace(old_start_btn, new_start_btn)

# View Insights
old_insights_btn = """                Button(action: {
                    insightMessage = generateInsights(for: trial)
                    showingInsights = true
                }) {
                    Text("View Insights")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(16)
                }"""
new_insights_btn = """                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    insightMessage = generateInsights(for: trial)
                    showingInsights = true
                }) {
                    Text("View Insights")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)"""
content = content.replace(old_insights_btn, new_insights_btn)

# 2. Update Card Backgrounds
content = content.replace(
    '.background(Color(uiColor: .secondarySystemGroupedBackground))\n        .cornerRadius(24)\n        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)',
    '.background(.regularMaterial)\n        .cornerRadius(24)\n        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))\n        .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)'
)
content = content.replace(
    '.background(Color(uiColor: .tertiarySystemGroupedBackground))\n            .cornerRadius(16)',
    '.background(.ultraThinMaterial)\n            .cornerRadius(16)\n            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))'
)
content = content.replace(
    '.background(Color(uiColor: .tertiarySystemGroupedBackground))\n            .cornerRadius(12)',
    '.background(.ultraThinMaterial)\n            .cornerRadius(12)\n            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))'
)

# 3. Monospaced Digits
content = content.replace(
    'Text("Day \\(min(elapsedDays + 1, 7)) of 7")\n                        .font(.subheadline)',
    'Text("Day \\(min(elapsedDays + 1, 7)) of 7")\n                        .font(.subheadline)\n                        .monospacedDigit()'
)

# 4. Font design
content = content.replace(
    'Text("No Active Trial")\n                .font(.title2)',
    'Text("No Active Trial")\n                .font(.title2)\n                .fontDesign(.rounded)'
)

# 5. Add animation to Form
content = content.replace(
    '}\n            .navigationTitle("New Micro-Trial")',
    '}\n            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: newTagA)\n            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: newTagB)\n            .navigationTitle("New Micro-Trial")'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ExperimentsView.swift', 'w') as f:
    f.write(content)
