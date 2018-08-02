//
//  GalleryDocument.swift
//  Assignment5
//
//  Created by Boris Angelov on 31.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleryDocumentController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var template: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsPickingMultipleItems = false
        allowsDocumentCreation = false
        browserUserInterfaceStyle = .light
        
        let fileManager = FileManager.default
        
        template = try? fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
            ).appendingPathComponent("untitled.json")
        
        if let templateURL = template {
            allowsDocumentCreation = fileManager.createFile(atPath: templateURL.path, contents: Data())
            
            let emptyGallery = ImageGallery(title: "untitled", images: [])
            _ = try? JSONEncoder().encode(emptyGallery).write(to: templateURL)
        }
        
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
       print("Failed to import Document")
    }

    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navigationViewController = storyBoard.instantiateViewController(withIdentifier: "GalleryViewerNavigationController")
        let documentViewController = navigationViewController.contents as! GalleryViewController
        documentViewController.galleryDocument = GalleryDocument(fileURL: documentURL)
        documentViewController.imageRequestManager = ImageHandler()
        
        present(navigationViewController, animated: true, completion: nil)
    }
    
}
