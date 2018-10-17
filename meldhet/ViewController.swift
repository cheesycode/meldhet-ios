//
//  ViewController.swift
//
//  Created by Michel Megens on 08/10/2018.
//  Copyright © 2018 Michel Megens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    var imagePicker : UIImagePickerController!

    @IBAction func onImageClicked(_ sender: UITapGestureRecognizer) {
        print(sender.name as! String)
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image.contentMode = .scaleAspectFit
            image.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onChatClickedHandler(_ sender: UITapGestureRecognizer) {
        print(sender.name as! String)
        
        self.performSegue(withIdentifier: "mapSegue", sender: sender)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

