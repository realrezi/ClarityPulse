import SwiftUI

struct ConsistencyHeatmapView: View {
    let results: [ExerciseResult]
    @State private var isLoaded = false
    
    private var heatmapData: [Date: Int] {
        var data: [Date: Int] = [:]
        for result in results {
            if let sessionDate = result.session?.date {
                let startOfDay = Calendar.current.startOfDay(for: sessionDate)
                data[startOfDay, default: 0] += 1
            }
        }
        return data
    }
    
    private var past28Days: [Date] {
        let today = Calendar.current.startOfDay(for: Date())
        var days: [Date] = []
        for i in (0..<28).reversed() {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: today) {
                days.append(date)
            }
        }
        return days
    }
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Consistency")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(past28Days, id: \.self) { date in
                    let count = heatmapData[date] ?? 0
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.teal)
                        .opacity(isLoaded ? opacity(for: count) : 0)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(.regularMaterial)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.primary.opacity(0.08), lineWidth: 0.5))
        .shadow(color: Color.primary.opacity(0.05), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isLoaded = true
            }
        }
        .padding(.horizontal)
    }
    
    private func opacity(for count: Int) -> Double {
        if count == 0 { return 0.1 }
        if count == 1 { return 0.5 }
        return 1.0
    }
}
