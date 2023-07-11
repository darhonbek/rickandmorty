//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import UIKit

protocol FlowCoordinatorProtocol: AnyObject {
    func start()
    func routeToCharacterDetails(characterId: Int, name: String)
}

final class FlowCoordinator: FlowCoordinatorProtocol {
    private let navigationController: UINavigationController
    private let networkService: NetworkServiceProtocol

    init(navigationController: UINavigationController, networkService: NetworkServiceProtocol) {
        self.navigationController = navigationController
        self.networkService = networkService
    }

    func start() {
        let viewModel = CharactersListViewModel(networkService: networkService, flowCoordinator: self)
        let viewController = CharactersListTableViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func routeToCharacterDetails(characterId: Int, name: String) {
        let characterDetailsViewModel = CharacterDetailsViewModel(characterId: characterId, networkService: networkService)
        let characterDetailsViewController = CharacterDetailsViewController(viewModel: characterDetailsViewModel)
        navigationController.pushViewController(characterDetailsViewController, animated: true)
        navigationController.title = name
    }
}
