//
//  UINavigationController+Ext.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 20/07/24.
//

import UIKit

extension UINavigationController {
    
    func popViewController(animated: Bool = true, completion: @escaping () -> Void ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}
