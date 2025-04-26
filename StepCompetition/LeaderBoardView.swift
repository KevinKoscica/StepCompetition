//
//  LeaderBoardView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct LeaderBoardView: View {
    @State private var competitionStartDate: Date?
    @State private var competitionEndDate: Date?
    @State private var stepCounter = StepCounter()
    @StateObject private var viewModel = UsersViewModel()
    @State private var index = 1
    var body: some View {
        NavigationStack{
            
            if let start = viewModel.competitionStartDate, let end = viewModel.competitionEndDate {
                    HStack() {
                        Text(" Competition started: \(start.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                        Spacer()
                        Text(" Ends: \(end.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                    }
                    .padding(.horizontal)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                }
            
            List(Array(viewModel.users.sorted(by: { $0.steps > $1.steps }).enumerated()), id: \.element.id) { index, user in
                HStack {
                    // Use emojis for the first 3 places, otherwise show the rank number
                    Text(getRankEmoji(for: index))
                        .font(.headline)
                        .bold()
                        .foregroundColor(.blue)
                    
                    // User name
                    Text(user.name)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer() // Pushes the steps label to the right
                    
                    // Steps count
                    Text("Steps: \(user.steps)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)  // Vertical padding to add spacing between rows
                .background(index % 2 == 0 ? Color.gray.opacity(0.1) : Color.clear) // Alternate row background color
                .cornerRadius(8)
                


            }
            

                    .font(.title2)
                
                .listStyle(.plain)
                .navigationTitle("Current Leaderboard")
            }
        .onAppear {
            Task{
                try await stepCounter.calculateStepsComp()
                stepCounter.saveStepsToFirebase()
            }
           
            viewModel.fetchUsers()
            
            
        }
       
        .refreshable {
            try? await stepCounter.calculateStepsComp()

            stepCounter.saveStepsToFirebase()
           
        }
        
        
       
        }
    

    }


#Preview {
    LeaderBoardView()
}
