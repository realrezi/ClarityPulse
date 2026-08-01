import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/RadarChartView.swift', 'r') as f:
    content = f.read()

content = content.replace('Color(hex: "#2C3E50").opacity(0.3)', 'Color.teal.opacity(0.3)')
content = content.replace('Color(hex: "#2C3E50")', 'Color.teal')
# But wait, there is a `.foregroundColor(Color(hex: "#2C3E50"))` at the end which should be `.primary`
content = content.replace('.foregroundColor(Color.teal)', '.foregroundColor(.primary)')
# And the axes strokes: 
content = content.replace('.stroke(Color.teal.opacity(0.3), lineWidth: 1)', '.stroke(Color.primary.opacity(0.2), lineWidth: 1)')

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/RadarChartView.swift', 'w') as f:
    f.write(content)
