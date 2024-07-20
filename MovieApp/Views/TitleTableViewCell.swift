//
//  TitleTableViewCell.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 19/07/24.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var poster: UIImage? {
        return posterImageView.image
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .bold, size: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .bold, size: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = nil
    }
    
    private func setupView() {
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate))
        starImageView.tintColor = .systemOrange
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(starImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 140 * 0.67),
            posterImageView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            starImageView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 12),
            starImageView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    func configure(with model: Title, posterImage: UIImage? = nil) {
        titleLabel.text = model.originalTitle ?? model.originalName ?? "Null"
        subtitleLabel.text = model.releaseDate?.split(separator: "-").first?.description ?? "Null"
        descriptionLabel.text = "\(model.voteAverage?.description ?? "") (\(model.voteCount?.description ?? "") votes)"
        
        if let img = posterImage {
            posterImageView.image = img
        } else if let posterPath = model.posterPath, let url = URL(string: "\(Constants.imagePreviewBaseURL)\(posterPath)") {
            posterImageView.load(url: url, placeholder: nil)
        }
    }
}
