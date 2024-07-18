//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 17/07/24.
//

import UIKit

fileprivate enum Sections: Int, CaseIterable {
    case trendingMovies = 0
    case trendingTvs = 1
    case popular = 2
    case upcoming = 3
    case topRated = 4
}

class HomeViewController: UIViewController {
    
    private let homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeFeedTable)
        
        view.backgroundColor = .systemBackground
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func fetchData() {
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Sections.trendingMovies.rawValue:
            return "Trending Movies"
            
        case Sections.trendingTvs.rawValue:
            return "Trending Tvs"
            
        case Sections.popular.rawValue:
            return "Popular Movies"
            
        case Sections.upcoming.rawValue:
            return "Upcoming Movies"
            
        case Sections.topRated.rawValue:
            return "Top Rated Movies"
            
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.trendingMovies.rawValue,
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
    func didTapCell(_ title: Title) {
        print("Did tap cell: \(title.originalTitle ?? title.id.description)")
    }
}
