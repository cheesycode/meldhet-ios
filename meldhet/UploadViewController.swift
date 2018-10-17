//
//  UploadViewController.swift
//  meldhet
//
//  Created by Sascha Worms on 17/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import UIKit
import FirebaseStorage

class UploadViewController: UIViewController {
    var type : String = ""
    var capturedImage = UIImage()
    
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let filepath = storageRef.child("images/" + NSUUID().uuidString)
        var data = Data()
        data = capturedImage.jpegData(compressionQuality: 0.5)!
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        _ = filepath.putData(data, metadata: metaData) { (metadata, error) in
            guard metadata != nil else {
                    print(error.debugDescription)
                    self.error()
                return
            }
        }
    }
    
    func error (){
        print("Something went wrong")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.text.text = self.type
        self.image.image = self.capturedImage
    }
}
