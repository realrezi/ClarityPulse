import SwiftUI

struct DisclaimerView: View {
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Welcome to ClarityPulse")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                
                Text("This app is designed for educational and wellness purposes only and is not intended to diagnose, treat, or cure any medical condition. Our daily wellness quotes are curated offline using AI. No personal data ever leaves your device.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    withAnimation {
                        hasAcceptedDisclaimer = true
                    }
                }) {
                    Text("I Understand")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)

                }
                .buttonStyle(.borderedProminent)
                .tint(.teal)
                .cornerRadius(12)
                .padding(.horizontal, 40)
                .padding(.top, 20)
                Spacer()
                
                Text("Designed & Engineered by Ahmadreza Shirdel, MD")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 20)
            }
            .padding()
        }
    }
}

#Preview {
    DisclaimerView()
}
