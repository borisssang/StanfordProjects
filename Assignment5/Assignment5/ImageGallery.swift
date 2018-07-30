//
//  ImageGallery.swift
//  Assignment5
//
//  Created by Boris Angelov on 20.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import Foundation
import UIKit
struct ImageGallery: Codable, Hashable{
    
    init (title: String, images: [Image]){
        self.title = title
        self.images = images
    }
    
    var identifier: String = UUID().uuidString
    
    /// The gallery's title.
    var title: String
    
    // MARK: - Hashable
    var hashValue: Int {
        return identifier.hashValue
    }
    
    static func ==(lhs: ImageGallery, rhs: ImageGallery) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var images = [Image]()
    
    struct Image: Hashable, Codable {
        
        // MARK: - Hashable
        
        var hashValue: Int {
            return imagePath?.hashValue ?? 0
        }
        
        static func ==(lhs: ImageGallery.Image, rhs: ImageGallery.Image) -> Bool {
            return lhs.imagePath == rhs.imagePath
        }
        
        // MARK: - Properties
        
        /// The image's URL.
        var imagePath: URL?
        
        /// The image's aspect ratio.
        var aspectRatio: Double
        
        /// The fetched image's data.
        var imageData: Data?
        
        
        init(imagePath: URL?, aspectRatio: Double) {
            self.imagePath = imagePath
            self.aspectRatio = aspectRatio
        }
    }
    
}
