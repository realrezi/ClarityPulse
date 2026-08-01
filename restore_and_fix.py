import re

# ==========================================
# 1. FIX NBackExerciseView.swift
# ==========================================
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/NBackExerciseView.swift', 'r') as f:
    nback = f.read()

# Restore the missing state variables if they are missing
if "@State private var exerciseTask" not in nback:
    print("NBack was mangled. Restoring state variables...")
    broken_state = "@State private var completedResult: ExerciseResult? = nil"
    restored_state = """    @State private var showSummary: Bool = false
    
    private let totalTrials = 20
    private let possibleSymbols = ["star.fill", "circle.fill", "square.fill", "triangle.fill", "heart.fill", "moon.fill"]
    
    @State private var currentTrial = 0
    @State private var symbolHistory: [String] = []
    @State private var currentSymbol: String = "questionmark.circle"
    @State private var correctAnswers = 0
    @State private var totalAnswered = 0
    @State private var totalReactionTimeNS: UInt64 = 0
    
    @State private var exerciseTask: Task<Void, Never>?
    @State private var isSymbolVisible: Bool = true
    @State private var stimulusAppearanceTime: UInt64 = 0
    
    @State private var triggerFeedback: Bool = false
    @State private var isLastCorrect: Bool = false
    
    @State private var completedResult: ExerciseResult? = nil"""
    nback = nback.replace(broken_state, restored_state)
else:
    # If they are there, just replace the summary vars
    old_vars = """    @State private var showSummary: Bool = false
    
    private let totalTrials = 20
    private let possibleSymbols = ["star.fill", "circle.fill", "square.fill", "triangle.fill", "heart.fill", "moon.fill"]
    
    @State private var currentTrial = 0
    @State private var symbolHistory: [String] = []
    @State private var currentSymbol: String = "questionmark.circle"
    @State private var correctAnswers = 0
    @State private var totalAnswered = 0
    @State private var totalReactionTimeNS: UInt64 = 0
    
    @State private var exerciseTask: Task<Void, Never>?
    @State private var isSymbolVisible: Bool = true
    @State private var stimulusAppearanceTime: UInt64 = 0
    
    @State private var triggerFeedback: Bool = false
    @State private var isLastCorrect: Bool = false
    
    @State private var finalAccuracy: Double = 0.0
    @State private var finalReactionTime: Double = 0.0
    @State private var finalNLevel: Int = 2"""
    
    new_vars = """    @State private var showSummary: Bool = false
    
    private let totalTrials = 20
    private let possibleSymbols = ["star.fill", "circle.fill", "square.fill", "triangle.fill", "heart.fill", "moon.fill"]
    
    @State private var currentTrial = 0
    @State private var symbolHistory: [String] = []
    @State private var currentSymbol: String = "questionmark.circle"
    @State private var correctAnswers = 0
    @State private var totalAnswered = 0
    @State private var totalReactionTimeNS: UInt64 = 0
    
    @State private var exerciseTask: Task<Void, Never>?
    @State private var isSymbolVisible: Bool = true
    @State private var stimulusAppearanceTime: UInt64 = 0
    
    @State private var triggerFeedback: Bool = false
    @State private var isLastCorrect: Bool = false
    
    @State private var completedResult: ExerciseResult? = nil"""
    nback = nback.replace(old_vars, new_vars)

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/NBackExerciseView.swift', 'w') as f:
    f.write(nback)

# ==========================================
# 2. FIX StroopExerciseView.swift
# ==========================================
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/StroopExerciseView.swift', 'r') as f:
    stroop = f.read()

# Add completedResult if it's missing (it was missing due to regex fail)
if "@State private var completedResult" not in stroop:
    old_vars = """    @State private var finalAccuracy: Double = 0.0
    @State private var finalReactionTime: Double = 0.0"""
    new_vars = """    @State private var completedResult: ExerciseResult? = nil"""
    
    if old_vars in stroop:
         stroop = stroop.replace(old_vars, new_vars)
         
    # also remove showSummary
    stroop = stroop.replace('    @State private var showSummary: Bool = false\n', '')

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/StroopExerciseView.swift', 'w') as f:
    f.write(stroop)

