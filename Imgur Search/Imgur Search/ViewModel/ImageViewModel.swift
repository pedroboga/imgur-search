//
//  ImageViewModel.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import Foundation

class ImageViewModel {
    //private let service = Service()
    
    var images = [Image]()
    
    func fetchImages(for query: String) -> [Image] {
        Service.shared.fetchImages(for: query) { [weak self] images in
            guard let self = self else { return }
            
            guard let images = images else { return }
            self.images = images
        }
        
    return images
    }
}
