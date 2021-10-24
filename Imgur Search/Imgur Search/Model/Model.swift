//
//  Model.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import Foundation

struct ImgurResponse: Decodable {
    let data: [Image]
}

struct Image: Decodable, Hashable {
    let title: String
    let link: String
}
