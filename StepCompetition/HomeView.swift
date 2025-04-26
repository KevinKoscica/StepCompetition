//
//  HomeView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI

struct HomeView: View {
    @State private var totalSteps = 0
    @State private var totalCompSteps  = 0
    @State private var steps: [Step] = []
    @State private var stepCounter = StepCounter()
    
    let step: Step
    var body: some View {
        VStack {
            
            // Display the total weekly steps
            
            Text("Steps this Week: \(totalSteps)")
            
                .font(.title)
                .padding()
            Text("Steps in current Competition: \(totalCompSteps)")
                .font(.caption)
            
  
            
        }
        
       
        .frame(maxWidth: .infinity, maxHeight: 150)
        .background(.orange)
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        .overlay(alignment: .topLeading) {
            
            HStack{
                Image(systemName: "flame")
                    .foregroundStyle(.red)
                Text(totalSteps >= 70000 ? "Keep up the good work!" :"Get moving!")
                    .foregroundStyle(totalSteps >= 70000 ? .green :.red)
                    .lineLimit(2)
                    
                
                Text("Daily Goal: 10,000")
                    .foregroundStyle(step.count >= 10000 ? .green :.red)
                
            }.padding()
        }
        
        .task {
            do {
                if totalSteps == 0 {
                    try await stepCounter.calculateSteps()
                    
                totalSteps = stepCounter.getWeeklyTotal()
                    
                    
               }
            } catch {
                print("⚠️ Failed to fetch steps: \(error.localizedDescription)")
            }
        }
        .onAppear(){
            Task{
                try await stepCounter.calculateStepsComp()
                totalCompSteps = stepCounter.getCompetitionStepsTotal()
            }
            
        }
        
        
    }
    
    
    
    
    
    
}
