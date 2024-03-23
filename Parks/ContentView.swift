//
//  ContentView.swift
//  Parks
//
//  Created by Emily Park on 3/21/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var parks: [Park] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(parks) { park in
                        NavigationLink(value: park) {
                        ParkRow(park: park)
                                }
                    }
                }
            }
                    .navigationDestination(for: Park.self) { park in
                        ParkDetailView(park: park)
                    }
                    .navigationTitle("National Parks")
                    .onAppear(perform: {
                        Task {
                            await fetchParks()
                            }
                })
                }
}

private func fetchParks() async {
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=ca&api_key=0VadIXWclIEPdpyyagyAyaYRW4F6bm9an6xd6PIK")!
        do {

            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)

            // Decode json data into ParksResponse type
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)

            // Get the array of parks from the response
            let parks = parksResponse.data

            // Print the full name of each park in the array
            for park in parks {
                print(park.fullName)
            }

            // Set the parks state property
            self.parks = parks

        } catch {
            print(error.localizedDescription)
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ParkRow: View {
    let park: Park

    var body: some View {
        
        // Park row
        Rectangle()
            .aspectRatio(4/3, contentMode: .fit)
            .overlay {
                // TODO: Get image url
                let image = park.images.first
                let urlString = image?.url
                let url = urlString.flatMap { string in URL(string: string)
                }
                
                AsyncImage(url: url) { image in image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray4)
                }
            }
            .overlay(alignment: .bottomLeading) {
                Text(park.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
            }
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }
}
