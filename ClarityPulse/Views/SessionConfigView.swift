import SwiftUI

struct SessionConfigView: View {
    @Environment(ActiveSessionManager.self) private var sessionManager
    @Environment(\.dismiss) private var dismiss
    
    let onStart: () -> Void
    
    @State private var selectedTags: Set<String> = []
    
    private let tagCategories = [
        ("Chronobiology", ["Just Woke Up", "Mid-Day Slump", "Late Night", "Sleep Deprived"]),
        ("Metabolic", ["Fasted", "Post-Meal", "Hydrated", "Dehydrated"]),
        ("Stimulants", ["Caffeinated", "Nicotine", "Unstimulated"]),
        ("Physiological", ["Post-Workout", "High Stress"])
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#DCEBDE"), Color(hex: "#E1EBF5")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Session Variables")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(hex: "#2C3E50"))
                            .padding(.top)
                        
                        ForEach(tagCategories, id: \.0) { category, tags in
                            DisclosureGroup {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(tags, id: \.self) { tag in
                                        Toggle(tag, isOn: Binding(
                                            get: { selectedTags.contains(tag) },
                                            set: { isSelected in
                                                if isSelected {
                                                    selectedTags.insert(tag)
                                                } else {
                                                    selectedTags.remove(tag)
                                                }
                                            }
                                        ))
                                        .toggleStyle(SwitchToggleStyle(tint: Color(hex: "#2C3E50")))
                                    }
                                }
                                .padding(.vertical, 8)
                            } label: {
                                Text(category)
                                    .font(.headline)
                                    .foregroundColor(Color(hex: "#2C3E50"))
                            }
                            .padding()
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Configure Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "#2C3E50"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Start") {
                        HapticManager.playLightImpact()
                        sessionManager.selectedTags = Array(selectedTags)
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            onStart()
                        }
                    }
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2C3E50"))
                }
            }
        }
    }
}
