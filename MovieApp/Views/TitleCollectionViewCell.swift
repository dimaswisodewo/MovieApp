//
//  TitleCollectionViewCell.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 17/07/24.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var posterImage: UIImage? {
        return posterImageView.image
    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
    }
    
    func configure(with model: Title) {
        guard let posterPath = model.posterPath,
              let url = URL(string: "\(Constants.imagePreviewBaseURL)\(posterPath)") else {
            return
        }
        
        posterImageView.load(url: url, placeholder: nil)
    }
}
