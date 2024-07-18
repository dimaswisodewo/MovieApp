//
//  TitleCollectionViewCell.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 17/07/24.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        posterImageView.frame = contentView.bounds
    }
    
    func configure(with model: Title) {
        guard let posterPath = model.posterPath,
              let url = URL(string: "\(Constants.imagePreviewBaseURL)/\(posterPath)") else {
            return
        }
        
        posterImageView.sd_setImage(with: url)
//        posterImageView.load(url: url, placeholder: nil)
    }
}
