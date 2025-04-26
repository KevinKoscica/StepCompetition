//
//  PrizeWinView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/20/25.
//

import SwiftUI

struct PrizeWinView: View {
    @State private var rotate = false
    var body: some View {
        VStack {
            Spacer()
            ForEach(0..<20) { i in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.random)
                    .offset(x: CGFloat.random(in: -150...150), y: CGFloat.random(in: -300...0))
                    .rotationEffect(.degrees(rotate ? 360 : 0))
                    .animation(.easeOut(duration: Double.random(in: 1.5...2.5)), value: rotate)
            }
            Spacer()
        }
        .onAppear {
            rotate.toggle()
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0.4...1),
            green: .random(in: 0.4...1),
            blue: .random(in: 0.4...1)
        )
    }
}

#Preview {
    PrizeWinView()
}
