//
//  StepListView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI

struct StepListView: View {
    let steps: [Step]
    var body: some View {
        HStack {
            Text(" Steps")
                .font(.headline)
                .padding(.leading)
            Spacer()
            Text("Date  ")
                .font(.headline)
                .padding(.trailing)
        }
        .padding()

        List(steps) { step in
                HStack{
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(isUnder10000(step.count) ? .red: .green)
                    
                    Text("\(step.count)")
                
                Spacer()
                
                    Text(step.date.formatted(date:.abbreviated, time: .omitted))
                
            }
        } .listStyle(.plain)
    }
}

#Preview {
    StepListView(steps:[])
}
