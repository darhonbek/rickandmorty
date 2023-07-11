//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import UIKit

protocol CharacterListCellViewModelProtocol: AnyObject {
    var name: String { get }

    func getImage(completion: @escaping (UIImage?) -> Void)
    func cancelImageDownload()
}

final class CharacterListCellViewModel: CharacterListCellViewModelProtocol {
    var name: String {
        character.name
    }

    private let character: Character
    private let networkService: NetworkServiceProtocol
    private var imageFetchDataTask: URLSessionDataTask?

    init(character: Character, networkService: NetworkServiceProtocol) {
        self.character = character
        self.networkService = networkService
    }

    func getImage(completion: @escaping (UIImage?) -> Void) {
        guard imageFetchDataTask == nil else { return }

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
