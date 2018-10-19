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
    
    @IBOutlet weak var marginLeft: NSLayoutConstraint!
    @IBOutlet weak var marginRight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpContentWrap()
    }
    
    public func setUpContentWrap() {
        self.messageTextView.isScrollEnabled = false
        self.messageTextView.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
