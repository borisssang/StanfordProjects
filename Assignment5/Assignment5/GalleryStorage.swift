//
//  GalleryStorage.swift
//  Assignment5
//
//  Created by Boris Angelov on 27.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleryStorage{

    var allGalleries: [[ImageGallery]] =
        [
            [],
            []
    ]
    
    func recoverGallery(deletedGallery: ImageGallery){
        if let deletedIndex = allGalleries[1].index(of: deletedGallery) {
            allGalleries[0].append(allGalleries[1].remove(at: deletedIndex))
        }
    }
    
    public func getGallery(at indexPath: IndexPath) -> ImageGallery? {
        return allGalleries[indexPath.section][indexPath.row]
    }
    
    func recoverGallery(_ gallery: ImageGallery) {
        if let deletedIndex = allGalleries[1].index(of: gallery) {
            allGalleries[0].append(allGalleries[1].remove(at: deletedIndex))
        }
    }
    
    func updateGallery(_ gallery: ImageGallery) {
        if let galleryIndex = allGalleries[0].index(of: gallery) {
            allGalleries[0][galleryIndex] = gallery
           //notification?
        }
    }
    
}
