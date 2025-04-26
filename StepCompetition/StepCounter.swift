//
//  StepCounter.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/19/25.
//

import Foundation
import HealthKit
import Observation
import Firebase
import FirebaseFirestore
import FirebaseAuth
//allows access to health setitngs and step counter
enum HealthError: Error {
    case healthDataNotAvailable
}


@Observable
class StepCounter {
    var steps: [Step] = []
    var healthStore: HKHealthStore?
    var lastError: Error?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else{
            lastError = HealthError.healthDataNotAvailable
        }
    }
    func saveStepsToFirebase(){
        let db = Firestore.firestore(database: "steps")
        
        guard let currentUser = Auth.auth().currentUser else {
            print("❌ No authenticated user.")
            return
        }
        
        guard let email = currentUser.email else {
            print("❌ User has no email.")
            return
        }
        
        let totalSteps = steps.reduce(0) { $0 + $1.count }
        
        db.collection("users").document(email).setData([
            "name": email,
            "steps": Double(totalSteps)
        ], merge: true) { error in
            if let error = error {
                print("🔥 Error saving steps to Firebase: \(error.localizedDescription)")
            } else {
                print("✅ Steps saved successfully for user \(email)")
            }
        }
    }
    func getCompetitionStepsTotal() -> Int {
        return steps.reduce(0) { $0 + $1.count }
    }
    func calculateStepsComp() async throws {
        guard let healthStore = self.healthStore else { return }
        steps = []

        // Get the authenticated user's email
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email else {
            print("❌ No authenticated user.")
            return
        }

        let db = Firestore.firestore(database: "steps")
        let userDoc = db.collection("users").document(email)
        
        let snapshot = try await userDoc.getDocument()
        guard let data = snapshot.data(),
              let timestamp = data["competitionStartDate"] as? Timestamp else {
            print("❌ No competitionStartDate found.")
            return
        }

        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.startOfDay(for: timestamp.dateValue())
        let endDate = Date()
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day: 1)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let samplePredicate = HKSamplePredicate.quantitySample(type: stepType, predicate: predicate)
        
        let anchorDate = calendar.startOfDay(for: startDate)
        
        let query = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: everyDay
        )
        
        let result = try await query.result(for: healthStore)
        
        result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
            let count = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
            let step = Step(count: Int(count), date: statistics.startDate)
            if step.count > 0 {
                self.steps.append(step)
            }
        }
    }

    func calculateSteps() async throws {
        guard let healthStore = self.healthStore else{return}
        
        steps = []
        
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())
        let endDate = Date()
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day:1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
        
        let anchorDate = Calendar.current.startOfDay(for: Date())
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: stepsThisWeek,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: everyDay
        )
        
       
        let stepsCount = try await sumOfStepsQuery.result(for: healthStore)
        
        guard let startDate = startDate else {return}
        
        stepsCount.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            if step.count > 0 {
                self.steps.append(step)
            }
        }
    }
    func requestAuthorization() async {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else{return}
        guard let healthStore = self.healthStore else {return}
        
        do{
            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            lastError = error
        }
    }
    func getWeeklyTotal() -> Int {
        return steps.reduce(0) { $0 + $1.count }
    }
   
        static func startNewCompetition() {
            let db = Firestore.firestore(database: "steps")
            let usersRef = db.collection("users")
            let globalRef = db.collection("global").document("competition")

            let startDate = Date()
            guard let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate) else { return }

            // 1. Save global competition dates
            globalRef.setData([
                "competitionStartDate": Timestamp(date: startDate),
                "competitionEndDate": Timestamp(date: endDate)
            ]) { error in
                if let error = error {
                    print("❌ Failed to update global dates: \(error.localizedDescription)")
                    return
                }
                print("✅ Global competition dates set.")

                // 2. Update every user's competition dates
                usersRef.getDocuments { snapshot, error in
                    if let error = error {
                        print("❌ Failed to fetch users: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else { return }

                    for document in documents {
                        usersRef.document(document.documentID).updateData([
                            "competitionStartDate": Timestamp(date: startDate),
                            "competitionEndDate": Timestamp(date: endDate),
                            "steps": 0 // optional reset
                        ]) { err in
                            if let err = err {
                                print("❌ Error updating user \(document.documentID): \(err.localizedDescription)")
                            } else {
                                print("✅ Updated user \(document.documentID) for new competition.")
                            }
                        }
                    }
                }
            }
        }
    


}


