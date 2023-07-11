//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

protocol CharacterDetailsViewModelProtocol: AnyObject {
    var name: String { get }

    func loadData() async
    func getImage(completion: @escaping (UIImage?) -> Void) async
    func cancelImageDownload()
}

final class CharacterDetailsViewModel: CharacterDetailsViewModelProtocol {
    var name: String {
        character?.name ?? ""
    }

    private let characterId: Int
    private let networkService: NetworkServiceProtocol
    private var character: Character?
    private var imageFetchDataTask: Task<(), Never>?

    init(characterId: Int, networkService: NetworkServiceProtocol) {
        self.characterId = characterId
        self.networkService = networkService
    }

    func loadData() async {
        do {
            character = try await networkService.getCharacterDetails(id: characterId)
        } catch {
            // Tell UI to show error
        }
    }

    func getImage(completion: @escaping (UIImage?) -> Void) async {
        guard imageFetchDataTask == nil, let character else { return }

        imageFetchDataTask = Task {
            do {
                let imageData = try await networkService.getImageData(urlString: character.imageUrl)
                completion(UIImage(data: imageData))
            } catch {
                completion(nil)
            }
        }
    }

    func cancelImageDownload() {
        imageFetchDataTask?.cancel()
        imageFetchDataTask = nil
    }
}
