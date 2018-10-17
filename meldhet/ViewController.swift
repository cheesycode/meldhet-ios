//
//  ViewController.swift
//
//  Created by Michel Megens on 08/10/2018.
//  Copyright © 2018 Michel Megens. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker : UIImagePickerController!
    var capturedImage : UIImage = UIImage.init()
    var type : String = ""
    
    @IBAction func onImageClicked(_ sender: UITapGestureRecognizer) {
        self.type = sender.name as! String
        
        print(sender.name as! String)
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .camera
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            capturedImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "cameraSegue", sender: self)
    }
    
<<<<<<< HEAD
    @IBAction func onChatClickedHandler(_ sender: Any) {
=======
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cameraSegue"){
            if let dest = segue.destination as? UploadViewController {
                dest.type = self.type
                dest.capturedImage = self.capturedImage
            }
        }
    }

    @IBAction func onChatClickedHandler(_ sender: UITapGestureRecognizer) {
        print(sender.name as! String)
        
>>>>>>> origin/addCameraFunctionality
        self.performSegue(withIdentifier: "mapSegue", sender: sender)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

