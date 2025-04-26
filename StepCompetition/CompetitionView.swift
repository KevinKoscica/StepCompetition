//
//  CompetitionView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/10/25.
// inspirtation taken from a video on youtube

import SwiftUI
import Firebase
import HealthKit
import FirebaseAuth
import FirebaseFirestore
enum DisplayType: Int, Identifiable, CaseIterable {
    case list
    case chart
    
    var id: Int{
        rawValue
    }
    
}
extension DisplayType {
    var icon: String{
        switch self {
        case .list:
            return "list.bullet"
        case .chart:
            return "chart.bar"
        }
    }
}
struct CompetitionView: View {
    @State var selectedTab = 0
    @State private var stepCounter = StepCounter()
    @State private var displayType: DisplayType = .list
    @Environment(\.dismiss) var dismiss
    
    private var steps: [Step]{
        stepCounter.steps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    var body: some View {
        NavigationStack{
            if let step = steps.first {
                HomeView(step: step)
            }
            
            
            Picker("Selection", selection:$displayType){
                ForEach(DisplayType.allCases){ displayType in
                    Image(systemName: displayType.icon).tag(displayType)
                }
            }
            .pickerStyle(.segmented)
            
            switch displayType {
            case .list:
                StepListView(steps: Array(steps.dropLast()))
            case .chart:
                StepsChartsView(steps: steps)
            }
           
            
        }
       
        .task {
            await stepCounter.requestAuthorization()
           if stepCounter.steps.count == 0{
                do{
                    try await stepCounter.calculateSteps()
                    stepCounter.saveStepsToFirebase()
                } catch{
                    print(error)
                }
            }
        }
        
        
        
        
                
            
        
       
    }
       
}

#Preview {
    NavigationStack{
        CompetitionView()
    }
}
