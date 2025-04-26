//
//  UserViewModel.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import FirebaseFirestore
import FirebaseFirestore
import Foundation

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var competitionStartDate: Date?
    @Published var competitionEndDate: Date?

    let db = Firestore.firestore(database: "steps")
    
    init() {
        fetchUsers()
        fetchCompetitionDates()
    }
    

    func fetchCompetitionDates() {
        let db = Firestore.firestore(database: "steps")
        
        // Pull from any user, since dates are global
        db.collection("users").limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching competition dates: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("❌ No user found to pull competition dates.")
                return
            }
            
            let data = document.data()
            if let startTimestamp = data["competitionStartDate"] as? Timestamp,
               let endTimestamp = data["competitionEndDate"] as? Timestamp {
                self.competitionStartDate = startTimestamp.dateValue()
                self.competitionEndDate = endTimestamp.dateValue()
            }
        }
    }

    func fetchUsers() {
       
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents
            
            else {
                print("No documents")
                return
            }
           

            self.users = documents.compactMap { doc -> User? in
                let data = doc.data()
                let id = doc.documentID
                let name = data["name"] as? String ?? "No Name"
                let steps = data["steps"] as? Int ?? 0
                return User(id: id, name: name, steps: steps)
            }
            
        }
       
    }
}


