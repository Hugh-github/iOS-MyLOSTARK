//
//  UIImage+extension.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import UIKit

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let newImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return newImage
    }
}
