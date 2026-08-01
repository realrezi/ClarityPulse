import SwiftUI

struct MainTabView: View {
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "brain.head.profile")
                }
            
            ProgressDashboardView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.xyaxis.line")
                }
            
            ExperimentsView()
                .tabItem {
                    Label("Trials", systemImage: "flask")
                }
        }
        .tint(.teal)
        .fullScreenCover(isPresented: Binding(get: { !hasAcceptedDisclaimer }, set: { _ in })) {
            DisclaimerView()
        }
    }
}

#Preview {
    MainTabView()
}
