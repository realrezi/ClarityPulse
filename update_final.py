import re

# 1. Update ClarityPulseApp.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/ClarityPulseApp.swift', 'r') as f:
    app_content = f.read()

# Remove .preferredColorScheme(.light)
app_content = app_content.replace('.preferredColorScheme(.light)', '')
# Replace MainTabView() with SplashView()
app_content = app_content.replace('MainTabView()', 'SplashView()')

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/ClarityPulseApp.swift', 'w') as f:
    f.write(app_content)

# 2. Update DisclaimerView.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/DisclaimerView.swift', 'r') as f:
    disclaimer_content = f.read()

disclaimer_content = disclaimer_content.replace('hasSeenDisclaimer', 'hasAcceptedDisclaimer')
# Remove .background(Color.blue) and replace with .buttonStyle(.borderedProminent) .tint(.teal) for consistency
old_btn = """                    Text("I Understand")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)"""
new_btn = """                    Text("I Understand")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
"""
disclaimer_content = disclaimer_content.replace(old_btn, new_btn)
disclaimer_content = disclaimer_content.replace(
    '}\n                .padding(.horizontal, 40)',
    '}\n                .buttonStyle(.borderedProminent)\n                .tint(.teal)\n                .cornerRadius(12)\n                .padding(.horizontal, 40)'
)

# Add footer
footer = """                Spacer()
                
                Text("Designed & Engineered by Ahmadreza Shirdel, MD")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
"""
disclaimer_content = disclaimer_content.replace(
    '            }\n            .padding()',
    footer + '            }\n            .padding()'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/DisclaimerView.swift', 'w') as f:
    f.write(disclaimer_content)

# 3. Update MainTabView.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/MainTabView.swift', 'r') as f:
    maintab_content = f.read()

maintab_content = maintab_content.replace(
    'struct MainTabView: View {',
    'struct MainTabView: View {\n    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false'
)

# Add fullScreenCover to TabView
maintab_content = maintab_content.replace(
    '.tint(.teal)',
    '.tint(.teal)\n        .fullScreenCover(isPresented: Binding(get: { !hasAcceptedDisclaimer }, set: { _ in })) {\n            DisclaimerView()\n        }'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/MainTabView.swift', 'w') as f:
    f.write(maintab_content)

# 4. Update HomeView.swift
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'r') as f:
    home_content = f.read()

footer_home = """                    Text("ClarityPulse • Ahmadreza Shirdel, MD")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.top, 24)
                        .padding(.bottom, 40)
"""
home_content = home_content.replace(
    '                }\n            }\n            .navigationTitle("Dashboard")',
    '                }\n' + footer_home + '            }\n            .navigationTitle("Dashboard")'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/HomeView.swift', 'w') as f:
    f.write(home_content)

