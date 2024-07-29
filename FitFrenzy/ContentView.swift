//
//  ContentView.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/29/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    var body: some View {
        Map(position: $cameraPosition){
            UserAnnotation()
            
            Annotation("My Location", coordinate: .userLocation){
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/.opacity(0.25))
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
            }
            
        }
        .mapControls{
            MapCompass()
            MapPitchToggle()
        }
        
    }
    
            
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 14.563571, longitude: 121.104573)
    }
}
extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion{
        return .init(center: .userLocation, latitudinalMeters: 1000, longitudinalMeters: 100)
    }
    
}

    final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
        var locationManager: CLLocationManager?
        func checkLocationServiceEnabled(){
            if CLLocationManager.locationServicesEnabled(){
                locationManager = CLLocationManager()
                checkLocationAuth()
            }else{
                print("Please enable location service")
            }
        }
        
        func checkLocationAuth(){
            guard let locationManager = locationManager else { return }
            switch locationManager.authorizationStatus{
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("Location is restricted")
            case .denied:
                print("App location permission is denied")
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuth()
        }
    }

#Preview{
    ContentView()
}
    
