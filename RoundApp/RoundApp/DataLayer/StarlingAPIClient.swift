//
//  StarlingAPIClient.swift
//  RoundApp
//
//  Created by Mary Salemme on 18/08/2023.
//

import Foundation

protocol StarlingAPIClientType {
    
    func getAccounts() async throws -> [Account]
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) async throws -> [FeedItem]
}

class StarlingAPIClient: StarlingAPIClientType {

    // MARK: - Dependecies

    private let urlSession: URLSession
    
    // MARK: - Properties

    let baseURL = "https://api-sandbox.starlingbank.com/api/v2"
    
    enum Endpoint {
        case accounts
        case transactions(accountID: String, categoryID: String)
        
        var value: String {
            switch self {
            case .accounts:
                return "accounts"
            case let .transactions(accountID, categoryID):
                return "feed/account/\(accountID)/category/\(categoryID)"
            }
        }
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
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) async throws -> [FeedItem] {
        let data = try await loadData(for: .transactions(accountID: accountID, categoryID: categoryID), parameters: ["changesSince" : sinceDate])
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(TransactionResponse.self, from: data).feedItems
        } catch {
            throw NetworkError.invalidData
        }
    }
    
    // MARK: - Private methods
    
    private func loadData(for endpoint: Endpoint, parameters: [String:String]? = nil) async throws -> Data {
        let url = try composeURL(for: endpoint)
        var request = URLRequest(url: url)
        appendHeaders(to: &request)
        if parameters != nil {
            try setQueryParameters(of: &request, parameters: parameters!)
        }
        let (data, response) = try await urlSession.data(for: request)
        
        try checkResponse(response)
        return data
    }
    
    private func setQueryParameters(of urlRequest: inout URLRequest, parameters: [String:String]) throws {
        guard let url = urlRequest.url else {
            throw NetworkError.missingURL
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponents.url
        }
    }
    
    private func appendHeaders(to request: inout URLRequest) {
        request.addValue("Bearer \(Auth.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("RoundApp", forHTTPHeaderField: "User-Agent")
    }
    
    private func composeURL(for endpoint: Endpoint) throws -> URL {
        guard let url = URL(string: "\(baseURL)/\(endpoint.value)") else {
            throw NetworkError.invalidURL
        }
        return url
    }
    
    private func checkResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
    }
}
