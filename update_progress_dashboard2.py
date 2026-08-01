import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ProgressDashboardView.swift', 'r') as f:
    content = f.read()

# 1. Update major headers
content = content.replace(
    'Text("Your Cognitive Journey")\n                        .font(.largeTitle)\n                        .fontWeight(.bold)',
    'Text("Your Cognitive Journey")\n                        .font(.largeTitle)\n                        .fontDesign(.rounded)\n                        .fontWeight(.bold)'
)
content = content.replace('.font(.headline)', '.font(.headline)\n                                .fontDesign(.rounded)')

# 2. Update all secondarySystemGroupedBackground cards to use glassmorphism
# Case 1: radius 16
content = content.replace(
    '.background(Color(uiColor: .secondarySystemGroupedBackground))\n                            .cornerRadius(16)',
    '.background(.regularMaterial)\n                            .cornerRadius(16)\n                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))\n                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)'
)
# Case 2: radius 12 (Recent Sessions)
content = content.replace(
    '.background(Color(uiColor: .secondarySystemGroupedBackground))\n                                .cornerRadius(12)',
    '.background(.regularMaterial)\n                                .cornerRadius(12)\n                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))\n                                .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)'
)

# 3. Update Chart colors to .teal if necessary
content = content.replace('.foregroundStyle(.blue)', '.foregroundStyle(.teal)')

# 4. Add monospaced digit to Recent Sessions
content = content.replace(
    'Text("Accuracy: \\(Int(result.accuracyPercentage))%")\n                                            .font(.caption)',
    'Text("Accuracy: \\(Int(result.accuracyPercentage))%")\n                                            .font(.caption)\n                                            .monospacedDigit()'
)
content = content.replace(
    'Text("Speed: \\(Int(result.averageReactionTimeMS)) ms")\n                                            .font(.caption)',
    'Text("Speed: \\(Int(result.averageReactionTimeMS)) ms")\n                                            .font(.caption)\n                                            .monospacedDigit()'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ProgressDashboardView.swift', 'w') as f:
    f.write(content)
