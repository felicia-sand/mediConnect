// NetworkManager.swift
// MediConnect — Core/Network
//
// Created by Felicia on 25/10/2026.

import Foundation

// MARK: - Network Error
enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case serverError(Int)
    case unauthorized
    case networkUnavailable
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:           return "Invalid request URL."
        case .noData:               return "No data received from server."
        case .decodingFailed(let e): return "Failed to decode response: \(e.localizedDescription)"
        case .serverError(let code): return "Server error with code \(code)."
        case .unauthorized:         return "You are not authorized. Please log in again."
        case .networkUnavailable:   return "No internet connection available."
        case .unknown(let e):       return e.localizedDescription
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case GET, POST, PUT, PATCH, DELETE
}

// MARK: - API Request
struct APIRequest {
    let endpoint: String
    let method: HTTPMethod
    var headers: [String: String] = [:]
    var body: Data?
    
    var url: URL? {
        URL(string: AppConstants.API.baseURL + endpoint)
    }
}

// MARK: - NetworkManager
final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = AppConstants.API.timeout
        config.timeoutIntervalForResource = AppConstants.API.timeout
        return URLSession(configuration: config)
    }()
    
    // MARK: - Generic Request
    func request<T: Decodable>(_ apiRequest: APIRequest,
                               responseType: T.Type) async throws -> T {
        guard let url = apiRequest.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = apiRequest.body
        
        // Merge custom headers
        apiRequest.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
