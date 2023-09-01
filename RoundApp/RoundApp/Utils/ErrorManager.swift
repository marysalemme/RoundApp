//
//  ErrorManager.swift
//  RoundApp
//
//  Created by Mary Salemme on 01/09/2023.
//

import Foundation

class ErrorManager {
    static func handleError(error: Error) -> String {
        switch error {
        case RoundAppError.invalidBody:
            return RoundAppError.invalidBody.description
        case RoundAppError.invalidData:
            return RoundAppError.invalidData.description
        case RoundAppError.invalidResponse:
            return RoundAppError.invalidResponse.description
        case RoundAppError.invalidURL:
            return RoundAppError.invalidURL.description
        case RoundAppError.missingURL:
            return RoundAppError.missingURL.description
        case RoundAppError.primaryAccountNotFound:
            return RoundAppError.primaryAccountNotFound.description
        default:
            return "Unknown Error"
        }
    }
}
