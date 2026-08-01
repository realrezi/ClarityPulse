with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ExperimentsView.swift', 'r') as f:
    content = f.read()

# Fix @Query properties
content = content.replace(
    '@Query private var trials: [MicroTrial]',
    '@Query var trials: [MicroTrial]'
)
content = content.replace(
    '@Query(sort: \\ExerciseResult.date, order: .reverse) private var exerciseResults: [ExerciseResult]',
    '@Query var exerciseResults: [ExerciseResult]'
)

# Fix date filtering
content = content.replace(
    'let relevantSessions = exerciseResults.filter { $0.date >= trial.startDate && $0.date <= Date() }',
    'let relevantSessions = exerciseResults.filter { ($0.session?.date ?? Date.distantPast) >= trial.startDate && ($0.session?.date ?? Date.distantPast) <= Date() }'
)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/ExperimentsView.swift', 'w') as f:
    f.write(content)
