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
    
    func getSavingsGoals(accountID: String) async throws -> [SavingsGoal]
    
    func getSavingsGoal(accountID: String, savingsGoalID: String) async throws -> SavingsGoal
    
    func createSavingGoal(accountID: String, goal: SavingsGoal) async throws -> SavingsGoalCreated
    
    func addMoneyToSavingGoal(accountID: String, savingsGoalID: String, transferRequest: SavingsGoalTransferRequest) async throws -> SavingsGoalTransfer
}

class StarlingAPIClient: StarlingAPIClientType {

    // MARK: - Dependecies

    private let urlSession: URLSession
    
    // MARK: - Properties

    let baseURL = "https://api-sandbox.starlingbank.com/api/v2"
    
    enum Endpoint {
        case accounts
        case transactions(accountID: String, categoryID: String)
        case savingGoals(accountID: String)
        case savingsGoal(accountID: String, savingsGoalID: String)
        case addToSavingGoal(accountID: String, savingsGoalID: String, transferID: String)
        
        var value: String {
            switch self {
            case .accounts:
                return "accounts"
            case let .transactions(accountID, categoryID):
                return "feed/account/\(accountID)/category/\(categoryID)"
            case let .savingGoals(accountID):
                return "account/\(accountID)/savings-goals"
            case let .savingsGoal(accountID, savingsGoalID):
                return "account/\(accountID)/savings-goals/\(savingsGoalID)"
            case let .addToSavingGoal(accountID, savingsGoalID, transferID):
                return "account/\(accountID)/savings-goals/\(savingsGoalID)/add-money/\(transferID)"
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
            throw RoundAppError.invalidData
        }
    }
    
    func getTransactions(accountID: String, categoryID: String, sinceDate: String) async throws -> [FeedItem] {
        let data = try await loadData(for: .transactions(accountID: accountID, categoryID: categoryID), parameters: ["changesSince" : sinceDate])
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(TransactionResponse.self, from: data).feedItems
        } catch {
            throw RoundAppError.invalidData
        }
    }
    
    func getSavingsGoals(accountID: String) async throws -> [SavingsGoal] {
        let data = try await loadData(for: .savingGoals(accountID: accountID))
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SavingsGoalsResponse.self, from: data).savingsGoalList
        } catch {
            throw RoundAppError.invalidData
        }
    }
    
    func getSavingsGoal(accountID: String, savingsGoalID: String) async throws -> SavingsGoal {
        let data = try await loadData(for: .savingsGoal(accountID: accountID, savingsGoalID: savingsGoalID))
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SavingsGoal.self, from: data)
        } catch {
            throw RoundAppError.invalidData
        }
    }
    
    func createSavingGoal(accountID: String, goal: SavingsGoal) async throws -> SavingsGoalCreated {
        let body = try encodeBody(goal)
        let data = try await loadData(for: .savingGoals(accountID: accountID),
                                      body: body,
                                      httpMethod: .put)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SavingsGoalCreated.self, from: data)
        } catch {
            throw RoundAppError.invalidData
        }
    }
    
    func addMoneyToSavingGoal(accountID: String,
                              savingsGoalID: String,
                              transferRequest: SavingsGoalTransferRequest) async throws -> SavingsGoalTransfer {
        let body = try encodeBody(transferRequest)
        let data = try await loadData(for: .addToSavingGoal(accountID: accountID, savingsGoalID: savingsGoalID, transferID: UUID().uuidString),
                                      body: body,
                                      httpMethod: .put)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SavingsGoalTransfer.self, from: data)
        } catch {
            throw RoundAppError.invalidData
        }
    }
    
    // MARK: - Private methods
    
    private func loadData(for endpoint: Endpoint,
                          parameters: [String:String]? = nil,
                          body: Data? = nil,
                          httpMethod: HTTPMethod = .get) async throws -> Data {
        let url = try composeURL(for: endpoint)
        var request = URLRequest(url: url)
        appendHeaders(to: &request)
        if parameters != nil {
            try setQueryParameters(of: &request, parameters: parameters!)
        }
        if body != nil {
            request.httpBody = body
        }
        request.httpMethod = httpMethod.rawValue
        let (data, response) = try await urlSession.data(for: request)
        
        try checkResponse(response)
        return data
    }
    
    private func setQueryParameters(of urlRequest: inout URLRequest, parameters: [String:String]) throws {
        guard let url = urlRequest.url else {
            throw RoundAppError.missingURL
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
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("RoundApp", forHTTPHeaderField: "User-Agent")
    }
    
    private func composeURL(for endpoint: Endpoint) throws -> URL {
        guard let url = URL(string: "\(baseURL)/\(endpoint.value)") else {
            throw RoundAppError.invalidURL
        }
        return url
    }
    
    private func checkResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RoundAppError.invalidResponse
        }
    }
    
    private func encodeBody<T: Encodable>(_ body: T) throws -> Data {
        do {
            let encoder = JSONEncoder()
            return try encoder.encode(body)
        } catch {
            throw RoundAppError.invalidBody
        }
    }
}
