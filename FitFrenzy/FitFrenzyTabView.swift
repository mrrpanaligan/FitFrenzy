//
//  FitFrenzyTabView.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/29/24.
//

import SwiftUI

struct FitFrenzyTabView: View {
    @EnvironmentObject var manager: HealthManager
    @State var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab){
            HomeView()
                .tag("Home")
                .tabItem { Image(systemName: "house") }
                .environmentObject(manager)
            
            ContentView().tag("Content")
                .tabItem { Image (systemName: "person.fill") }
        }
    }
}

struct FitFrenzyTabView_Previews: PreviewProvider{
    static var previews: some View{
        FitFrenzyTabView()
    }
}

#Preview {
    FitFrenzyTabView()
}
