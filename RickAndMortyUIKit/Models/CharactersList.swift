//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

struct CharactersList: Decodable {
    let characters: [Character]

    enum CodingKeys: String, CodingKey {
        case characters = "results"
    }
}
