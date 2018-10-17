//
//  IssueAnnotation.swift
//  meldhet
//
//  Created by Michel Megens on 17/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class IssueAnnotation : MKPointAnnotation {
    var id: String = ""
    var issue : Issue
    
    init(id : String, issue : Issue) {
        self.id = id
        self.issue = issue
    }
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coordinate = newCoordinate
    }
}
