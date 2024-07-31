//
//  HomeView.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/29/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {
        
        VStack(alignment: .leading){
            Text("Welcome John Doe").font(.largeTitle).padding().foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)){
                ForEach(manager.mockActivities.sorted(by: { $0.value.id < $1.value.id}),
                        id: \.key) { item in
                    ActivityCard(activity: item.value)
                    }
            }
            
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(HealthManager())
    }
}
