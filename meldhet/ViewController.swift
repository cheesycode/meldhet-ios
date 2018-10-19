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
    
    @IBAction func clickedOther(_ sender:Any){
        let alertController = UIAlertController(title: "Wat voor Melding wil je Maken?", message: nil, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Melden", style: .default) { (_) in
            
            //getting the input values from user
            self.type = alertController.textFields?[0].text! ?? "Kapot"
            self.startCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Annuleren", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Omschrijf je melding"
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func infoClicked(_ sender: UITapGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onImageClicked(_ sender: UITapGestureRecognizer) {
        self.type = sender.name!
        print(sender.name!)
        startCamera()
    }
    
    func startCamera(){
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
    

    @IBAction func onChatClickedHandler(_ sender: Any) {
        self.performSegue(withIdentifier: "mapSegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "cameraSegue"){
            if let dest = segue.destination as? UploadViewController {
                dest.type = self.type
                dest.capturedImage = self.capturedImage
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

