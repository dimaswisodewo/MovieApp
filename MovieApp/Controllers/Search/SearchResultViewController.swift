//
//  SearchResultViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import UIKit

protocol SearchResultViewDelegate: AnyObject {
    func searchResultViewTableViewWillDisplay(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

class SearchResultViewController: UIViewController {
    
    private var searchResults: [Title] = []
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tv
    }()
    
    weak var delegate: SearchResultViewDelegate?
    
    var onDismissPreview: (() -> Void)?
    
    func configureSearchResults(results: [Title]) {
        searchResults.append(contentsOf: results)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func resetSearchResults() {
        searchResults.removeAll()
    }
    
    func scrollToTop() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        delegate?.searchResultViewTableViewWillDisplay(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let model = searchResults[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? TitleTableViewCell else { return }
        
        let title = searchResults[indexPath.row]
        let poster = cell.poster
        let detailVC = TitleDetailViewController(title: title, poster: poster)
        
        guard let parentVC = presentingViewController else { return }
        
        // Focus on search result after pop detail VC
        detailVC.onPopViewController = {
            parentVC.navigationItem.searchController?.isActive = true
            parentVC.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
        
        // Push detail VC after dismiss seach result VC
        parentVC.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                parentVC.navigationController?.pushViewController(detailVC, animated: true)
            }
        })
    }
}
