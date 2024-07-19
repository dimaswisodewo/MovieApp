//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 17/07/24.
//

import UIKit

fileprivate enum Sections: Int, CaseIterable {
    case nowPlaying = 0
    case trendingMovies = 1
    case trendingTvs = 2
    case popular = 3
    case upcoming = 4
    case topRated = 5
}

class HomeViewController: UIViewController {
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tableView.register(CollectionParallaxTableViewCell.self, forCellReuseIdentifier: CollectionParallaxTableViewCell.identifier)
        return tableView
    }()
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeFeedTable)
        
        view.backgroundColor = .systemBackground
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        configureRefreshControl()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavbar() {
        guard let image = UIImage(named: "Netflix Logo Initial")?.withRenderingMode(.alwaysOriginal)
        else { return }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = image
        
        let imageContainer = UIControl(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageContainer.addTarget(self, action: #selector(didTapLogoButton), for: .touchUpInside)
        imageContainer.addSubview(imageView)
        let leftBarButtonItem = UIBarButtonItem(customView: imageContainer)
        leftBarButtonItem.width = 20
        
        let searchImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchImageView.image = UIImage(systemName: "magnifyingglass")
        let searchContainer = UIControl(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchContainer.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        searchContainer.addSubview(searchImageView)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), style: .done, target: self, action: nil),
            UIBarButtonItem(customView: searchContainer)
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func configureRefreshControl() {
        homeFeedTable.refreshControl = UIRefreshControl()
        homeFeedTable.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc
    private func handleRefreshControl() {
        fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.homeFeedTable.refreshControl?.endRefreshing()
        }
    }
    
    @objc
    private func didTapLogoButton() {
        print("tap logo")
    }
    
    @objc
    private func didTapSearchButton() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func fetchData() {
        viewModel.getNowPlayingMovies {
            DispatchQueue.main.async { [weak self] in
                self?.homeFeedTable.reloadSections(IndexSet(integer: Sections.nowPlaying.rawValue), with: .fade)
            }
        } onError: {
            
        }
        
        viewModel.getTrendingMovies { [weak self] in
            DispatchQueue.main.async {
                self?.homeFeedTable.reloadSections(IndexSet(integer: Sections.trendingMovies.rawValue), with: .fade)
            }
        } onError: {
            
        }

        viewModel.getTrendingTvs { [weak self] in
            DispatchQueue.main.async {
                self?.homeFeedTable.reloadSections(IndexSet(integer: Sections.trendingTvs.rawValue), with: .fade)
            }
        } onError: {
            
        }
        
        viewModel.getPopularMovies { [weak self] in
            DispatchQueue.main.async {
                self?.homeFeedTable.reloadSections(IndexSet(integer: Sections.popular.rawValue), with: .fade)
            }
        } onError: {
            
        }
        
        viewModel.getUpcomingMovies() { [weak self] in
            DispatchQueue.main.async {
                self?.homeFeedTable.reloadSections(IndexSet(integer: Sections.upcoming.rawValue), with: .fade)
            }
        } onError: {
            
        }

        viewModel.getTopRatedMovies() { [weak self] in
            DispatchQueue.main.async {
                self?.homeFeedTable.reloadSections(IndexSet(integer: Sections.topRated.rawValue), with: .fade)
            }
        } onError: {
            
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: min(0, -offset))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        var isTitleCenter = false
        
        switch section {
        case Sections.nowPlaying.rawValue:
            title = "Now Playing"
            isTitleCenter = true
            
        case Sections.trendingMovies.rawValue:
            title = "Trending Movies"
            
        case Sections.trendingTvs.rawValue:
            title = "Trending Tvs"
            
        case Sections.popular.rawValue:
            title = "Popular Movies"
            
        case Sections.upcoming.rawValue:
            title = "Upcoming Movies"
            
        case Sections.topRated.rawValue:
            title = "Top Rated Movies"
            
        default:
            return nil
        }
        
        return HeaderView(title: title, textAlignment: isTitleCenter ? .center : .left)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Sections.nowPlaying.rawValue {
            let inset: CGFloat = 16
            let width = UIScreen.main.bounds.width - (CGFloat(2) * inset)
            let height = width / 0.67
            return height
        }
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.nowPlaying.rawValue,
            Sections.trendingMovies.rawValue,
            Sections.trendingTvs.rawValue,
            Sections.popular.rawValue,
            Sections.upcoming.rawValue,
            Sections.topRated.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.nowPlaying.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionParallaxTableViewCell.identifier, for: indexPath) as? CollectionParallaxTableViewCell else {
                return UITableViewCell()
            }
            
            guard let trendingMovies = viewModel.getTrendingMovies() else {
                return cell
            }
            
            cell.configure(with: trendingMovies)
            cell.delegate = self
            
            return cell
            
        case Sections.trendingMovies.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
                return UITableViewCell()
            }
            
            guard let trendingMovies = viewModel.getTrendingMovies() else {
                return cell
            }
            
            cell.configure(with: trendingMovies)
            cell.delegate = self
            
            return cell
            
        case Sections.trendingTvs.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
                return UITableViewCell()
            }
            
            guard let trendingTvs = viewModel.getTrendingTvs() else {
                return cell
            }
            
            cell.configure(with: trendingTvs)
            cell.delegate = self
            
            return cell
            
        case Sections.popular.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
                return UITableViewCell()
            }
            
            guard let popularMovies = viewModel.getPopularMovies() else {
                return cell
            }
            
            cell.configure(with: popularMovies)
            cell.delegate = self
            
            return cell
            
        case Sections.upcoming.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
                return UITableViewCell()
            }
            
            guard let upcomingMovies = viewModel.getUpcomingMovies() else {
                return cell
            }
            
            cell.configure(with: upcomingMovies)
            cell.delegate = self
            
            return cell
            
        case Sections.topRated.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
                return UITableViewCell()
            }
            
            guard let topRatedMovies = viewModel.getTopRatedMovies() else {
                return cell
            }
            
            cell.configure(with: topRatedMovies)
            cell.delegate = self
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - CollectionViewTableViewCellDelegate

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewDidTapCell(_ title: Title, poster: UIImage?) {        
        let detailVC = TitleDetailViewController(title: title, poster: poster)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - CollectionParallaxTableViewCellDelegate

extension HomeViewController: CollectionParallaxTableViewCellDelegate {
    func collectionParallaxDidTapCell(_ title: Title, poster: UIImage?) {
        let detailVC = TitleDetailViewController(title: title, poster: poster)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
