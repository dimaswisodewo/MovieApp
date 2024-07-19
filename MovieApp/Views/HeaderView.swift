//
//  TextCenterHeaderView.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 19/07/24.
//

import UIKit

class HeaderView: UIView {

    private let titleLabel: UILabel
    
    init(title: String, textAlignment: NSTextAlignment = .left) {
        
        self.titleLabel = {
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textAlignment = textAlignment
            return label
        }()
        
        super.init(frame: .zero)
        
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
