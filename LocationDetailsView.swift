//
//  LocationDetailsView.swift
//  FitFrenzy
//
//  Created by Marc Panaligan on 7/29/24.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @Binding var mapSelection: MKMapItem?
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LocationDetailsView(mapSelection: .constant(nil))
}
