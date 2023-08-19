//
//  StarlingAPIClient.swift
//  RoundApp
//
//  Created by Mary Salemme on 18/08/2023.
//

import Foundation

protocol StarlingAPIClientType {
    func getAccounts() async throws -> [Account]
}

class StarlingAPIClient: StarlingAPIClientType {

    // MARK: - Dependecies

    private let urlSession: URLSession
    
    // MARK: - Properties

    let baseURL = "https://api-sandbox.starlingbank.com/api/v2"
    
    enum Endpoint: String {
        case accounts = "accounts"
    }
    
    // MARK: - Initialiser
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Public methods
    
    func getAccounts() async throws -> [Account] {
        let data = try await loadData(for: .accounts)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Response.self, from: data).accounts
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    // MARK: - Helper methods
    
    func appendHeaders(to request: inout URLRequest) {
        request.addValue("Bearer \(Auth.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("RoundApp", forHTTPHeaderField: "User-Agent")
    }
    
    func composeURL(for endpoint: Endpoint) throws -> URL {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    private func checkResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
    }
    
    private func loadData(for endpoint: Endpoint) async throws -> Data {
        let url = try composeURL(for: endpoint)
        var request = URLRequest(url: url)
        appendHeaders(to: &request)
        let (data, response) = try await urlSession.data(for: request)
        
        try checkResponse(response)
        return data
    }
}
