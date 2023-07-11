//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import UIKit

protocol CharacterDetailsViewModelProtocol: AnyObject {
    var name: String { get }

    func loadData(completion: @escaping () -> Void)
    func getImage(completion: @escaping (UIImage?) -> Void)
    func cancelImageDownload()
}

final class CharacterDetailsViewModel: CharacterDetailsViewModelProtocol {
    var name: String {
        character?.name ?? ""
    }

    private let characterId: Int
    private let networkService: NetworkServiceProtocol
    private var character: Character?
    private var imageFetchDataTask: URLSessionDataTask?

    init(characterId: Int, networkService: NetworkServiceProtocol) {
        self.characterId = characterId
        self.networkService = networkService
    }

    func loadData(completion: @escaping () -> Void) {
        networkService.getCharacterDetails(id: characterId) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let character):
                self.character = character
                completion()
            case .failure:
                // Tell UI to show error
                break
            }
        }
    }

    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard imageFetchDataTask == nil, let character else { return }

        imageFetchDataTask = networkService.getImage(urlString: character.imageUrl) { result in
            switch result {
            case .success(let data):
                completion(UIImage(data: data))
            case .failure:
                completion(nil)
            }
        }
    }

    func cancelImageDownload() {
        imageFetchDataTask?.cancel()
        imageFetchDataTask = nil
    }
}
