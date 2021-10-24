//
//  Service.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import Foundation

struct Service {
    func fetchImages(_ completion: @escaping (ImgurResponse?) -> Void) {
        guard let url = URL(string: "https://api.imgur.com/3/gallery/search/viral/?q=cats") else { return }
        var request = URLRequest(url: url)
        request.setValue("Client-ID ", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            if let _ = error {
                completion(nil)
                return
            }
            
            if let data = data {
                let jsonDecodable = JSONDecoder()
                do {
                    let imagens = try jsonDecodable.decode(ImgurResponse.self, from: data)
                    completion(imagens)
                } catch {
                    print(error)
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }
    
}


// let request = NSMutableURLRequest(url: url! as URL)
// request.setValue("Client-ID 1ceddedc03a5d71", forHTTPHeaderField: "Authorization") //**
// request.httpMethod = "GET"
// request.addValue("application/json", forHTTPHeaderField: "Content-Type")
// let session = URLSession.shared
//
// let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//     if let data = data {
//         print(data)
//     }
//
//     if let res = response as? HTTPURLResponse {
//         //print("res: \(String(describing: res))")
//         //print("Response: \(String(describing: response))")
//     }else{
//         print("Error: \(String(describing: error))")
//     }
// }
// mData.resume()
//
                                                                                    
