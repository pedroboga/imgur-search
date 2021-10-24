//
//  ImageViewModel.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import Foundation

class ImageViewModel {
    //private let service = Service()
    
    var images: [Data] = []
    
    func fetchImages(for query: String) -> [Data] {
            Service.shared.fetchImages(for: query) 
       
        
        return images
    }
}
