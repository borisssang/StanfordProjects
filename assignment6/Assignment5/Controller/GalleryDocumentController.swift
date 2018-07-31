//
//  GalleryDocument.swift
//  Assignment5
//
//  Created by Boris Angelov on 31.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleryDocumentController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var templateURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsPickingMultipleItems = false
        allowsDocumentCreation = false
    }
}
