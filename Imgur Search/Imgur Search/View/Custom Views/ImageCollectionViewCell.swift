//
//  ImageCollectionViewCell.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let reuseId = "ImageCell"
    let cache = Service.shared.cache
    
    private let imageView: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.backgroundColor = .systemGray
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func downloadImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            self.imageView.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                self.imageView.image = image
            }

        }
        task.resume()
    }
}
