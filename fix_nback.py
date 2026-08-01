import re

with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/NBackExerciseView.swift', 'r') as f:
    content = f.read()

# Fix image view
old_image = """            Image(systemName: currentSymbol)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
                .opacity(isSymbolVisible ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.1), value: isSymbolVisible)
                .accessibilityLabel("Shape: \\(currentSymbol.replacingOccurrences(of: ".fill", with: ""))")"""

new_image = """            if isSymbolVisible {
                Image(systemName: currentSymbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.blue)
                    .transition(.opacity)
                    .id(currentTrial)
                    .accessibilityLabel("Shape: \\(currentSymbol.replacingOccurrences(of: ".fill", with: ""))")
            } else {
                // Placeholder to maintain spacing
                Color.clear
                    .frame(width: 150, height: 150)
            }"""

if old_image in content:
    content = content.replace(old_image, new_image)
else:
    # If the exact match fails, use regex
    content = re.sub(
        r'Image\(systemName: currentSymbol\)[\s\S]*?\.accessibilityLabel\(.*?Shape:.*?\)',
        new_image,
        content
    )


# Fix runExerciseLoop
old_loop = """    @MainActor
    private func runExerciseLoop() async {
        while currentTrial < totalTrials && !Task.isCancelled {
            nextStimulus()
            isSymbolVisible = true
            
            do {
                try await Task.sleep(nanoseconds: 1_500_000_000)
            } catch {
                break
            }
            
            if Task.isCancelled { break }
            
            isSymbolVisible = false
            stimulusAppearanceTime = 0
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                break
            }
        }
        
        if currentTrial >= totalTrials && !Task.isCancelled {
            finishExercise()
        }
    }"""

new_loop = """    @MainActor
    private func runExerciseLoop() async {
        while currentTrial < totalTrials && !Task.isCancelled {
            nextStimulus()
            
            withAnimation(.easeInOut(duration: 0.15)) {
                isSymbolVisible = true
            }
            
            do {
                try await Task.sleep(nanoseconds: 1_500_000_000)
            } catch {
                break
            }
            
            if Task.isCancelled { break }
            
            withAnimation(.easeInOut(duration: 0.15)) {
                isSymbolVisible = false
            }
            stimulusAppearanceTime = 0
            
            do {
                try await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                break
            }
        }
        
        if currentTrial >= totalTrials && !Task.isCancelled {
            finishExercise()
        }
    }"""

if old_loop in content:
    content = content.replace(old_loop, new_loop)
else:
    print("Could not find old_loop")
    
with open('/Users/m1/Documents/ClarityPulse/ClarityPulse/Views/NBackExerciseView.swift', 'w') as f:
    f.write(content)

