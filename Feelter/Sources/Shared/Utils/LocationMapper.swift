//
//  LocationMapper.swift
//  Feelter
//
//  Created by 이정동 on 8/11/25.
//

import CoreLocation
import Foundation

struct LocationMapper {
    static let shared = LocationMapper()
    private let geocoder = CLGeocoder()
    private init() {}
    
    func address(latitude: Double, longitude: Double) async -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return nil }
            return formattedAddress(from: placemark)
        } catch {
            // Geocoder error handling
            return nil
        }
    }
    
    private func formattedAddress(from placemark: CLPlacemark) -> String {
        var addressComponents: [String] = []
        
        // 국가
        if let country = placemark.country {
            addressComponents.append(country)
        }
        
        // 도시
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        
        // 도로명
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }
        
        return addressComponents.joined(separator: " ")
    }
}
