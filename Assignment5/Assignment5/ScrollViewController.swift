//
//  ScrollViewController.swift
//  Assignment5
//
//  Created by Boris Angelov on 25.07.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    var imageView = UIImageView()
    
    var image: UIImage? {
        get{
            return imageView.image
        }
        set{
            scrollView?.zoomScale = 1.0
            imageView.image = newValue
            let size = newValue?.size ?? CGSize.zero
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView?.contentSize = size
            widthConstraint?.constant = size.width
            heightConstraint?.constant = size.height
            if size.width > 0, size.height > 0{
                scrollView?.zoomScale = max(self.view.bounds.size.width / size.width, self.view.bounds.size.height / size.height)
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.maximumZoomScale = 0.1
            scrollView.minimumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        widthConstraint.constant = scrollView.contentSize.width
        heightConstraint.constant = scrollView.contentSize.height
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
