with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/ClarityPulseApp.swift', 'r') as f:
    content = f.read()

# Make sure we add .tint(.teal) to the WindowGroup or main view if not already there
# Actually, the user says "apply .tint(.teal) to the root MainTabView"
content = content.replace(
    'MainTabView()\n                        .environment(sessionManager)',
    'MainTabView()\n                        .environment(sessionManager)\n                        .tint(.teal)'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/ClarityPulseApp.swift', 'w') as f:
    f.write(content)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/MainTabView.swift', 'r') as f:
    content = f.read()

content = content.replace('.tint(Color(hex: "#2C3E50"))', '.tint(.teal)')
content = content.replace('.tint(.primary)', '.tint(.teal)')

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/MainTabView.swift', 'w') as f:
    f.write(content)
