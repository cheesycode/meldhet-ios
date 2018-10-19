//
//  ChatViewController.swift
//  MeldHet
//
//  Created by Michel Megens on 18/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

extension UIColor {
    public convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextView: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var issue : Issue? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector (keyboarWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.scrollToBottom()
    }
    
    @IBAction func sendMessageClickHandler(_ sender: UIButton) {
        let message = Message()
        
        message.body = self.chatTextView.text!
        message.issue = self.issue?.id
        message.recipient = issue?.messages![0].sender
        message.sender = AppDelegate.deviceID
        
        self.issue?.messages!.append(message)
        let row = (self.issue?.messages!.count)! - 1
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        self.tableView.endUpdates()
        
        let parameters = [
            "recipient": message.recipient!,
            "sender": message.sender!,
            "issue": message.issue!,
            "body": message.body!
        ] as [String : Any]
        
        Alamofire.request("https://api.meldhet.cheesycode.com/v1/messages/create",method:.post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation complete: message pushed to server")
                
            case .failure(let error):
                print("Unable to post message:")
                print(error.localizedDescription)
            }
        }
        
        self.chatTextView.text? = ""
        self.scrollToBottom()
    }
    
    @objc func keyboarWillHide(notification: NSNotification){
        let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0, animations:{
            self.view.layoutIfNeeded()
            self.bottomConstraint.constant = 8
            self.scrollToBottom()
            self.scrollToBottom()
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
            let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25, animations:{
                self.view.layoutIfNeeded()
                self.bottomConstraint.constant = (rect?.height)! + 8
                self.scrollToBottom()
                
            })
    }
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.tableView.numberOfRows(inSection:  (self.tableView.numberOfSections - 1)) - 1,
                section: self.tableView.numberOfSections - 1)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (issue?.messages?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _cell = tableView.dequeueReusableCell(withIdentifier: "receiveCell", for: indexPath)
        let cell = _cell as! MessageViewTableViewCell
        let index = indexPath.row
        let msg = self.issue?.messages![index]
        
        cell.messageTextView.text = msg?.body
        
        if msg?.sender == AppDelegate.deviceID {
            cell.messageTextView.backgroundColor = UIColor(red: 0x4F, green: 0xC1, blue: 0xE9)
            cell.marginRight.constant = 16
            cell.marginLeft.constant = 100
            cell.senderTextView.textAlignment = NSTextAlignment.right
            cell.senderTextView.text = "Me"
        } else {
            cell.messageTextView.backgroundColor = UIColor(red: 0xFF, green: 0xCE, blue: 0x54)
            cell.marginRight.constant = 100
            cell.marginLeft.constant = 16
            cell.senderTextView.textAlignment = NSTextAlignment.left
            cell.senderTextView.text = msg?.sender
        }
        
        cell.messageTextView.layer.cornerRadius = 8
        cell.setUpContentWrap()
        
        return cell
    }
}
