//
//  ProfileView.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/29/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
                  CircleImage()
                      .offset(y: -10)
                      .padding(.bottom, -100)
                      .padding()
                  VStack(alignment: .leading) {
                      Text("John Doe")
                          .font(.title)
                      HStack {
                          Text("Joined Date")
                          Spacer()
                          Text("Total Monthyl Steps")
                          Text("10,000")
                      }
                      .font(.subheadline)
                      .foregroundStyle(.secondary)


                      Divider()


                      Text("About Turtle Rock")
                          .font(.title2)
                      Text("Descriptive text goes here.")
                  }
                  .padding()


                  Spacer()
              }
          }
      }

#Preview {
    ProfileView()
}
