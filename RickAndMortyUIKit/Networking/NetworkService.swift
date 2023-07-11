//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

struct APIConfig {
    static let baseUrl = "https://rickandmortyapi.com/api"

    struct Endpoints {
        static let charactersList = "/character"

        static func characterDetails(id: Int) -> String {
            return "/character/\(id)"
        }
    }
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case parsingFailed
    case noData
    case networkError(Error)
}

protocol NetworkServiceProtocol {
    func getCharactersList(completion: @escaping (Result<CharactersList, NetworkError>) -> Void)
    func getCharacterDetails(id: Int, completion: @escaping (Result<Character, NetworkError>) -> Void)
    func getImage(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask?
}

final class NetworkService: NetworkServiceProtocol {
    func getCharactersList(completion: @escaping (Result<CharactersList, NetworkError>) -> Void) {
        guard let url = URL(string: APIConfig.baseUrl + APIConfig.Endpoints.charactersList) else {
            completion(.failure(.invalidUrl))
            return
        }

        _ = fetchData(from: url, completion: completion)
    }

    func getCharacterDetails(id: Int, completion: @escaping (Result<Character, NetworkError>) -> Void) {
        guard let url = URL(string: APIConfig.baseUrl + APIConfig.Endpoints.characterDetails(id: id)) else {
            completion(.failure(.invalidUrl))
            return
        }

        _ = fetchData(from: url, completion: completion)
    }

    func getImage(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return nil
        }

        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            completion(.success(data))
        }
        dataTask.resume()

        return dataTask
    }

    private func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask? {
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let decodedModel = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedModel))
            } catch {
                completion(.failure(.parsingFailed))
            }
        }
        dataTask.resume()

        return dataTask
    }
}
