//
//  NetworkService.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 8.07.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func execute<T: Decodable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void)
    func cancelTask() // TODO: hold task identifier, now we do not know which task cancelled, if we send more api requests later
}

class NetworkService: NetworkServiceProtocol {
    private var dataTask: URLSessionDataTask?
    
    func execute<T: Decodable>(_ request: Request, completion: @escaping (Result<T, Error>) -> Void) {
        let urlString = APIConfig.baseURLString + request.path
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.urlError))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.networkRequestFailed))
                Logger.warning("Network Error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) == false {
                completion(.failure(NetworkError.serverError(statusCode: httpResponse.statusCode)))
                Logger.warning("Server Error: \(httpResponse.statusCode)")
                return
            }
            
            if let data = data {
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(NetworkError.decodingError))
                    Logger.warning("Decoding Error: \(error.localizedDescription)")
                }
            } else {
                completion(.failure(NetworkError.networkRequestFailed))
                Logger.warning("Network Request Failed: No data")
            }
        }.resume()
    }
    
    func cancelTask() {
        dataTask?.cancel()
        Logger.warning("Network - Cancel Task Called")
    }
    
}
