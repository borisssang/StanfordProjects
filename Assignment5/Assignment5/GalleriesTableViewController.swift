//
//  GalleriesTableViewController.swift
//  Assignment5
//
//  Created by Boris Angelov on 24.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleriesTableViewController: UITableViewController, GallerySelectionTableViewCellDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedGallery = detailController?.gallery {
            if let index = galleriesStorage.allGalleries[0].index(of: selectedGallery) {
                let selectionIndexPath = IndexPath(row: index, section: 0)
                tableView.selectRow(
                    at: selectionIndexPath,
                    animated: true,
                    scrollPosition: .none
                )
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    //MARK: Model
    
    var galleriesStorage = GalleryStorage() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    /// The table view's data.
    private var sections: [[ImageGallery]] {
        get {
            let store = galleriesStorage
            return [store.allGalleries[0], store.allGalleries[1]]
        }
        set{
            galleriesStorage.allGalleries = newValue
        }
    }
    
    //MARK: TABLE
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    private var detailController: GalleryViewController? {
        return splitViewController?.viewControllers.last?.contents as? GalleryViewController
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sections[0].count
        case 1:
            return sections[1].count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recently Deleted"
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gallery = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseGallery", for: indexPath)
        if let galleryCell = cell as? GallerySelectionTableViewCell{
            galleryCell.delegate = self
            galleryCell.title = gallery.title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0{
                sections[1].append(sections[0].remove(at: indexPath.row))
                tableView.reloadData()
            } else if indexPath.section == 1 {
                sections[1].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = indexPath.section
        
        if section == 1 {
            var actions = [UIContextualAction]()
            
            let recoverAction = UIContextualAction(style: .normal, title: "Recover") { (action, view, _) in
                if let deletedGallery = self.galleriesStorage.getGallery(at: indexPath) {
                    self.galleriesStorage.recoverGallery(deletedGallery)
                    self.tableView.reloadData()
                }
            }
            actions.append(recoverAction)
            return UISwipeActionsConfiguration(actions: actions)
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGallery = sections[indexPath.section][indexPath.row]
        if let cvc = detailController {
            cvc.gallery = selectedGallery
            cvc.galleryStorage = galleriesStorage
        }
        else {
            performSegue(withIdentifier: "selectionSegue", sender: indexPath.item )
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        return section == 0
    }
    
    //MARK: ACTIONS
    
    @IBAction func newGallery(_ sender: UIBarButtonItem) {
        let galleryNames = (sections[0] + sections[1]).map { gallery in
            return gallery.title
        }
        let newGallery = ImageGallery(
            title: "Untitled".madeUnique(withRespectTo: galleryNames), images: []
        )
        sections[0].insert(newGallery, at: 0)
        tableView.reloadData()
    }
    
    
    @IBAction func didDoubleTap(_ sender: UITapGestureRecognizer) {
        sender.numberOfTapsRequired = 2
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
            if let cell = tableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell {
                cell.isEditing = true
            }
        }
    }
    
    func titleDidChange(_ title: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            if var gallery = galleriesStorage.getGallery(at: indexPath) {
                gallery.title = title
                sections[indexPath.section][indexPath.row] = gallery
                tableView.reloadData()
            }
        }
    }
    
}
