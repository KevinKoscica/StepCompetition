//
//  CompetitionModel.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/10/25.
//

import Foundation
import Firebase
import FirebaseFirestore


struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}


