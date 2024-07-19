//
//  TitleDetailViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 19/07/24.
//

import UIKit

class TitleDetailViewController: UIViewController {
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .regular), scale: .large)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 3
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel: TitleDetailViewModel
    
    private let posterTemp: UIImage?
    
    init(title: Title, poster: UIImage?) {
        viewModel = TitleDetailViewModel(title: title)
        posterTemp = poster
        
        super.init(nibName: nil, bundle: nil)
        
        fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        backdropImageView.image = posterTemp
        titleLabel.text = viewModel.title.originalTitle ?? viewModel.title.originalName
        durationLabel.text = viewModel.title.releaseDate
        overviewLabel.text = viewModel.title.overview
        
        setupViews()
        setupButtonEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addGradient()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.6)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = backdropImageView.bounds
        backdropImageView.layer.addSublayer(gradient)
    }
    
    private func setupViews() {
        
        let hdLabel: UILabel = {
            let label = UILabel()
            label.text = "HD"
            label.textAlignment = .center
            label.textColor = .yellow
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let hdLabelContainer: UIView = {
            let container = UIView()
            container.backgroundColor = .clear
            container.layer.borderWidth = 2
            container.layer.borderColor = UIColor.yellow.cgColor
            container.layer.cornerRadius = 8
            container.translatesAutoresizingMaskIntoConstraints = false
            return container
        }()
        
        hdLabelContainer.addSubview(hdLabel)
        hdLabel.frame = hdLabelContainer.bounds
        
        view.addSubview(backdropImageView)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(durationLabel)
        view.addSubview(genreLabel)
        view.addSubview(overviewLabel)
        view.addSubview(hdLabelContainer)
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: guide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            genreLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -20),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            genreLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            durationLabel.bottomAnchor.constraint(equalTo: genreLabel.topAnchor, constant: -12),
            durationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            durationLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            hdLabelContainer.centerYAnchor.constraint(equalTo: durationLabel.centerYAnchor),
            hdLabelContainer.leadingAnchor.constraint(equalTo: durationLabel.trailingAnchor, constant: 8),
            hdLabelContainer.widthAnchor.constraint(equalToConstant: 30),
            hdLabelContainer.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            hdLabel.topAnchor.constraint(equalTo: hdLabelContainer.topAnchor),
            hdLabel.bottomAnchor.constraint(equalTo: hdLabelContainer.bottomAnchor),
            hdLabel.leadingAnchor.constraint(equalTo: hdLabelContainer.leadingAnchor),
            hdLabel.trailingAnchor.constraint(equalTo: hdLabelContainer.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: durationLabel.topAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            overviewLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    private func setupButtonEvents() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func fetchData() {
        viewModel.getMovieDetail { [weak self] titleDetail in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let backdropPath = titleDetail.backdropPath, let url = URL(string: "\(Constants.imageBackdropBaseURL)\(backdropPath)") {
                    self.backdropImageView.load(url: url, placeholder: nil)
                }
                
                let category = self.viewModel.title.category
                if category == .movie {
                    let originalTitle = titleDetail.originalTitle ?? titleDetail.title ?? "Null"
                    self.titleLabel.text = originalTitle
                    
                    let releaseDate = titleDetail.releaseDate?.split(separator: "-").first?.description ?? "Null"
                    self.durationLabel.text = releaseDate
                } else {
                    let originalName = titleDetail.name ?? "Null"
                    self.titleLabel.text = originalName
                    
                    let lastAirDate = titleDetail.lastAirDate?.split(separator: "-").first?.description ?? "Null"
                    self.durationLabel.text = lastAirDate
                }
                
                self.genreLabel.text = titleDetail.genres.map({ $0.name }).joined(separator: ", ")
            }
        }
    }
    
    @objc
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
