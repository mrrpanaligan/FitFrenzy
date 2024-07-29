//
//  FitnessView.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/29/24.
//

import SwiftUI

struct FitnessView: View {
    var body: some View {
        GroupBox(label:
                    Label("Workout Details", systemImage: "person.fill")
        ) {
            
            //Scrollview Start
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack{
                    HStack(alignment: .top){
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Daily Steps").font(.system(size: 16))
                            Text("Goal: 10,000").font(.system(size:12))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                        Image(systemName: "figure.walk")
                    }
                    .padding()
                    Text("9,000").font(.system(size: 24))
                    
                }
                .padding()
                .cornerRadius(15)
                .frame(height: 100)
                
                
            }//Scrollview end
            
        }//Groupbox end
        .backgroundStyle(Color(UIColor.systemBackground))
    }
    
}

#Preview {
    FitnessView()
}
