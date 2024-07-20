//
//  LikedTitleViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 20/07/24.
//

import UIKit

class LikedTitleViewController: UIViewController {

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tv
    }()
    
    private let viewModel = LikedTitleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Saved"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataPersistanceManager.shared.isNeedToRefresh() {
            fetchData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func fetchData() {
        viewModel.fetchLikedTitles { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension LikedTitleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titlesWithPoster.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let (model, posterImage) = viewModel.titlesWithPoster[indexPath.row]
        cell.configure(with: model, posterImage: posterImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let (title, poster) = viewModel.titlesWithPoster[indexPath.row]
        let detailVC = TitleDetailViewController(title: title, poster: poster, isUseOfflineData: true)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
