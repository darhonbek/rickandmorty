//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let imageUrl: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image"
    }
}
