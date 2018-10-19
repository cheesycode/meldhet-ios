//
//  MessageViewTableViewCell.swift
//  meldhet
//
//  Created by Michel Megens on 18/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import UIKit

class MessageViewTableViewCell: UITableViewCell {
    @IBOutlet weak var senderTextView: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setUpContentWrap() {
        let width = self.messageTextView.frame.size.height
        let new = self.messageTextView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        self.messageTextView.isScrollEnabled = false
        self.messageTextView.frame.size = CGSize(width: max(new.width, width), height: new.height)
        self.messageTextView.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
