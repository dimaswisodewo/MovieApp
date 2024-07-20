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
        imageView.backgroundColor = .gray
        imageView.layer.masksToBounds = true
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
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .regular), scale: .large)
        let image = UIImage(systemName: "heart", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.backgroundColor = .black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let watchTrailerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Watch Trailer", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontUtils.shared.getFont(font: .Poppins, weight: .bold, size: 16)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .bold, size: 20)
        label.numberOfLines = 3
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .bold, size: 16)
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel: TitleDetailViewModel
    
    private let posterTemp: UIImage?
    private let isUseOfflineData: Bool
    private var isGradientAdded = false
    
    var onPopViewController: (() -> Void)?
    
    init(title: Title, poster: UIImage?, titleDetail: TitleDetail? = nil, backdrop: UIImage? = nil, isUseOfflineData: Bool = false) {
        self.viewModel = TitleDetailViewModel(title: title, titleDetail: titleDetail)
        self.posterTemp = backdrop ?? poster
        self.isUseOfflineData = isUseOfflineData
        
        super.init(nibName: nil, bundle: nil)
        
        // Disable watch trailer, can't search trailer on youtube when title is nil
        watchTrailerButton.isEnabled = !(title.originalTitle == nil && title.originalName == nil)
        
        if !isUseOfflineData {
            fetchData()
        }
    }
    
    deinit {
        viewModel.ongoingTask?.cancel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        backdropImageView.image = posterTemp
        titleLabel.text = viewModel.titleDetail?.name ?? viewModel.title.originalTitle ?? viewModel.title.originalName
        durationLabel.text = viewModel.title.releaseDate?.split(separator: "-").first?.description
        genreLabel.text = viewModel.titleDetail?.genres.map({ $0.name }).joined(separator: ", ")
        overviewLabel.text = viewModel.title.overview
        
        ratingLabel.text = "\(viewModel.title.voteAverage?.description ?? "0") (\(viewModel.title.voteCount?.description ?? "0") votes)"
        
        viewModel.isTitleLiked(titleId: viewModel.title.id) { [weak self] isLiked in
            guard let self = self else { return }
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .regular), scale: .large)
            if isLiked {
                DispatchQueue.main.async {
                    let image = UIImage(systemName: "heart.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
                    self.likeButton.setImage(image, for: .normal)
                    self.likeButton.tintColor = .systemRed
                }
            } else {
                DispatchQueue.main.async {
                    let image = UIImage(systemName: "heart", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
                    self.likeButton.setImage(image, for: .normal)
                    self.likeButton.tintColor = .white
                }
            }
        }
        
        setupViews()
        setupButtonEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isGradientAdded {
            addGradient()
            isGradientAdded = true
        }
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
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
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
            label.font = FontUtils.shared.getFont(font: .Poppins, weight: .bold, size: 14)
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
        
        let starImageView = UIImageView(image: UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate))
        starImageView.tintColor = .systemOrange
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backdropImageView)
        view.addSubview(backButton)
        view.addSubview(likeButton)
        view.addSubview(titleLabel)
        view.addSubview(durationLabel)
        view.addSubview(genreLabel)
        view.addSubview(overviewLabel)
        view.addSubview(ratingLabel)
        view.addSubview(watchTrailerButton)
        view.addSubview(hdLabelContainer)
        view.addSubview(starImageView)
        
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
            likeButton.topAnchor.constraint(equalTo: guide.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            genreLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -20),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            genreLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            durationLabel.bottomAnchor.constraint(equalTo: genreLabel.topAnchor, constant: -12),
            durationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            durationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 26),
            durationLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: durationLabel.topAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
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
            ratingLabel.centerYAnchor.constraint(equalTo: hdLabelContainer.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ratingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            ratingLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            starImageView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            starImageView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -4),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            starImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            overviewLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            watchTrailerButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            watchTrailerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            watchTrailerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            watchTrailerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButtonEvents() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        watchTrailerButton.addTarget(self, action: #selector(didTapWatchTrailerButton), for: .touchUpInside)
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
        if let completion = onPopViewController {
            navigationController?.popViewController(animated: true, completion: completion)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func didTapLikeButton() {
        viewModel.isTitleLiked(titleId: viewModel.title.id) { [weak self] isLiked in
            guard let self = self else { return }
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .regular), scale: .large)
            if isLiked {
                self.viewModel.unlikeTitle(titleId: viewModel.title.id) {
                    DispatchQueue.main.async {
                        let image = UIImage(systemName: "heart", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
                        self.likeButton.setImage(image, for: .normal)
                        self.likeButton.tintColor = .white
                    }
                }
            } else {
                let title = Title(
                    id: viewModel.title.id,
                    mediaType: viewModel.title.mediaType,
                    originalTitle: viewModel.title.originalTitle,
                    originalName: viewModel.title.originalName,
                    posterPath: viewModel.title.posterPath,
                    overview: viewModel.title.overview,
                    voteCount: viewModel.title.voteCount,
                    releaseDate: viewModel.title.category == .movie ? viewModel.title.releaseDate : viewModel.titleDetail?.lastAirDate,
                    voteAverage: viewModel.title.voteAverage
                )
                let titleDetail = viewModel.titleDetail ?? TitleDetail(
                    backdropPath: nil,
                    genres: [],
                    homepage: "",
                    title: title.originalTitle,
                    name: title.originalName,
                    originalTitle: title.originalTitle,
                    overview: title.overview ?? "",
                    posterPath: title.posterPath,
                    releaseDate: title.releaseDate,
                    lastAirDate: title.releaseDate
                )
                let backdrop = self.backdropImageView.image
                self.viewModel.likeTitle(title, titleDetail: titleDetail, poster: self.posterTemp, backdrop: backdrop) {
                    let image = UIImage(systemName: "heart.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
                    self.likeButton.setImage(image, for: .normal)
                    self.likeButton.tintColor = .systemRed
                }
            }
        }
    }
    
    @objc
    private func didTapWatchTrailerButton() {
        let title = viewModel.title
        
        let preview = TitlePreviewViewController()
        preview.configure(with: TitlePreview(
            id: title.id,
            title: title.originalTitle ?? title.originalName ?? "Null",
            overview: title.overview ?? title.originalName ?? "Null"
        ))
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.present(preview, animated: true)
        }
    }
}
