//
//  HealthManager.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/30/24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var activities: [String: Activity] = [:]
    @Published var mockActivities: [String: Activity] = [
        "todaySteps" : Activity(id: 0, title: "Today's Steps", subtitle: "Goal 10,000", image: "figure.walk", amount: "12,345"),
        "todayCalories" : Activity(id: 1, title: "Today's calories", subtitle: "Goal 900", image: "flame", amount: "1,345")
    ]
    init() {
        guard HKHealthStore.isHealthDataAvailable() else {
                    print("Health data is not available on this device.")
                    return
                }
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let healthTypes: Set = [steps, calories]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
            }catch{
                print("error fetching health data")
            }
        }
    }
    //Steps
    func fetchTodaySteps(){
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay ,end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in guard let quantity = result?.sumQuantity(), error == nil else{
            print("error fetching todays steps data")
            return
        }
            let stepCount = quantity.doubleValue(for: .count())
            print(stepCount)
            let activity = Activity(id: 0, title: "Today's Steps", subtitle: "Goal 10,000", image: "figure.walk", amount: stepCount.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todaysSteps"] = activity
            }
        }
        healthStore.execute(query)
    }
    //Calories
    func fetchTodayCalories(){
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay ,end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in guard let quantity = result?.sumQuantity(), error == nil else{
            print("error fetching todays calories data")
            return
        }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            print(caloriesBurned)
            let activity = Activity(id: 1, title: "Today's calories", subtitle: "Goal 900", image: "flame", amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activities["todaysCalories"] = activity
            }
          
        }
        healthStore.execute(query)
    }
    }
