//
//  SearchResultViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import UIKit

class SearchResultViewController: UIViewController {

    private var searchResults: [Title] = []
    
    private lazy var collectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return cv
    }()
    
    var onDismissPreview: (() -> Void)?
    
    func configureSearchResults(results: [Title]) {
        searchResults = results
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = searchResults[indexPath.item]
        cell.configure(with: title)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let preview = TitlePreviewViewController()

        let title = searchResults[indexPath.item]
        
        preview.configure(with: TitlePreview(
            id: title.id,
            title: title.originalTitle ?? title.originalName ?? "Null",
            overview: title.overview ?? title.originalName ?? "Null"
        ))
        
        preview.onDismiss = onDismissPreview
        
        DispatchQueue.main.async { [weak self] in
            guard let parentVC = self?.presentingViewController else { return }
            parentVC.dismiss(animated: false, completion: {
                parentVC.navigationController?.present(preview, animated: true)
            })
        }
    }
}
