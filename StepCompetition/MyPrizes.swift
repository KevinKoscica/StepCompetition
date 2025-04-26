//
//  MyPrizes.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import SwiftUI

struct MyPrizes: View {
    @State private var count = 10  // set to 10 to simulate max wins before grand prize, real app would save win count in firebase firestore
    //@State private var catImageURL = URL(string: "https://cataas.com/cat")!
    @State private var claimedRewards: Set<String> = []
    @State private var showConfetti = false
    @State private var catImageURL: URL? = nil
   
    // Reward tiers
    let unlockedRewards: [(winsRequired: Int, title: String, description: String)] = [
        (1, "5 Dollars off insurance for the month", "Save money on your health insurance."),
        (2, "10 Dollar Chipotle Gift Card", "Enjoy a healthy bowl on us."),
        (5, "Amazon Gift Card", "Get a $25 Amazon gift card."),
        (10, "Gym Membership", "free one month of gym membership."),
        (50, "Grand Prize Entry", "Automatic entry into our grand prize raffle!")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                            VStack(alignment: .center) {
                                if count > 0 && claimedRewards.isEmpty{
                                    Text("You have won \(count) step competitions!")
                                        .font(.title2)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                    
                                    Spacer()
                                    Text("Here are your unlocked rewards:")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    Text("Swipe to claim rewards! " )
                                        .font(.caption)
                                }
                                
                                List {
                                    ForEach(unlockedRewards.filter { count >= $0.winsRequired }, id: \.winsRequired) { reward in
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(reward.description)
                                                    .strikethrough(claimedRewards.contains(reward.description), color: .green)
                                                    .foregroundColor(claimedRewards.contains(reward.description) ? .gray : .primary)
                                                
                                                if claimedRewards.contains(reward.description) {
                                                    Text("Claimed ✅")
                                                        .font(.caption)
                                                        .foregroundColor(.green)
                                                }
                                            }
                                            Spacer()
                                        }
                                        .swipeActions {
                                            if !claimedRewards.contains(reward.description) {
                                                Button("Claim") {
                                                    withAnimation(.spring()) {
                                                        claimedRewards.insert(reward.description)
                                                        showConfetti = true
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                            showConfetti = false
                                                        }
                                                        
                                                    }
                                                    catImageURL = URL(string: "https://cataas.com/cat?\(Int(Date().timeIntervalSince1970))")
                                                }
                                                .tint(.green)
                                            }
                                        }
                                    }

                            }

                    }

                    if count == 0 {
                        Text("Keep competing to earn cool rewards!")
                            .foregroundColor(.gray)
                    }
                   
                }
                .listStyle(.insetGrouped)
                .navigationTitle("My Prizes 🎁")
            }
        if !claimedRewards.isEmpty{
            Section(header: Text("You Earned a Bonus Cat!")) {
                AsyncImage(url: catImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200)
                
            }
        }
        if showConfetti {
            PrizeWinView()
            .transition(.scale)
        }
            
        }
    
    }


#Preview {
    MyPrizes()
}
