//
//  LocationSearchResponse.swift
//  LocationSearch
//
//  Created by Akhila on 12/03/2021.
//

import Foundation
struct LocationResponse: Decodable, Equatable {
    let predictions: [_locations]
    
    enum CodingKeys: String, CodingKey {
        case predictions = "predictions"
    }
    
}

extension LocationResponse{
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        predictions = try container.decode([_locations].self, forKey: .predictions)
    }
}

struct _locations: Decodable, Equatable, Hashable{
    let description: String
    let placeId: String
    
    enum CodingKeys: String, CodingKey, Hashable {
        case description = "description"
        case placeId = "place_id"
    }
}

struct LocationLatLngResponse: Decodable, Equatable , Hashable{
    let results: [Component]
    
    enum CodingKeys: String, CodingKey, Hashable {
        case results = "results"
    }
}

struct Component: Decodable ,Equatable, Hashable{
    let geometry: Geometry
    let place_id: String
    
    enum CodingKeys: String, CodingKey , Hashable{
        case geometry = "geometry"
        case place_id = "place_id"
        
    }
}

struct Geometry: Decodable ,Equatable, Hashable{
    let location: LocationCoordinates
    
    enum CodingKeys: String, CodingKey, Hashable {
        case location = "location"
        
    }
}

struct LocationCoordinates: Decodable ,Equatable, Hashable{
    let lat: Float
    let lng: Float
    
    enum CodingKeys: String, CodingKey, Hashable {
        case lat = "lat"
        case lng = "lng"
        
    }
}
