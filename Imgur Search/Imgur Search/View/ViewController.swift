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
    
    var clientId = ""
    
    let searchbar = UISearchController()
    var queryText = "corinthians"
    var pageCount = 1
    var moreResults = true

    private var imageCollectionView: UICollectionView?
    
    //var dataSource: UICollectionViewDiffableDataSource<Section, Data>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureView()
        fetchImages(for: queryText, page: pageCount)
        
    }
    
    func fetchImages(for query: String, page: Int) {
        guard let url = URL(string: "https://api.imgur.com/3/gallery/search/?q=\(query)&q_type=jpeg&page=\(page)") else { return }
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
                        //if self.images.count < 100 { self.moreResults = false }
                        self.images.append(contentsOf: decode.data)
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
    
//    private func configureDataSource() {
//        dataSource = UICollectionViewDiffableDataSource<Section, Data>(collectionView: imageCollectionView!, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseId, for: indexPath) as! ImageCollectionViewCell
//            //cell.downloadImage(from: self.images[indexPath.row].link)
//            cell.downloadImage(from: itemIdentifier.link)
//            return cell
//        })
//    }
    
//    func updateData() {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Data>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(images)
//        DispatchQueue.main.async {
//            self.dataSource.apply(snapshot, animatingDifferences: true)
//        }
//    }
    
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
        queryText = text
        images = []
        pageCount = 1
        fetchImages(for: queryText, page: pageCount)
        //self.updateData()
        self.imageCollectionView?.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            //guard moreResults else { return }
            pageCount += 1
            fetchImages(for: queryText, page: pageCount)
            self.imageCollectionView?.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destVc = ImageDetailViewController()
        let navCont = UINavigationController(rootViewController: destVc)
        destVc.imageTitle = images[indexPath.row].title
        destVc.imageUrl = images[indexPath.row].link
        present(navCont, animated: true)
    }
    
}
