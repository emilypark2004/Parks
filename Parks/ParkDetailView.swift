//
//  ParkDetailView.swift
//  Parks
//
//  Created by Emily Park on 3/22/24.
//

import SwiftUI
import MapKit

struct ParkDetailView: View {
    
    let park: Park
    
    var body: some View {
        ScrollView {
            if #available(iOS 17.0, *) {
                VStack(alignment: .leading, spacing: 16) { // Aligns vertical views to the leading edge with 16pt spacing between views
                    Text(park.fullName)
                        .font(.largeTitle)
                    Text(park.description)
                }
                .padding()
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(park.images) { image in
                            Rectangle()
                                .aspectRatio(7/5, contentMode: .fit)
                                .containerRelativeFrame(.horizontal, count: 9, span: 8, spacing: 16)
                                .overlay {
                                    AsyncImage(url: URL(string: image.url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color(.systemGray4)
                                    }
                                }
                                .cornerRadius(16)
                        }
                        .safeAreaPadding(.horizontal)
                    }
                }
                if let latitude = Double(park.latitude), let longitude = Double(park.longitude) {
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    Map(initialPosition: .region(.init(center: coordinate, latitudinalMeters: 1_000_000, longitudinalMeters: 1_000_000))) {
                        Marker(park.name, coordinate: coordinate)
                            .tint(.purple)
                    }
                    .aspectRatio(1, contentMode: .fill)
                    .cornerRadius(12)
                    .padding()
                }
            }
        }
    }
}

struct ParkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParkDetailView(park: Park.mocked)
    }
}
