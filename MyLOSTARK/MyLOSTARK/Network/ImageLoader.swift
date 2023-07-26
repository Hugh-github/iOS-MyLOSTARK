//
//  ImageLoader.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/24.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    private func image(_ url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func fetch(_ url: URL, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = image(url as NSURL) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            
            return
        }
        
        Task {
            let (data, _) = try await URLSession(configuration: .ephemeral).data(from: url)
            guard let image = UIImage(data: data) else { return }
            
            self.cachedImages.setObject(image, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
