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
    
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // Monday
        
        return calendar.date(from: components)!
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
    //MockUp data disable when testing in actual device
    @Published var mockActivities: [String : Activity] = [
        "todaySteps" : Activity(id: 0, title: "Today's Steps", subtitle: "Goal 10,000", image: "figure.step.training", amount: "12,345 Steps"),
        "todayCalories" : Activity(id: 1, title: "Today's calories", subtitle: "Goal 900", image: "flame", amount: "1,345 KCAL"),
        "weekRunning" : Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.run", amount: " 20 minutes"),
        "weekStrength" : Activity(id: 3, title: "Traditional Strength Training", subtitle: "Today week", image: "dumbbell", amount: "300 KCAL"),
        "weekCycling" : Activity(id: 4, title: "Cycling", subtitle: "Distance This week", image: "figure.outdoor.cycle", amount: " 5.7 KM"),
        "weekoutdoorWalk" : Activity(id: 5, title: "Outdoor Walk", subtitle: "Distance This week", image: "figure.walk", amount: " 1.2 KM")
    ]
    init() {
        guard HKHealthStore.isHealthDataAvailable() else {
                    print("Health data is not available on this device.")
                    return
                }
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        let healthTypes: Set = [steps, calories]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchTodaySteps()
                fetchTodayCalories()
                fetchCurrentWeekWeightLifting()
                
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
            let activity = Activity(id: 0, title: "Today's Steps", subtitle: "Goal 10,000", image: "figure.step.training", amount: stepCount.formattedString())
            
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
    func fetchCurrentWeekRunningStats(){
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate,workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: 10, sortDescriptors: nil){
            _, sample, error in guard let workouts = sample as? [HKWorkout], error == nil else {
                print("error fetching week running data")
                return
            }
            
            var count: Int = 0
            for workout in workouts {
                let duration = Int(workout.duration)/60
                count += duration
            }
            let activity = Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.walk", amount: "\(count) minutes")
            
            DispatchQueue.main.async {
                self.activities["weekRunning"] = activity
            }
        }
        healthStore.execute(query)
    }
    func fetchCurrentWeekWeightLifting(){
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate,workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil){
            _, sample, error in guard let workouts = sample as? [HKWorkout], error == nil else {
                print("error fetching week running data")
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var cyclingCount: Int = 0
            var outdoorwalkCount: Int = 0
            
            for workout in workouts {
                
                if workout.workoutActivityType == .running{
                    let duration = Int(workout.duration)/60
                    runningCount += duration
                }else if workout.workoutActivityType == .traditionalStrengthTraining{
                    let duration = Int(workout.duration)/60
                    strengthCount += duration
                }else if workout.workoutActivityType == .cycling{
                    let duration = Int(workout.duration)/60
                    cyclingCount += duration
                }else if workout.workoutActivityType == .walking{
                    let duration = Int(workout.duration)/60
                    outdoorwalkCount += duration
                }
                    
            }
            let runningActivity = Activity(id: 2, title: "Running", subtitle: "Mins this week", image: "figure.walk", amount: "\(runningCount) minutes")
            let strengthActivity = Activity(id: 3, title: "Weight Lifting", subtitle: "This week", image: "dumbbell", amount: "\(strengthCount) minutes")
            let cyclingActivity = Activity(id: 4, title: "Cycling", subtitle: "Distance This week", image: "figure.outdoor.cycle", amount: "\(cyclingCount) KM")
            let outdoorwalkActivity = Activity(id: 5, title: "Outdoor Walk", subtitle: "Distance This week", image: "figure.outdoor.cycle", amount: "\(outdoorwalkCount) KM")
            
            DispatchQueue.main.async {
                self.activities["weeksRunning "] = runningActivity
                self.activities["weekStrength "] = strengthActivity
                self.activities["weekCycling "] = cyclingActivity
                self.activities["weekoutdoorWalk "] = outdoorwalkActivity
            }
        }
        healthStore.execute(query)
        
    }

    }
