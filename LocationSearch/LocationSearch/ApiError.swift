//
//  ApiError.swift
//  LocationSearch
//
//  Created by Akhila on 12/03/2021.
//

import Foundation
//// Returns description of error
struct ApiError: LocalizedError, Equatable {
    
    private var description: String!
    
    init(description: String) {
        self.description = description
    }
    
    public var errorDescription: String? {
        return description
    }
    
    public static func ==(lhs: ApiError, rhs: ApiError) -> Bool {
        return lhs.description == rhs.description
    }
}
