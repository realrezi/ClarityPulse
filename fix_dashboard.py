import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ProgressDashboardView.swift', 'r') as f:
    content = f.read()

# Replace query
content = re.sub(
    r'@Query\(sort: \\UserSession\.date, order: \.reverse\) private var sessions: \[UserSession\]',
    '@Query private var results: [ExerciseResult]\n    \n    private var sortedResults: [ExerciseResult] {\n        results.sorted { ($0.session?.date ?? Date.distantPast) > ($1.session?.date ?? Date.distantPast) }\n    }',
    content
)

# Replace sessions.isEmpty
content = content.replace('if sessions.isEmpty {', 'if results.isEmpty {')

# Add Heatmap and Archetype
replacement_heatmap = """
                    } else {
                        ConsistencyHeatmapView(results: results)
                        
                        Divider()
                            .padding(.vertical)
                        
                        VStack(spacing: 8) {
                            Text("Cognitive Archetype")
                                .font(.headline)
                                .foregroundColor(Color(hex: "#2C3E50"))
                                .padding(.horizontal)
                                .accessibilityAddTraits(.isHeader)
                            
                            VStack {
                                if let archetype = ArchetypeEngine.calculate(results: results) {
                                    Text(archetype)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#2C3E50"))
                                } else {
                                    Text("Complete 5 Stroop sessions to unlock your Cognitive Archetype.")
                                        .font(.subheadline)
                                        .italic()
                                        .foregroundColor(Color(hex: "#2C3E50").opacity(0.8))
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.vertical)
                            
                        let chartData = extractChartData()
"""

content = content.replace('                    } else {\n                        let chartData = extractChartData()', replacement_heatmap)

# Replace extractChartData
old_extract = """    private func extractChartData() -> [ChartDataPoint] {
        sessions.compactMap { session in
            guard let results = session.results, !results.isEmpty else { return nil }
            let averageTime = results.reduce(0) { $0 + $1.averageReactionTimeMS } / Double(results.count)
            let averageAccuracy = results.reduce(0) { $0 + $1.accuracyPercentage } / Double(results.count)
            return ChartDataPoint(date: session.date, reactionTime: averageTime, accuracy: averageAccuracy)
        }
    }"""
new_extract = """    private func extractChartData() -> [ChartDataPoint] {
        sortedResults.reversed().compactMap { result in
            guard let date = result.session?.date else { return nil }
            return ChartDataPoint(date: date, reactionTime: result.averageReactionTimeMS, accuracy: result.accuracyPercentage)
        }
    }"""
content = content.replace(old_extract, new_extract)

# Replace Radar Chart Properties
content = re.sub(
    r'private var nBackAccuracyValue: Double \{[\s\S]*?\}',
    """private var nBackAccuracyValue: Double {
        let nBackResults = results.filter { $0.exerciseType.contains("Back") }
        guard !nBackResults.isEmpty else { return 0.0 }
        let avg = nBackResults.map { $0.accuracyPercentage }.reduce(0, +) / Double(nBackResults.count)
        return avg / 100.0
    }""",
    content,
    count=1
)

content = re.sub(
    r'private var nBackLevelValue: Double \{[\s\S]*?\}',
    """private var nBackLevelValue: Double {
        let nBackResults = results.filter { $0.exerciseType.contains("Back") }
        guard !nBackResults.isEmpty else { return 0.0 }
        let levels = nBackResults.compactMap { result -> Double? in
            guard let firstChar = result.exerciseType.first, let level = Double(String(firstChar)) else { return nil }
            return level
        }
        let avg = levels.reduce(0, +) / Double(max(1, levels.count))
        return avg / 5.0
    }""",
    content,
    count=1
)

content = re.sub(
    r'private var stroopAccuracyValue: Double \{[\s\S]*?\}',
    """private var stroopAccuracyValue: Double {
        let stroopResults = results.filter { $0.exerciseType == "Stroop" }
        guard !stroopResults.isEmpty else { return 0.0 }
        let avg = stroopResults.map { $0.accuracyPercentage }.reduce(0, +) / Double(stroopResults.count)
        return avg / 100.0
    }""",
    content,
    count=1
)

content = re.sub(
    r'private var stroopRTValue: Double \{[\s\S]*?\}',
    """private var stroopRTValue: Double {
        let stroopResults = results.filter { $0.exerciseType == "Stroop" }
        guard !stroopResults.isEmpty else { return 0.0 }
        let avg = stroopResults.map { $0.averageReactionTimeMS }.reduce(0, +) / Double(stroopResults.count)
        if avg == 0 { return 0.0 }
        let maxRT = 1500.0
        return max(0, 1.0 - (avg / maxRT))
    }""",
    content,
    count=1
)

# Update Recent Sessions List
old_recent = """                            ForEach(sessions.prefix(10)) { session in
                                if let result = session.results?.first {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Text(session.date.formatted(date: .abbreviated, time: .shortened))"""
new_recent = """                            ForEach(sortedResults.prefix(10)) { result in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text((result.session?.date ?? Date()).formatted(date: .abbreviated, time: .shortened))"""
content = content.replace(old_recent, new_recent)

# Also need to remove the extra bracket in old ForEach loop structure
content = re.sub(
    r'(<appDataDir>[ \t\n]+)\}\n([ \t]+)\.padding\(\)\n([ \t]+)\.background\(Color\.white\.opacity\(0\.7\)\)',
    r'\1.padding()\n\2.background(Color.white.opacity(0.7))',
    content
)
# Wait, replacing the ending brace is tricky via regex without full context. Let's do it manually with regex block replace.

old_recent_block = """                            ForEach(sessions.prefix(10)) { session in
                                if let result = session.results?.first {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            Text(session.date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.subheadline)
                                                .foregroundColor(Color(hex: "#2C3E50").opacity(0.8))
                                            Spacer()
                                            Text(result.exerciseType)
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(hex: "#2C3E50"))
                                        }
                                        
                                        HStack {
                                            Text("Accuracy: \\(Int(result.accuracyPercentage))%")
                                                .font(.caption)
                                                .foregroundColor(Color(hex: "#2C3E50"))
                                            Spacer()
                                            Text("Speed: \\(Int(result.averageReactionTimeMS)) ms")
                                                .font(.caption)
                                                .foregroundColor(Color(hex: "#2C3E50"))
                                        }
                                        
                                        if let tags = result.tags, !tags.isEmpty {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 8) {
                                                    ForEach(tags, id: \\.self) { tag in
                                                        Text(tag)
                                                            .font(.system(size: 10, weight: .semibold))
                                                            .padding(.horizontal, 8)
                                                            .padding(.vertical, 4)
                                                            .background(Color(hex: "#2C3E50").opacity(0.15))
                                                            .foregroundColor(Color(hex: "#2C3E50"))
                                                            .cornerRadius(8)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }"""

new_recent_block = """                            ForEach(sortedResults.prefix(10)) { result in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text((result.session?.date ?? Date()).formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundColor(Color(hex: "#2C3E50").opacity(0.8))
                                        Spacer()
                                        Text(result.exerciseType)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "#2C3E50"))
                                    }
                                    
                                    HStack {
                                        Text("Accuracy: \\(Int(result.accuracyPercentage))%")
                                            .font(.caption)
                                            .foregroundColor(Color(hex: "#2C3E50"))
                                        Spacer()
                                        Text("Speed: \\(Int(result.averageReactionTimeMS)) ms")
                                            .font(.caption)
                                            .foregroundColor(Color(hex: "#2C3E50"))
                                    }
                                    
                                    if result.exerciseType == "Stroop" && result.averageReactionTimeMS > 0 {
                                        Text(stroopBenchmarkText(for: result.averageReactionTimeMS))
                                            .font(.caption2)
                                            .italic()
                                            .foregroundColor(Color(hex: "#2C3E50").opacity(0.7))
                                    }
                                    
                                    if let tags = result.tags, !tags.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(tags, id: \\.self) { tag in
                                                    Text(tag)
                                                        .font(.system(size: 10, weight: .semibold))
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(Color(hex: "#2C3E50").opacity(0.15))
                                                        .foregroundColor(Color(hex: "#2C3E50"))
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }"""

content = content.replace(old_recent_block, new_recent_block)

# Add stroopBenchmarkText function
benchmark_fn = """    private func stroopBenchmarkText(for rt: Double) -> String {
        if rt == 0 { return "" }
        if rt < 400 { return "Elite / Fighter Pilot tier" }
        if rt <= 600 { return "High Cognitive Sharpness" }
        if rt <= 900 { return "Standard Baseline" }
        return "Fatigued / Slower Processing"
    }
"""

content = content.replace('    private func checkAndRequestReview() {', benchmark_fn + '\n    private func checkAndRequestReview() {')

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ProgressDashboardView.swift', 'w') as f:
    f.write(content)
