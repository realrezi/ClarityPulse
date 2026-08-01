import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ExperimentsView.swift', 'r') as f:
    content = f.read()

# Replace background gradient
content = re.sub(
    r'LinearGradient\(\s*colors: \[Color\(hex: "#DCEBDE"\), Color\(hex: "#E1EBF5"\)\],\s*startPoint: \.top,\s*endPoint: \.bottom\s*\)',
    'Color(uiColor: .systemGroupedBackground)',
    content
)

# Update noActiveTrialCard
old_no_active_card = """    private var noActiveTrialCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "flask")
                .font(.system(size: 48))
                .foregroundColor(Color(hex: "#2C3E50"))
                .padding(.bottom, 8)
            
            Text("No Active Trial")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#2C3E50"))
            
            Text("Run a 7-day A/B test to discover what actually improves your cognitive performance.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#2C3E50").opacity(0.8))
                .padding(.horizontal)
            
            Button(action: {"""

new_no_active_card = """    private var noActiveTrialCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "flask")
                .font(.system(size: 48))
                .foregroundColor(.primary)
                .padding(.bottom, 8)
            
            Text("No Active Trial")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Run a 7-day A/B test to discover what actually improves your cognitive performance.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                
            VStack(alignment: .leading, spacing: 12) {
                Text("How it Works")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 4)
                
                HStack(alignment: .top) {
                    Image(systemName: "1.circle.fill").foregroundColor(.accentColor)
                    Text("Tag your daily state (e.g., Fasted vs. Fed).").font(.subheadline).foregroundColor(.secondary)
                }
                HStack(alignment: .top) {
                    Image(systemName: "2.circle.fill").foregroundColor(.accentColor)
                    Text("Play your daily sessions for 7 days.").font(.subheadline).foregroundColor(.secondary)
                }
                HStack(alignment: .top) {
                    Image(systemName: "3.circle.fill").foregroundColor(.accentColor)
                    Text("Discover which state maximizes your cognitive speed and accuracy.").font(.subheadline).foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            Button(action: {"""

content = content.replace(old_no_active_card, new_no_active_card)

# Replace all hex navy with Color.primary, .secondary, or .accentColor where appropriate
content = content.replace('Color(hex: "#2C3E50").opacity(0.8)', 'Color.secondary')
content = content.replace('Color(hex: "#2C3E50").opacity(0.7)', 'Color.secondary')
content = content.replace('Color(hex: "#2C3E50").opacity(0.5)', 'Color.secondary')
content = content.replace('Color(hex: "#2C3E50").opacity(0.2)', 'Color.secondary.opacity(0.2)')
content = content.replace('Color(hex: "#2C3E50")', 'Color.primary')

# Replace ultraThinMaterial and white backgrounds with .secondarySystemGroupedBackground
content = content.replace('.background(.ultraThinMaterial)', '.background(Color(uiColor: .secondarySystemGroupedBackground))')
content = content.replace('.background(Color.white.opacity(0.5))', '.background(Color(uiColor: .tertiarySystemGroupedBackground))')

# Change "View Insights" button background from .primary to .accentColor
content = content.replace('.background(Color.primary)', '.background(Color.accentColor)')

# Change "Start New Trial" button background
content = content.replace("""                Text("Start New Trial")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)""", """                Text("Start New Trial")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)""")

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ExperimentsView.swift', 'w') as f:
    f.write(content)
