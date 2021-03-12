//
//  WebService.swift
//  LocationSearch
//
//  Created by Akhila on 12/03/2021.
//

import Foundation
import ComposableArchitecture

struct WebService {
    let locationSearch: (String, String) -> Effect<LocationResponse, ApiError>
    let getLocationLatLng: (String, String) -> Effect<LocationLatLngResponse, ApiError>
}

extension WebService {
   
  public static let live = WebService (
    locationSearch: { searchTerm, googleApiKey in
           let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchTerm)&components=country:UK&key=\(googleApiKey)"
           var request = URLRequest(url: URL(string: url)!)
           ////Mark: Making url request
           
           request.httpMethod = "POST"
           request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           
           
           return URLSession.shared.dataTaskPublisher(for: request)
               .map { data, _ in data }
               .decode(type: LocationResponse.self, decoder: jsonDecoder)
               .mapError{
                   return ApiError(description: $0.localizedDescription)
               }
               .eraseToEffect()
    },
    getLocationLatLng: { placeId, googleApiKey in
        let url = "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(placeId)&key=\(googleApiKey)"
        var request = URLRequest(url: URL(string: url)!)
        ////Mark: Making url request
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, _ in data }
            .decode(type: LocationLatLngResponse.self, decoder: jsonDecoder)
            .mapError{
                return ApiError(description: $0.localizedDescription)
            }
            .eraseToEffect()
 }
   )
}

let jsonDecoder: JSONDecoder = {
   let d = JSONDecoder()
   let formatter = DateFormatter()
   formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
   d.dateDecodingStrategy = .formatted(formatter)
   return d
}()
