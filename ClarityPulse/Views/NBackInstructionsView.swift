import SwiftUI

struct NBackInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("currentNBackLevel") private var currentNBackLevel: Int = 2
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#DCEBDE"), Color(hex: "#E1EBF5")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("How to Play \(currentNBackLevel)-Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#2C3E50"))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                    .padding(.top, 40)
                    .accessibilityAddTraits(.isHeader)
                
                Text("A sequence of shapes will appear one by one. Tap **Match!** if the current shape is the exact same as the shape shown **\(currentNBackLevel) steps ago**.")
                    .font(.title3)
                    .foregroundColor(Color(hex: "#2C3E50"))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, 24)
                
                VStack(spacing: 16) {
                    Text("Example:")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#2C3E50"))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            VStack {
                                Image(systemName: "square.fill").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.blue)
                                Text("1").font(.caption).foregroundColor(Color(hex: "#2C3E50"))
                            }
                            
                            ForEach(2...currentNBackLevel, id: \.self) { step in
                                Image(systemName: "arrow.right").foregroundColor(Color(hex: "#2C3E50"))
                                VStack {
                                    Image(systemName: "circle.fill").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.blue)
                                    Text("\(step)").font(.caption).foregroundColor(Color(hex: "#2C3E50"))
                                }
                            }
                            
                            Image(systemName: "arrow.right").foregroundColor(Color(hex: "#2C3E50"))
                            VStack {
                                Image(systemName: "square.fill").resizable().scaledToFit().frame(width: 40, height: 40).foregroundColor(.blue)
                                Text("\(currentNBackLevel + 1)").font(.caption).foregroundColor(Color(hex: "#2C3E50"))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Example sequence showing \(currentNBackLevel + 1) shapes where the last shape matches the first shape.")
                    
                    Text("The last shape matches the 1st. Tap Match!")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#2C3E50"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(16)
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button(action: {
                    HapticManager.playLightImpact()
                    dismiss()
                }) {
                    Text("Got it!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#2C3E50"))
                        .cornerRadius(16)
                }
                .accessibilityHint("Dismisses the instructions and returns to the game.")
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    NBackInstructionsView()
}
