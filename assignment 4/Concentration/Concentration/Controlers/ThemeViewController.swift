//
//  ThemeViewController.swift
//  Lecture 4 - Concentration
//
//  Created by Boris Angelov on 6.07.18.
import UIKit

class ThemeViewController: UIViewController, UISplitViewControllerDelegate{
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    private var lastSeguedToViewController: ConcentrationViewController?
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController?{
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    @IBAction func changeTheme(_ sender: UIButton) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = sender.currentTitle{
                cvc.theme = themeName
            }
        } else if let cvc = lastSeguedToViewController {
            if let themeName = sender.currentTitle{
                cvc.theme = themeName
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "Choose Theme", let cvc = segue.destination as? ConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle{
                cvc.theme = themeName
                lastSeguedToViewController = cvc
            }
        }
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController
        ) -> Bool
    {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            return cvc.theme == nil
        }
        return false
    }
}
