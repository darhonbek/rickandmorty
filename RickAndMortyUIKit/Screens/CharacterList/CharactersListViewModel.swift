//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

protocol CharactersListViewModelProtocol: AnyObject {
    var numberOfRows: Int { get }

    func loadData(completion: @escaping () -> Void)
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

    func loadData(completion: @escaping () -> Void) {
        networkService.getCharactersList { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let charactersList):
                self.characters = charactersList.results
                completion()
            case .failure:
                // Tell UI to show error
                break
            }
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
