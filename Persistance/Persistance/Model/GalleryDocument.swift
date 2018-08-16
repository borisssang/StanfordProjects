//
//  GalleryDocument.swift
//  Assignment5
//
//  Created by Boris Angelov on 31.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleryDocument: UIDocument {
    
    var gallery: ImageGallery?
    
    override func contents(forType typeName: String) throws -> Any {
        return gallery?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let data = contents as? Data {
            gallery = ImageGallery(json: data)
        }
    }
}

