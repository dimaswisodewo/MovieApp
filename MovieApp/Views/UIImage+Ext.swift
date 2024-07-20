//
//  UIImage+Ext.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 20/07/24.
//

import UIKit

extension UIImage {
    
    func jpegToBase64() -> String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    
    func pngToBase64() -> String? {
        self.pngData()?.base64EncodedString()
    }
}

extension String {
    
    func imageFromBase64() -> UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
