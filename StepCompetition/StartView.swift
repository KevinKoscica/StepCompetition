//
//  StatView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI

struct StartView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab){
            CompetitionView()
            .tabItem{
                Image(systemName: "house")
                Text("home")
            }
            .tag(0)
            Text("hey")
             .tabItem{
                 Image(systemName: "figure.walk.motion")
                 
                 Text("Leaderboard")
             }
             .tag(1)
            Text("ll")
             .tabItem{
                 Image(systemName: "dollarsign")
                 Text("Rewards")
             }
             .tag(3)
        }
    }
}

#Preview {
    StartView()
}
