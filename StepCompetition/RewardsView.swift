//
//  RewardsView.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI

struct RewardsView: View {
    @State private var catImageURL = URL(string: "https://cataas.com/cat")!

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Rewards")) {
                    rewardRow(title: "1 Competition Win", description: "$5 off insurance this month")
                    rewardRow(title: "2 Competition Wins", description: "$10 dollar Chipotle gift card")
                    rewardRow(title: "5 Competition Wins", description: "$25 Amazon Gift Card")
                    rewardRow(title: "10 Competition Wins", description: "Free Gym Membership for one month")
                    rewardRow(title: "50 Competition Wins", description: "Grand Prize Entry")
                }

                Section(header: Text("🐱 Free motivational Kitty pics! ")) {
                    AsyncImage(url: catImageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } placeholder: {
                        ProgressView()
                    }
                    //.frame(height: 200)

                    Button("New Cat! ") {
                        // Generate a random image to break caching
                        catImageURL = URL(string: "https://cataas.com/cat?timestamp=\(Date().timeIntervalSince1970)")!
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Earnable Rewards")
        }
    }

    func rewardRow(title: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            Text(description).font(.caption).foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}


#Preview {
    RewardsView()
}
