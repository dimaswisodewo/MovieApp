//
//  CollectionParallaxTableViewCell.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import UIKit

protocol CollectionParallaxTableViewCellDelegate: AnyObject {
    func collectionParallaxDidTapCell( _ title: Title, poster: UIImage?)
}

class CollectionParallaxTableViewCell: UITableViewCell {

    static let identifier = "CollectionParallaxTableViewCell"
    
    weak var delegate: CollectionParallaxTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let inset: CGFloat = 16
        let width = UIScreen.main.bounds.width - (CGFloat(2) * inset)
        let height = width * 1.67
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 4
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return cv
    }()
    
    private var titles: [Title] = []
    private var selectedCellIndex: Int = 0
    private let inset: CGFloat = 16
    private lazy var screenWidth = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func setSelectedCellOnEndSwipe(scrollViewOffset: CGFloat, cellWidth: CGFloat) {
        let numberOfSpacing = Int(round((scrollViewOffset - (2 * inset)) / cellWidth))
        selectedCellIndex = Int(round((scrollViewOffset -  (2 * inset) - CGFloat(numberOfSpacing * 8)) / cellWidth))
        
        // Clamp value
        if selectedCellIndex < 0 {
            selectedCellIndex = 0
        } else if selectedCellIndex >= titles.count {
            selectedCellIndex = titles.count - 1
        }
        
        collectionView.selectItem(
            at: IndexPath(item: selectedCellIndex, section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
}

extension CollectionParallaxTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model = titles[indexPath.item]
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TitleCollectionViewCell else { return }
        
        let model = titles[indexPath.row]
        
        delegate?.collectionParallaxDidTapCell(model, poster: cell.posterImage)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let itemWidth = collectionView.bounds.width - (CGFloat(2) * inset)
        let offset = scrollView.contentOffset.x
        setSelectedCellOnEndSwipe(scrollViewOffset: offset, cellWidth: itemWidth)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemWidth = collectionView.bounds.width - (CGFloat(2) * inset)
        let offset = scrollView.contentOffset.x
        setSelectedCellOnEndSwipe(scrollViewOffset: offset, cellWidth: itemWidth)
    }
}
