//
//  Errors.swift
//  RoundApp
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case missingURL
    case invalidResponse
    case invalidData
}

enum StarlingError: Error {
    case primaryAccountNotFound
    
    var description: String {
        switch self {
        case .primaryAccountNotFound:
            return "Primary account not found"
        }
    }
}
