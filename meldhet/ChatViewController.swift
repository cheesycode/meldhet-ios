//
//  ChatViewController.swift
//  MeldHet
//
//  Created by Michel Megens on 18/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var chatTextView: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var issue : Issue? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatViewController.keyboardWillShow),
            name: UIResponder.keyboardDidShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChatViewController.keyboardWillHide),
            name: UIResponder.keyboardDidShowNotification, object: nil
        )
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
        
        if msg?.recipient == AppDelegate.deviceID {
            cell.messageTextView.backgroundColor = UIColor(red: 0xFF, green: 0xCE, blue: 0x54)
        } else {
            cell.messageTextView.backgroundColor = UIColor(red: 0x4F, green: 0xC1, blue: 0xE9)
        }
        
        cell.messageTextView.layer.cornerRadius = 8
        cell.setUpContentWrap()
        
        //cell.textLabel?.text = "Bob"
        //
        
        return cell
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                print(self.view.frame.origin.y)
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
