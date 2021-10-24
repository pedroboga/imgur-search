//
//  Service.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import Foundation
import UIKit

class Service {
    
    static let shared = Service()
    let cache = NSCache<NSString, UIImage>()
    
    var clientId = ""
    var images = [Data]()
    private init() {
    }
    
    //func fetchImages(for query: String, _ completion: @escaping ([Data]?) -> Void) {
    func fetchImages(for query: String) {
        guard let url = URL(string: "https://api.imgur.com/3/gallery/search/?q=\(query)&q_type=jpeg&page=1") else { return }
        var request = URLRequest(url: url)
        request.setValue(clientId, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            
            if let data = data {
                let jsonDecodable = JSONDecoder()
                do {
                    let decode = try jsonDecodable.decode(ImgurResponse.self, from: data)
                    DispatchQueue.main.async {
                        //completion(decode.data)
                    }
                } catch {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }

}
