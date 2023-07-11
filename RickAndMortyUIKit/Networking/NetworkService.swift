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
    func getCharactersList() async throws -> CharactersList
    func getCharacterDetails(id: Int) async throws -> Character
    func getImageData(urlString: String) async throws -> Data
}

final class NetworkService: NetworkServiceProtocol {
    private let decoder = JSONDecoder()

    func getCharactersList() async throws -> CharactersList {
        guard let url = URL(string: APIConfig.baseUrl + APIConfig.Endpoints.charactersList) else {
            throw NetworkError.invalidUrl
        }

        let data = try await fetchData(from: url)
        let model: CharactersList = try decode(data: data)
        return model
    }

    func getCharacterDetails(id: Int) async throws -> Character {
        guard let url = URL(string: APIConfig.baseUrl + APIConfig.Endpoints.characterDetails(id: id)) else {
            throw NetworkError.invalidUrl
        }

        let data = try await fetchData(from: url)
        let model: Character = try decode(data: data)
        return model
    }

    func getImageData(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidUrl
        }

        return try await fetchData(from: url)
    }

    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        return data
    }

    private func decode<T: Decodable>(data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}
