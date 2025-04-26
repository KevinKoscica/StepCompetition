//
//  User.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/10/25.
//

import Foundation
import HealthKit
import HealthKitUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct User: Identifiable, Codable{
    var id: String
    var name: String
    var steps: Int
    init(id: String, name: String, steps: Int) {
        self.id = id
        self.name = name
        self.steps = steps
    }
}

