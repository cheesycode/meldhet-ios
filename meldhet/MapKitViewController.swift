//
//  MapKitViewController.swift
//  meldhet
//
//  Created by Michel Megens on 17/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import Foundation
import UIKit
import MapKit;

class MapKitViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var geoLocation : CLLocationManager
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        self.geoLocation = CLLocationManager()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.geoLocation = CLLocationManager()
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.geoLocation.requestAlwaysAuthorization()
        self.geoLocation.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            self.geoLocation.delegate = self
            self.geoLocation.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.geoLocation.startUpdatingLocation()
        }
        
        print("View loaded..")
        self.loadIssues()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        self.geoLocation.stopUpdatingLocation()
    }
    
    private func loadIssues() {
        let urlString = URL(string: "https://api.meldhet.cheesycode.com/v1/issues/get?id=ciRn07FS06w:APA91bHsNYB4sLUSN8DNoiFsd-2fNnknun3dmTtfGCcPtFpdsGtGADjY36UgqvBvs-6ik_UNSjGd_m17nII1NDdBaPQk58h4i73SoqDRVoihTHYiGlw4YDD-tYlcfkaQ0e4O9-m10Xqh")
        
        let session = URLSession.shared
        if let usableUrl = urlString {
            let task = session.dataTask(with: usableUrl, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        print(stringData)
                    }
                    
                    guard let json = try? JSONDecoder().decode([Issue].self, from: data) else {
                        print("Error unable to deserialize issue's")
                        return;
                    }
                    
                    for issue in json {
                        let annotation = IssueAnnotation(id: issue.id, issue: issue)
                        let lat = CLLocationDegrees(issue.lat)
                        let lon = CLLocationDegrees(issue.lon)
                        let loc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        
                        annotation.coordinate = loc
                        annotation.title = issue.tag
                        annotation.subtitle = issue.status
                        self.mapView.addAnnotation(annotation)
                    }
                }
            })
         
            task.resume()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! IssueAnnotation
        
        print("You clicked on issue: " + annotation.issue.id)
        self.performSegue(withIdentifier: "chatSegue", sender: annotation.issue)
    }
    
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let _annotation = annotation as! IssueAnnotation
        let pinAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: _annotation.id)

        
        return pinAnnotationView
    }*/

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let issue = sender as! Issue
        
        if let dest = segue.destination as? ChatViewController {
            dest.issue = issue
        }
    }
}
