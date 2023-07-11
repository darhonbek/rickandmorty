//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

protocol CharacterListCellViewModelProtocol: AnyObject {
    var name: String { get }

    func getImage() async throws -> Data
}

final class CharacterListCellViewModel: CharacterListCellViewModelProtocol {
    var name: String {
        character.name
    }

    private let character: Character
    private let networkService: NetworkServiceProtocol

    init(character: Character, networkService: NetworkServiceProtocol) {
        self.character = character
        self.networkService = networkService
    }

    func getImage() async throws -> Data {
        try await networkService.getImageData(url: character.imageUrl)
    }
}
