import SwiftUI

enum GameType: Identifiable {
    case nback, stroop
    var id: Int { self == .nback ? 0 : 1 }
}

struct HomeView: View {
    @State private var dailyQuote: Quote?
    @State private var activeConfig: GameType? = nil
    @State private var navigateToNBack = false
    @State private var navigateToStroop = false
    @AppStorage("currentNBackLevel") private var currentNBackLevel: Int = 2
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Text("Clear the fog. Return to your best self.")
                        .font(.title)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    if let quote = dailyQuote {
                        Text("\"\(quote.text)\"")
                            .font(.title3)
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.primary)
                            .padding(.horizontal, 32)
                            .accessibilityLabel("Daily Quote: \(quote.text)")
                    } else {
                        ProgressView()
                            .tint(Color.primary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 24) {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            activeConfig = .nback
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Log Daily Session")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Test your baseline today")
                                        .font(.subheadline)
                                        .opacity(0.9)
                                }
                                Spacer()
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 40))
                            }
                            .padding(20)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.teal)
                        .cornerRadius(20)
                        .shadow(color: .teal.opacity(0.2), radius: 10, x: 0, y: 5)
                        .accessibilityLabel("Log Daily Session")
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                activeConfig = .nback
                            }) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 32))
                                        .foregroundColor(Color.primary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("N-Back")
                                            .font(.headline)
                                            .foregroundColor(Color.primary)
                                        Text("Current Level: \(currentNBackLevel)-Back")
                                            .font(.caption)
                                            .foregroundColor(Color.primary.opacity(0.7))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                                .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                            }
                            .accessibilityLabel("Start N-Back Exercise")
                            
                            Button(action: {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                activeConfig = .stroop
                            }) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Image(systemName: "paintpalette")
                                        .font(.system(size: 32))
                                        .foregroundColor(Color.primary)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Stroop Task")
                                            .font(.headline)
                                            .foregroundColor(Color.primary)
                                        Text("Cognitive Flexibility")
                                            .font(.caption)
                                            .foregroundColor(Color.primary.opacity(0.7))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(.regularMaterial)
                                .cornerRadius(16)
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                                .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                            }
                            .accessibilityLabel("Start Stroop Task")
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Image(systemName: "view.3d")
                                    .font(.system(size: 32))
                                    .foregroundColor(Color.gray)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Spatial Span")
                                        .font(.headline)
                                        .foregroundColor(Color.gray)
                                    Text("Coming Soon")
                                        .font(.caption)
                                        .foregroundColor(Color.gray.opacity(0.7))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Image(systemName: "hand.raised.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(Color.gray)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Go/No-Go")
                                        .font(.headline)
                                        .foregroundColor(Color.gray)
                                    Text("Coming Soon")
                                        .font(.caption)
                                        .foregroundColor(Color.gray.opacity(0.7))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(16)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
                            .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .padding(.top, 60)
            }
            .task {
                do {
                    dailyQuote = try await QuoteService.shared.fetchRandomQuote()
                } catch {
                    print("Failed to fetch quote: \(error)")
                }
            }
            .sheet(item: $activeConfig) { game in
                SessionConfigView {
                    if game == .nback {
                        navigateToNBack = true
                    } else {
                        navigateToStroop = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToNBack) {
                NBackExerciseView()
            }
            .navigationDestination(isPresented: $navigateToStroop) {
                StroopExerciseView()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanHex.hasPrefix("#") {
            cleanHex.remove(at: cleanHex.startIndex)
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    HomeView()
}
