//
//  location.swift
//  CosmicRoots
//
//  Created by Esra Ataç on 5.10.2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    @Published var city: String = ""
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var isLoading = false
    
    private let geocoder = CLGeocoder()
    
    func fetchCoordinates() async {
        guard !city.isEmpty else { return }
        isLoading = true
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(city)
            if let location = placemarks.first?.location {
                DispatchQueue.main.async {
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    self.isLoading = false
                }
            }
        } catch {
            print("Error finding coordinates: \(error)")
            isLoading = false
        }
    }
}
