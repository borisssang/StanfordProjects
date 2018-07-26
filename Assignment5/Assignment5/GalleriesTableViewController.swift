//
//  GalleriesTableViewController.swift
//  Assignment5
//
//  Created by Boris Angelov on 24.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleriesTableViewController: UITableViewController, GallerySelectionTableViewCellDelegate {
    func titleDidChange(_ title: String, in cell: UITableViewCell) {
        
    }
    
    var sections =
    [
        ["Contemporary", "OldSchool", "Nature"],
        []
    ]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    private var detailController: GalleryViewController? {
        return splitViewController?.viewControllers.last?.contents as? GalleryViewController
    }
    
    //защо е нужно ? 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedGallery = detailController?.gallery {
            if let index = sections.index(of: [selectedGallery.title]) {
                let selectionIndexPath = IndexPath(index: index)
                tableView.selectRow(
                    at: selectionIndexPath,
                    animated: true,
                    scrollPosition: .none
                )
            }
        }
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
            galleryCell.title = gallery
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
    
    @IBAction func newGallery(_ sender: UIBarButtonItem) {
        sections[0] += ["Untitled".madeUnique(withRespectTo: sections[0])]
        tableView.reloadData()
    }
    
//    func titleDidChange(_ title: String, in cell: UITableViewCell) {
//        if let indexPath = tableView.indexPath(for: cell) {
//            var gallery = sections[indexPath]{
//                gallery = title
//                tableView.reloadData()
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: selectedCell) {
                let selectedGallery = sections[indexPath.section][indexPath.row]
                if let navigationController = segue.destination as? UINavigationController {
                    if let displayController = navigationController.visibleViewController as? GalleryViewController {
                        displayController.getGallery(withLabel: selectedGallery)
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectionSegue", sender: self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
}
