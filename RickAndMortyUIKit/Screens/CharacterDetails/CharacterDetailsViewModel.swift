//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

protocol CharacterDetailsViewModelProtocol: AnyObject {
    var name: String { get }

    func loadData() async throws
    func getImage() async throws -> Data
}

final class CharacterDetailsViewModel: CharacterDetailsViewModelProtocol {
    var name: String {
        character?.name ?? ""
    }

    private let characterId: Int
    private let networkService: NetworkServiceProtocol
    private var character: Character?

    init(characterId: Int, networkService: NetworkServiceProtocol) {
        self.characterId = characterId
        self.networkService = networkService
    }

    func loadData() async throws {
        character = try await networkService.getCharacterDetails(id: characterId)
    }

    func getImage() async throws -> Data {
        guard let character else {
            throw NetworkError.invalidUrl
        }
        return try await networkService.getImageData(url: character.imageUrl)
    }
}
