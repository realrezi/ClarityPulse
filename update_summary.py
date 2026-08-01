import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/SessionSummaryView.swift', 'r') as f:
    content = f.read()

# 1. Background
content = content.replace(
    'LinearGradient(\n                colors: [Color(hex: "#DCEBDE"), Color(hex: "#E1EBF5")],\n                startPoint: .top,\n                endPoint: .bottom\n            )',
    'Color(uiColor: .systemGroupedBackground)'
)

# 2. Header
content = content.replace(
    'Text("\\(result.exerciseType) Complete")\n                    .font(.largeTitle)\n                    .fontWeight(.bold)\n                    .foregroundColor(Color(hex: "#2C3E50"))',
    'Text("\\(result.exerciseType) Complete")\n                    .font(.largeTitle)\n                    .fontDesign(.rounded)\n                    .fontWeight(.bold)\n                    .foregroundColor(.primary)'
)

# 3. Done Button
old_done_btn = """                Button(action: onDone) {
                    Text("Done")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2C3E50"))
                        .cornerRadius(16)
                }"""
new_done_btn = """                Button(action: {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onDone()
                }) {
                    Text("Done")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
                .cornerRadius(16)"""
content = content.replace(old_done_btn, new_done_btn)

# 4. Summary Cards text and background
content = content.replace('Color(hex: "#2C3E50")', 'Color.primary')
content = content.replace(
    '.background(Color.white.opacity(0.6))\n        .cornerRadius(16)',
    '.background(.regularMaterial)\n        .cornerRadius(16)\n        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))\n        .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)'
)

# 5. Monospaced digit on values
content = content.replace(
    'Text(value)\n                .font(.title3)\n                .fontWeight(.bold)',
    'Text(value)\n                .font(.title3)\n                .fontWeight(.bold)\n                .monospacedDigit()'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/SessionSummaryView.swift', 'w') as f:
    f.write(content)
