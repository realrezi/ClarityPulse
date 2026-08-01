import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ProgressDashboardView.swift', 'r') as f:
    content = f.read()

# Replace background gradient
content = re.sub(
    r'LinearGradient\(\s*colors: \[Color\(hex: "#DCEBDE"\), Color\(hex: "#E1EBF5"\)\],\s*startPoint: \.top,\s*endPoint: \.bottom\s*\)',
    'Color(uiColor: .systemGroupedBackground)',
    content
)

# Replace all hex navy with Color.primary
content = content.replace('Color(hex: "#2C3E50")', 'Color.primary')

# Replace background ultraThinMaterial
content = content.replace('.background(.ultraThinMaterial)', '.background(Color(uiColor: .secondarySystemGroupedBackground))')
content = content.replace('.background(Color.white.opacity(0.7))', '.background(Color(uiColor: .secondarySystemGroupedBackground))')
content = content.replace('.background(Color.white.opacity(0.5))', '.background(Color(uiColor: .secondarySystemGroupedBackground))')

# Update Archetype UI
old_archetype = """                                if let archetype = ArchetypeEngine.calculate(results: results) {
                                    Text(archetype)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.primary)
                                } else {"""

new_archetype = """                                if let archetype = ArchetypeEngine.calculate(results: results) {
                                    VStack(spacing: 12) {
                                        Image(systemName: archetype.icon)
                                            .font(.system(size: 40))
                                            .foregroundColor(.accentColor)
                                        Text(archetype.title)
                                            .font(.system(.title2, design: .rounded).weight(.heavy))
                                            .foregroundColor(.primary)
                                        Text(archetype.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                } else {"""

content = content.replace(old_archetype, new_archetype)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ProgressDashboardView.swift', 'w') as f:
    f.write(content)
