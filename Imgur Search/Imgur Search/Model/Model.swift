//
//  Model.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import Foundation

struct ImgurResponse: Decodable {
    let data: [Data]
}

struct Data: Decodable {
    //let title: String
    let link: String
    var images: [Image]?
}

struct Image: Decodable, Hashable {
    let link: String?
}
