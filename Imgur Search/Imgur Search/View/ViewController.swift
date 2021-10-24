//
//  ViewController.swift
//  Imgur Search
//
//  Created by Pedro Boga on 23/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    //let viewModel = ImageViewModel()
    var images = [Data]()
    
    var clientId = "Client-ID 1ceddedc03a5d71"
    
    let searchbar = UISearchController()
//
    private var imageCollectionView: UICollectionView?
    
//    lazy var imageCollection: UICollectionView = {
//        var collection = UICollectionView(frame: .zero, collectionViewLayout: configureFlow())
//        collection.backgroundColor = .systemBackground
//        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
//
//        return collection
//
//    }()
    
    //var dataSource: UICollectionViewDiffableDataSource<Section, Image>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureView()
        fetchImages(for: "lula")
        
    }
    
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
                        self.images = decode.data
                        self.imageCollectionView?.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageCollectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }

    func configureSearchBar() {
        title = "Imgur Search Bugado"
        searchbar.searchResultsUpdater = self
        navigationItem.searchController = searchbar
    }

    func configureView() {
        let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureFlow())
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        self.imageCollectionView = imageCollectionView
        view.addSubview(imageCollectionView)
    }
    
    private func configureFlow() -> UICollectionViewFlowLayout {
        let sidePadding: CGFloat = 6
        let imageSpacing: CGFloat = 2
        let availabeWidth = view.bounds.width - (sidePadding * 2) - (imageSpacing * 2)
        let itemWidth = availabeWidth / 5

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: sidePadding, left: sidePadding, bottom: sidePadding, right: sidePadding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        return flowLayout
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString = images[indexPath.row].link
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.downloadImage(from: imageUrlString)
        return cell
    }

}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        fetchImages(for: text)
        imageCollectionView?.reloadData()
    }
}
