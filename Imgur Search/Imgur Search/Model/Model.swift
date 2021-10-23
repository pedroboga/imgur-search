//
//  Model.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import Foundation

struct ImgurResponse: Codable {
    let data: [Images]
}

struct Images: Codable {
    let title: String
    let link: String
}

