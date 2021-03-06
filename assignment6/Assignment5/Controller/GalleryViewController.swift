//
//  ViewController.swift
//  Assignment5
//
//  Created by Boris Angelov on 19.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UIDropInteractionDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        galleryDocument?.open { success in
            if success {
                if self.gallery == nil {
                    self.gallery = self.galleryDocument!.gallery
                    self.gallery.title = self.galleryDocument!.localizedName
                }
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    //MARK: - MODEL
    
    var gallery: ImageGallery! {
        didSet {
            title = gallery?.title
            galleryCollectionView?.reloadData()
        }
    }
    
    var galleryDocument: GalleryDocument?
    var imageRequestManager: ImageHandler?
    
    private var cachedImages = [ImageGallery.Image : UIImage]()
    
    //MARK: - COLLECTIONVIEW
    
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet{
            galleryCollectionView.dragDelegate = self
            galleryCollectionView.dropDelegate = self
            galleryCollectionView.dataSource = self
            galleryCollectionView.delegate = self
            flowLayout?.minimumLineSpacing = 5
            flowLayout?.minimumInteritemSpacing = 5
        }
    }
    
    private var flowLayout: UICollectionViewFlowLayout? {
        return galleryCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    private var maximumItemWidth: CGFloat? {
        return galleryCollectionView?.frame.size.width
    }
    
    private var minimumItemWidth: CGFloat? {
        guard let collectionView = galleryCollectionView else { return nil }
        return (collectionView.frame.size.width / 2) - 5
    }
    
    private lazy var itemWidth: CGFloat = {
        return minimumItemWidth ?? 0
    }()
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let galleryImage = gallery.images[indexPath.item]
        let itemHeight = itemWidth / CGFloat(galleryImage.aspectRatio)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath)
        
        guard let galleryImage = getImage(at: indexPath) else {
            return cell
        }
        
        if let imageCell = cell as? GalleryCollectionViewCell {
            if let image = cachedImages[galleryImage] {
                imageCell.imageView.image = image
            } else {
                
                imageRequestManager?.request(at: galleryImage.imagePath!.imageURL, withCompletionHandler: { [weak self] data in
                    if let loadedImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.cachedImages[galleryImage] = loadedImage
                            self?.galleryCollectionView?.reloadData()
                        }
                    }
                }) {(transportError, response) in
                    DispatchQueue.main.async {
                   print("Unable to fetch Image")
                    }
                }
            }
        }
        return cell
    }
    
    //MARK: - ACTIONS:
    
    private func insertImage(_ image: ImageGallery.Image, at indexPath: IndexPath) {
        gallery?.images.insert(image, at: indexPath.item)
        print("Updated \(gallery!.images.count)")
    }
    
    private func getImage(at indexPath: IndexPath) -> ImageGallery.Image? {
        return gallery?.images[indexPath.item]
    }
    
    @IBAction func saveGallery(_ sender: UIBarButtonItem) {
        galleryDocument?.gallery = gallery
        galleryDocument?.updateChangeCount(.done)
        dismiss(animated: true){
        self.galleryDocument?.close()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ScrollViewController {
            let cell = sender as! GalleryCollectionViewCell
            if let indexPath = galleryCollectionView?.indexPath(for: cell),
                let selectedImage = getImage(at: indexPath) {
                destination.image = cachedImages[selectedImage]
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let cell = sender as? GalleryCollectionViewCell {
            if let indexPath = galleryCollectionView?.indexPath(for: cell),
                let selectedImage = getImage(at: indexPath) {
                return cachedImages[selectedImage] != nil
            } else {
                return false
            }
        }
        else {return false}
    }
    
    @IBAction func didPinch(_ sender: UIPinchGestureRecognizer) {
        guard let maximumItemWidth = maximumItemWidth else { return }
        guard let minimumItemWidth = minimumItemWidth else { return }
        guard itemWidth <= maximumItemWidth else { return }
        
        if sender.state == .began || sender.state == .changed {
            let scaledWidth = itemWidth * sender.scale
            
            if scaledWidth <= maximumItemWidth,
                scaledWidth >= minimumItemWidth {
                itemWidth = scaledWidth
                flowLayout?.invalidateLayout()
            }
            sender.scale = 1
        }
    }
    
    //MARK: - DRAG DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem]{
        if let galleryImage = getImage(at: indexPath) {
            if let imageURL = galleryImage.imagePath as NSURL? {
                let urlItem = UIDragItem(itemProvider: NSItemProvider(object: imageURL))
                urlItem.localObject = galleryImage
                return [urlItem]
            }
        }
        return []
    }
    
    //MARK: - DROP DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView.hasActiveDrag {
            return session.canLoadObjects(ofClass: URL.self)
        } else {
            return session.canLoadObjects(ofClass: URL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        guard gallery != nil else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                let image = item.dragItem.localObject as!ImageGallery.Image
                collectionView.performBatchUpdates({
                    self.gallery.images.remove(at: sourceIndexPath.item)
                    self.gallery.images.insert(image, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                // no sourceIndexPath, so not local
                let placeholderContext = coordinator.drop(
                    item.dragItem,
                    to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceHolderCell")
                )
                var draggedImage = ImageGallery.Image(imagePath: nil, aspectRatio: 1)
                
                _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self){ (provider, error) in
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            draggedImage.aspectRatio = image.aspectRatio
                        }
                    }
                }
                
                // Loads the URL.
                _ = item.dragItem.itemProvider.loadObject(ofClass: URL.self) { (provider, error) in
                    if let url = provider?.imageURL {
                        draggedImage.imagePath = url
                        
                        // Downloads the image from the fetched url.
                        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                            DispatchQueue.main.async {
                                if let data = data, let _ = UIImage(data: data) {
                                    placeholderContext.commitInsertion { indexPath in
                                        draggedImage.imageData = data
                                        self.insertImage(draggedImage, at: indexPath)
                                    }
                                } else {
                                    // There was an error. Remove the placeholder.
                                    placeholderContext.deletePlaceholder()
                                }
                            }
                            }.resume()
                    }
                }
                
            }
        }
    }
}
