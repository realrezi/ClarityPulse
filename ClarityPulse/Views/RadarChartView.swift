import SwiftUI

struct RadarChartView: View {
    let nBackAccuracy: Double
    let nBackLevel: Double
    let stroopAccuracy: Double
    let stroopRT: Double
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let center = CGPoint(x: width / 2, y: height / 2)
            let radius = min(width, height) / 2 * 0.75
            
            ZStack {
                // Background webs
                ForEach(1...5, id: \.self) { i in
                    let scale = CGFloat(i) / 5.0
                    Path { path in
                        for j in 0..<4 {
                            let angle = CGFloat.pi / 2 * CGFloat(j) - CGFloat.pi / 2
                            let point = CGPoint(
                                x: center.x + cos(angle) * radius * scale,
                                y: center.y + sin(angle) * radius * scale
                            )
                            if j == 0 { path.move(to: point) }
                            else { path.addLine(to: point) }
                        }
                        path.closeSubpath()
                    }
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                }
                
                // Axes
                ForEach(0..<4, id: \.self) { j in
                    Path { path in
                        path.move(to: center)
                        let angle = CGFloat.pi / 2 * CGFloat(j) - CGFloat.pi / 2
                        let point = CGPoint(
                            x: center.x + cos(angle) * radius,
                            y: center.y + sin(angle) * radius
                        )
                        path.addLine(to: point)
                    }
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                }
                
                // Labels
                Text("N-Back Acc")
                    .position(x: center.x, y: center.y - radius - 30)
                Text("N-Back Lvl")
                    .position(x: center.x + radius + 45, y: center.y)
                Text("Stroop Acc")
                    .position(x: center.x, y: center.y + radius + 30)
                Text("Stroop RT")
                    .position(x: center.x - radius - 45, y: center.y)
                
                // Data Polygon
                let values = [nBackAccuracy, nBackLevel, stroopAccuracy, stroopRT]
                
                Path { path in
                    for j in 0..<4 {
                        let val = CGFloat(max(0, min(1, values[j])))
                        let angle = CGFloat.pi / 2 * CGFloat(j) - CGFloat.pi / 2
                        let point = CGPoint(
                            x: center.x + cos(angle) * radius * val,
                            y: center.y + sin(angle) * radius * val
                        )
                        if j == 0 { path.move(to: point) }
                        else { path.addLine(to: point) }
                    }
                    path.closeSubpath()
                }
                .fill(Color.teal.opacity(0.3))
                
                Path { path in
                    for j in 0..<4 {
                        let val = CGFloat(max(0, min(1, values[j])))
                        let angle = CGFloat.pi / 2 * CGFloat(j) - CGFloat.pi / 2
                        let point = CGPoint(
                            x: center.x + cos(angle) * radius * val,
                            y: center.y + sin(angle) * radius * val
                        )
                        if j == 0 { path.move(to: point) }
                        else { path.addLine(to: point) }
                    }
                    path.closeSubpath()
                }
                .stroke(Color.teal, lineWidth: 2)
            }
        }
        .font(.caption)
        .foregroundColor(.primary)
    }
}
