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
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: self.searchResultViewController)
        controller.searchBar.placeholder = "Search for a Movie or a TV Show title"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let viewModel = SearchViewModel()
    
    deinit {
        viewModel.ongoingTask?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchResultsUpdater = self
        
        searchResultViewController.onDismissPreview = { [weak self] in
            guard let self = self else { return }
            
            searchController.searchBar.text = self.lastQuery
            self.searchResultViewController.configureSearchResults(results: self.viewModel.lastSearchResults)
        }
        
        subscribe()
    }
    
    private func subscribe() {
        searchCancellable = searchPublisher
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] finalQuery in
                guard let self = self else { return }
                
                guard finalQuery != self.lastQuery else { return }
                
                self.lastQuery = finalQuery
                
                self.viewModel.ongoingTask?.cancel()
                self.viewModel.getSearchCollection(query: finalQuery) { searchResults in
                    self.searchResultViewController.configureSearchResults(results: searchResults)
                }
            })
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text else { return }
        
        let cleanQuery = query.trimmingCharacters(in: .whitespaces)
        guard cleanQuery.count > 3 else { return }
        
        searchPublisher.send(cleanQuery)
    }
}
