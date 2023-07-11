//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import UIKit

protocol CharacterListCellViewModelProtocol: AnyObject {
    var name: String { get }

    func getImage(completion: @escaping (UIImage?) -> Void) async
    func cancelImageDownload()
}

final class CharacterListCellViewModel: CharacterListCellViewModelProtocol {
    var name: String {
        character.name
    }

    private let character: Character
    private let networkService: NetworkServiceProtocol
    private var imageFetchDataTask: Task<(), Never>?

    init(character: Character, networkService: NetworkServiceProtocol) {
        self.character = character
        self.networkService = networkService
    }

    func getImage(completion: @escaping (UIImage?) -> Void) async {
        guard imageFetchDataTask == nil else { return }

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
