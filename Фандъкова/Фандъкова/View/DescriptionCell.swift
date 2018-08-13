//
//  DescriptionCell.swift
//  Фандъкова
//
//  Created by Boris Angelov on 6.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

protocol DescriptionDelegate {
    func descriptionUpdated(text: String)
}

class DescriptionCell: UITableViewCell, UITextViewDelegate {
    
    var delegate: DescriptionDelegate?
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate = self
            textView?.sizeThatFits(CGSize(width: (textView?.frame.size.width)!, height: (textView?.frame.size.height)!))
            textView.text = "Please, describe the issue..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        delegate?.descriptionUpdated(text: textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please, describe the issue..."
            textView.textColor = UIColor.lightGray
        }
        delegate?.descriptionUpdated(text: textView.text)
    }
    
}
