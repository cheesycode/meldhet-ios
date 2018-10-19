//
//  CoreDataHelper.swift
//  meldhet
//
//  Created by Sascha Worms on 19/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper{
    static var context : NSManagedObjectContext? = nil
    
    init(appDelegate : AppDelegate){
        if(CoreDataHelper.context == nil){
            CoreDataHelper.context = appDelegate.persistentContainer.viewContext
        }
    }
    init(){}
    
    func writeList(issues: [Issue]){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EIssue")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try CoreDataHelper.context!.execute(deleteRequest)
        } catch _ as NSError {
            print("Failed Deleting")
        }
        for  issue in issues {
            let entity = NSEntityDescription.entity(forEntityName: "EIssue", in: CoreDataHelper.context!)
            let newIssue = NSManagedObject(entity: entity!, insertInto: CoreDataHelper.context!)
            newIssue.setValue(issue.acc, forKey: "acc")
            newIssue.setValue(issue.creator, forKey: "creator")
            newIssue.setValue(issue.image, forKey: "image")
            newIssue.setValue(issue.lat, forKey: "lat")
            newIssue.setValue(issue.lon, forKey: "lon")
            newIssue.setValue(issue.tag, forKey: "tag")
            newIssue.setValue(issue.id, forKey: "id")
            newIssue.setValue(issue.status, forKey: "status")
            do {
                try CoreDataHelper.context!.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func getList() -> [Issue]{
        var issues = [Issue]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EIssue")
        request.predicate = NSPredicate(format: "creator == %@", AppDelegate.deviceID!)
        request.returnsObjectsAsFaults = false
        do {
            let result = try CoreDataHelper.context!.fetch(request)
            for data in result as! [NSManagedObject] {
                issues.append(Issue(acc: data.value(forKey: "acc") as! Float, creator: data.value(forKey: "creator") as! String, image: data.value(forKey: "image") as! String, lat: data.value(forKey: "lat") as! Float, lon: data.value(forKey: "lon") as! Float, tag: data.value(forKey: "tag") as! String, id: data.value(forKey: "id") as! String, status: data.value(forKey: "status") as! String?  ))
            }
            
        } catch {            
            print("Failed")
        }
        return issues
    }
}
