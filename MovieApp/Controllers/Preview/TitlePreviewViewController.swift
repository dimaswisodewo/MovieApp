//
//  TitlePreviewViewController.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 18/07/24.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.underPageBackgroundColor = .systemBackground
        webView.isOpaque = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isHidden = true
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .bold, size: 20)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel = TitlePreviewViewModel()
    
    private var titleTopEqualSuperviewTop: NSLayoutConstraint!
    private var titleTopEqualWebviewBottom: NSLayoutConstraint!
    
    var onDismiss: (() -> Void)?
    
    deinit {
        viewModel.ongoingTask?.cancel()
        onDismiss?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        
        setupConstraints()
    }

    private func setupConstraints() {
        let insets = view.safeAreaInsets
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top + 18),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 380)
        ])
        
        titleTopEqualSuperviewTop = titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top + 18)
        titleTopEqualWebviewBottom = titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 12)
        
        NSLayoutConstraint.activate([
            titleTopEqualSuperviewTop,
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            overviewLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
    
    func configure(with model: TitlePreview) {
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        viewModel.getSearchYoutubeVideos(query: model.title) { [weak self] videoId in
            guard let url = URL(string: "\(Constants.youtubeVideoEmbedBaseURL)\(videoId)") else { return }
            
            DispatchQueue.main.async {
                self?.webView.isHidden = false
                self?.webView.load(URLRequest(url: url))
                
                // Update constraint
                self?.titleTopEqualSuperviewTop.isActive = false
                self?.titleTopEqualWebviewBottom.isActive = true
                
                UIView.animate(withDuration: 0.5, animations: {
                    self?.view.layoutIfNeeded()
                })
            }
        }
    }
}
