//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

protocol CharactersListViewModelProtocol: AnyObject {
    var numberOfRows: Int { get }

    func loadData() async
    func cellViewModel(forRowAt indexPath: IndexPath) -> CharacterListCellViewModelProtocol?
    func didSelectRow(at indexPath: IndexPath)
}

final class CharactersListViewModel: CharactersListViewModelProtocol {

    private let networkService: NetworkServiceProtocol
    private weak var flowCoordinator: FlowCoordinatorProtocol?

    private var characters: [Character] = []

    init(networkService: NetworkServiceProtocol, flowCoordinator: FlowCoordinatorProtocol) {
        self.networkService = networkService
        self.flowCoordinator = flowCoordinator
    }

    func loadData() async {
        do {
            characters = try await networkService.getCharactersList().characters
        } catch {
            // Tell UI to show error
        }
    }

    var numberOfRows: Int {
        characters.count
    }

    func cellViewModel(forRowAt indexPath: IndexPath) -> CharacterListCellViewModelProtocol? {
        guard indexPath.row < characters.count else { return nil }

        let character = characters[indexPath.row]
        return CharacterListCellViewModel(character: character, networkService: networkService)
    }

    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.row < characters.count else { return }

        let character = characters[indexPath.row]
        flowCoordinator?.routeToCharacterDetails(characterId: character.id, name: character.name)
    }
}
