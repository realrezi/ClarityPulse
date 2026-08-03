import SwiftUI

struct SplashView: View {
    @State private var blurRadius: CGFloat = 20
    @State private var imageOpacity: Double = 0.3
    @State private var scale: CGFloat = 1.0
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if isActive {
                MainTabView()
                    .transition(.opacity)
            } else {
                ZStack {
                    Color(uiColor: .systemGroupedBackground)
                        .ignoresSafeArea()
                    
                    VStack {
                        Image(systemName: "waveform.path.ecg")
                            .font(.system(size: 100, weight: .light))
                            .foregroundColor(.teal)
                            .blur(radius: blurRadius)
                            .opacity(imageOpacity)
                            .scaleEffect(scale)
                    }
                }
                .onAppear {
                    // Phase 1: Clarity (Mental Fog Clearing)
                    withAnimation(.easeInOut(duration: 0.8)) {
                        blurRadius = 0
                        imageOpacity = 1.0
                    }
                    
                    // Phase 2: Pulse (Cognitive Heartbeat)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                            scale = 1.2
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                                scale = 1.0
                            }
                            
                            // Phase 3: Route to Main App
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isActive = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
