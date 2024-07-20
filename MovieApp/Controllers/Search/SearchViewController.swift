//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let searchResultViewController = SearchResultViewController()
    
    private let searchPublisher = CurrentValueSubject<String, Never>("")
    private var searchCancellable: AnyCancellable?
    private var lastQuery: String = ""
    private var isUpdating: Bool = false
    private var isNewSearch: Bool = true
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: self.searchResultViewController)
        controller.searchBar.placeholder = "Search for a Movie or a TV Show title"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private lazy var collectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.size.width
        let horizontalInset: CGFloat = 16
        let width = screenWidth / 3 - horizontalInset
        let height = width * 1.5
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        cv.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let viewModel = SearchViewModel()
    
    deinit {
        viewModel.ongoingTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.showsSearchResultsController = true
        
        searchResultViewController.delegate = self
        
        searchResultViewController.onDismissPreview = { [weak self] in
            guard let self = self else { return }
            
            searchController.searchBar.text = self.lastQuery
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        subscribe()
        
        setupConstraints()
        
        fetchData()
    }
    
    // Hacky way to show search bar by default
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // Hacky way to show search bar by default
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func subscribe() {
        searchCancellable = searchPublisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] finalQuery in
                guard let self = self else { return }
                
                guard finalQuery != self.lastQuery, !finalQuery.isEmpty else {
                    self.viewModel.ongoingTask?.cancel()
                    return
                }
                
                self.lastQuery = finalQuery
                
                self.viewModel.ongoingTask?.cancel()
                self.viewModel.resetSearchResults()
                self.searchResultViewController.resetSearchResults()
                self.isNewSearch = true
                self.fetchSearchResults()
            })
    }
    
    private func fetchData() {
        viewModel.getDiscoverMovies { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func fetchSearchResults() {
        isUpdating = true
        viewModel.getSearchCollection(query: lastQuery) { [weak self] searchResults in
            self?.searchResultViewController.configureSearchResults(results: searchResults)
            self?.isUpdating = false
            
            if self?.isNewSearch == true {
                self?.searchResultViewController.scrollToTop()
                self?.isNewSearch = false
            }
        }
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text else { return }
        
        let cleanQuery = query.trimmingCharacters(in: .whitespaces)
        
        searchPublisher.send(cleanQuery)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = viewModel.titles[indexPath.item]
        cell.configure(with: title)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TitleCollectionViewCell else { return }

        let title = viewModel.titles[indexPath.item]
        let poster = cell.posterImage
        
        let detailVC = TitleDetailViewController(title: title, poster: poster)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - SearchResultViewDelegate

extension SearchViewController: SearchResultViewDelegate {
    
    func searchResultViewTableViewWillDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row >= viewModel.lastSearchResults.count - 1) && !lastQuery.isEmpty && !isUpdating && !viewModel.isLastPageReached {
            fetchSearchResults()
        }
    }
}
