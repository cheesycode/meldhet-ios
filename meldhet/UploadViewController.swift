//
//  UploadViewController.swift
//  meldhet
//
//  Created by Sascha Worms on 17/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import FirebaseStorage
import Firebase
import Alamofire
import KDCircularProgress

class UploadViewController: UIViewController, CLLocationManagerDelegate {
    var type : String = ""
    var retries : Int = 0
    var capturedImage = UIImage()
    var location  = CLLocation()
    var filename : String = ""
    var locationManager : CLLocationManager!
    var progress : KDCircularProgress!
    @IBOutlet weak var titleThnx: UITextField!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var sendAgain: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    func initialize(){
        self.locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        self.filename = uploadImage()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(manager.location != nil){
            print(manager.location!.horizontalAccuracy)
            if(manager.location!.horizontalAccuracy < 66.0 && self.retries < 5){
                self.location = manager.location!
                self.locationManager.stopUpdatingLocation()
                sendDataToServer(filepath: self.filename)
            }
            else if(self.retries >= 5){
                error(error: "Location search timedout")
            }
            else{
                self.progress.animate(toAngle: (self.progress.angle+15.0), duration: 1, completion: nil)
                self.retries += 1                
            }
        }
       
    }
    
    func sendDataToServer(filepath : String) {
        self.progress.animate(toAngle: 345, duration: 1, completion: nil)
        let parameters = [
            "id": AppDelegate.deviceID!,
            "image": filepath,
            "tag": self.type,
            "lat": self.location.coordinate.latitude,
            "lon": self.location.coordinate.longitude,
            "acc": self.location.horizontalAccuracy
            ] as [String : Any]
        Alamofire.request("https://api.meldhet.cheesycode.com/v1/issues/create/",method:.post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success:
                print("Validation Successful")
                
                self.progress.animate(toAngle: 360, duration: 1, completion: { (Bool) in
                    self.progress.set(colors: UIColor.green)
                    self.titleThnx.isHidden = false
                    self.messageText.isHidden = false
                    self.sendAgain.isHidden = false
                })
            case .failure(let error):
                self.error(error: error.localizedDescription);
            }
        }
    }
    
    
    @IBAction func clicked(_ sender: Any) {
        if(self.sendAgain.title(for: .normal) == "Opniuw Proberen?"){
            
            self.titleThnx.isHidden = true
            self.messageText.isHidden = true
            self.sendAgain.isHidden = true
            self.titleThnx.text = "Bedankt!"
            self.messageText.text = "Jouw aanvraag is verstuurd naar de gemeente en wordt zo spoedig mogelijk behandeld."
            self.sendAgain.setTitle("Nog een melding maken?", for: .normal)
            
            initialize()
            
        } else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func  uploadImage() -> String{
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let filename = NSUUID().uuidString
        let filepath = storageRef.child("images/" + filename)
        var data = Data()
        data = capturedImage.jpegData(compressionQuality: 0.5)!
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let uploadTask = filepath.putData(data, metadata: metaData) { (metadata, error) in
            guard metadata != nil else {
                self.error(error: error.debugDescription)
                return
            }
        }
        _ = uploadTask.observe(.progress) { snapshot in
            if(self.progress.angle<360){
            self.progress.animate(toAngle: (self.progress.angle+25.0), duration: 1,  completion:nil)
        }
        }
        return filename
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        progress.progressThickness = 0.4
        progress.startAngle = -90
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.glowMode = .forward
        progress.glowAmount = 2
        progress.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
        progress.center = CGPoint(x: view.center.x, y: view.center.y + 25)
        view.addSubview(progress)
        messageText.sizeToFit()
    }
    
    func error (error : String){
        print("Something went wrong" + error)
        self.locationManager.stopUpdatingLocation()
        self.progress.animate(fromAngle:0, toAngle: 360, duration: 1) { (Bool) in
            self.progress.set(colors: UIColor.red)
            self.titleThnx.text = "Oeps..."
            self.titleThnx.isHidden = false
            self.messageText.text = "Er is iets mis gegaan, probeer het later nog eens"
            self.messageText.isHidden = false
            self.sendAgain.setTitle("Opniuw Proberen?", for: .normal)
            self.sendAgain.isHidden = false
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.locationManager.stopUpdatingLocation()
    }
}
