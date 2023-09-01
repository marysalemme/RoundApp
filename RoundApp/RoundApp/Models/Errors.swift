//
//  Errors.swift
//  RoundApp
//
//  Created by Mary Salemme on 19/08/2023.
//

import Foundation

enum RoundAppError: Error, CustomStringConvertible {
    case invalidURL
    case missingURL
    case invalidResponse
    case invalidData
    case invalidBody
    case primaryAccountNotFound
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .missingURL:
            return "Missing URL"
        case .invalidResponse:
            return "Invalid response"
        case .invalidData:
            return "Invalid data"
        case .invalidBody:
            return "Invalid body"
        case .primaryAccountNotFound:
            return "Primary account not found"
        }
    }
}
