//
//  CurrencyService.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import Foundation

import Foundation

protocol CurrencyServiceProtocol {
    func fetchRates(from: String, to: String, amount: Double, completion: @escaping (Result<CurrencyRate, Error>) -> Void)
    func cancelFetchRates()
}

class CurrencyService: CurrencyServiceProtocol {
    private var dataTask: URLSessionDataTask?

    func fetchRates(from: String, to: String, amount: Double, completion: @escaping (Result<CurrencyRate, Error>) -> Void) {
        let url = URL(string: "https://my.transfergo.com/api/fx-rates?from=\(from)&to=\(to)&amount=\(amount)")!
        dataTask?.cancel()
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("ERROR:11 \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                print("ERROR: data error")
                return
            }
            do {
                let rate = try JSONDecoder().decode(CurrencyRate.self, from: data)
                completion(.success(rate))
            } catch {
                completion(.failure(error))
                print("ERROR:22 \(error.localizedDescription)")
            }
        }
        dataTask?.resume()
    }

    func cancelFetchRates() {
        dataTask?.cancel()
    }
}
