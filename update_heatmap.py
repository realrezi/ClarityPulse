import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ConsistencyHeatmapView.swift', 'r') as f:
    content = f.read()

# 1. State for animation
content = content.replace(
    'let results: [ExerciseResult]',
    'let results: [ExerciseResult]\n    @State private var isLoaded = false'
)

# 2. Text color
content = content.replace(
    '.foregroundColor(Color(hex: "#2C3E50"))',
    '.foregroundColor(.primary)'
)

# 3. Cell color and opacity animation
content = content.replace(
    '.fill(Color(hex: "#2C3E50"))\n                        .opacity(opacity(for: count))',
    '.fill(Color.teal)\n                        .opacity(isLoaded ? opacity(for: count) : 0)'
)

# 4. Background and animation trigger
content = content.replace(
    '.background(Color.white.opacity(0.7))\n        .cornerRadius(16)',
    '.background(.regularMaterial)\n        .cornerRadius(16)\n        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))\n        .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)\n        .onAppear {\n            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {\n                isLoaded = true\n            }\n        }'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ConsistencyHeatmapView.swift', 'w') as f:
    f.write(content)
