//
//  StatView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct StartView: View {
    
    @State private var selectedTab = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
       // NavigationStack{
            
            TabView(selection: $selectedTab){
                NavigationStack{
                    CompetitionView()
                        .navigationTitle("Your week at a glance: ")
                        .toolbar {
                            
                            ToolbarItem(placement: .topBarLeading) {
                                
                                Button("Sign Out") {
                                    do{
                                        try Auth.auth().signOut()
                                        print("logout succesful!")
                                        dismiss()
                                    } catch{
                                        print("error could not sign out")
                                    }
                                }
                            }
                        }
                }
                        .tabItem{
                            Image(systemName: "house")
                            Text("home")
                        }
                        .tag(0)
                        
                
                NavigationStack{
                    LeaderBoardView()
                        .navigationTitle("leaderboard")
                        .toolbar {
                            
                            ToolbarItem(placement: .topBarTrailing) {
                                
                                Button("New Competition") {
                                    StepCounter.startNewCompetition()//sets all step counts to zero and starts a new competition
                                }
                            }
                        }
                }
                        .tabItem{
                            Image(systemName: "figure.walk.motion")
                            
                            Text("Leaderboard")
                        }
                        .tag(1)
                        
                NavigationStack{
                    RewardsView()
                        .navigationTitle("Available Rewards: ")
                }
                    .tabItem{
                        Image(systemName: "dollarsign")
                        Text("Rewards")
                    }
                    .tag(2)
                NavigationStack{
                    MyPrizes()
                        .navigationTitle("Your Earned Rewards: ")
                }
                    .tabItem{
                        Image(systemName: "bitcoinsign.bank.building.fill")
                        Text("My Rewards ")
                    }
                    .tag(3)
                    
                        
                    
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    
                    Button("Sign Out") {
                        do{
                            try Auth.auth().signOut()
                            print("logout succesful!")
                            dismiss()
                        } catch{
                            print("error could not sign out")
                        }
                    }
                }
            }
        //}
        
    }
}

#Preview {
    StartView()
}
