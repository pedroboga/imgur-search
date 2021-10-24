//
//  ViewController.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import UIKit

class ViewController: UIViewController {
    private let service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        self.fetchImages()
    }
    
    private func fetchImages() {
        self.service.fetchImages { images in
            print(images?.data.first)
        }
    }

}

