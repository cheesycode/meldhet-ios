//
//  ViewController.swift
//
//  Created by Michel Megens on 08/10/2018.
//  Copyright © 2018 Michel Megens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker : UIImagePickerController!

    @IBAction func onImageClicked(_ sender: UITapGestureRecognizer) {
        print("Broken clicked")
        
        //self.imagePicker = UIImagePickerController()
        //self.imagePicker.delegate = self
        //self.imagePicker.sourceType = .camera
        //present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onChatClickedHandler(_ sender: Any) {
        print("GODVERDOMME WERK DAN")
        
        self.performSegue(withIdentifier: "mapSegue", sender: sender)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

