//
//  StepsChartsView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI
import Charts
struct StepsChartsView: View {
    let steps: [Step]
    var body: some View {
        Chart{
            ForEach(steps) { step in
                BarMark(x: .value("Date", step.date), y: .value("Count", step.count))
                    .foregroundStyle(isUnder10000(step.count) ? .red : .green)
            }
        }
    }
}


