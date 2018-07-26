//
//  GalleriesTableViewController.swift
//  Assignment5
//
//  Created by Boris Angelov on 24.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class GalleriesTableViewController: UITableViewController, GallerySelectionTableViewCellDelegate {
    
    private var lastSeguedToViewController: GalleryViewController?
    
    var sections: [[String]] =
    [
        [],
        []
    ]

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    private var detailController: GalleryViewController? {
        return splitViewController?.viewControllers.last?.contents as? GalleryViewController
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedGalleryTitle = detailController?.gallery?.title {
            if let index = sections[0].index(of: selectedGalleryTitle) {
                let selectionIndexPath = IndexPath(row: index, section: 0)
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
    
   
    @IBAction func didDoubleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) {
            if let cell = tableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell {
                cell.isEditing = true
            }
        }
    }

    
    func titleDidChange(_ title: String, in cell: UITableViewCell) {
        if let indexPath1 = tableView.indexPath(for: cell) {
            let gallery = getGallery(at: indexPath1)
                sections[indexPath1.section][indexPath1.row] = gallery
                tableView.reloadData()
        }
    }
    
    func recoverGallery(deletedGallery: String){
        if let deletedIndex = sections[1].index(of: deletedGallery) {
            sections[0].append(sections[1].remove(at: deletedIndex))
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let section = indexPath.section
        
        if section == 1 {
            var actions = [UIContextualAction]()
            
            let recoverAction = UIContextualAction(style: .normal, title: "Recover") { (action, view, _) in
                let deletedGallery = self.getGallery(at: indexPath)
                self.recoverGallery(deletedGallery: deletedGallery)
                    self.tableView.reloadData()
            }
            
            actions.append(recoverAction)
            return UISwipeActionsConfiguration(actions: actions)
            
        } else {
            return nil
        }
    }
    
    private func getGallery(at indexPath: IndexPath) -> String {
        return sections[indexPath.section][indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: selectedCell) {
                let section = indexPath.section
                guard section == 0 else { return }
                let selectedGallery = sections[indexPath.section][indexPath.row]
                if let navigationController = segue.destination as? UINavigationController {
                    if let displayController = navigationController.visibleViewController as? GalleryViewController {
                        displayController.getGallery(withLabel: selectedGallery)
                        lastSeguedToViewController = displayController
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGallery = sections[indexPath.section][indexPath.row]
        if let cvc = lastSeguedToViewController {
        cvc.getGallery(withLabel: selectedGallery)
        } else  if let cvc = detailController {
            cvc.getGallery(withLabel: selectedGallery)
        }
        else {
            performSegue(withIdentifier: "selectionSegue", sender: indexPath.item )
        }
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        return section == 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
}
