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
    
    let viewModel = ImageViewModel()
    var images = [Image]()
    
    let searchbar = UISearchBar()
    
    lazy var imageCollection: UICollectionView = {
        var collection = UICollectionView(frame: .zero, collectionViewLayout: configureFlow())
        collection.backgroundColor = .systemBackground
        collection.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseId)
        
        return collection
        
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Image>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureView()
        
        fetchPhotos(for: "cats")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchbar.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20, height: 50)
        imageCollection.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 55, width: view.frame.size.width - 20, height: view.frame.size.height - 55)
    }
    
    func configureSearchBar() {
        searchbar.delegate = self
        view.addSubview(searchbar)
    }
    
    func configureView() {
        imageCollection.delegate = self
        imageCollection.dataSource = self
        view.addSubview(imageCollection)
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
    
    func fetchPhotos(for query: String) {
        DispatchQueue.main.async {
            self.images = self.viewModel.fetchImages(for: query)
            self.imageCollection.reloadData()
        }
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString = images[indexPath.row].link
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.setImage(with: imageUrlString)
        return cell
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            images = []
            imageCollection.reloadData()
            fetchPhotos(for: text)
        }
    }
}
