//
//  WelcomeViewController.swift
//  meldhet
//
//  Created by Sascha Worms on 18/10/2018.
//  Copyright © 2018 cheesycode.com. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func nextPage(_ sender: Any) {
        let pageViewController = self.parent as! WelcomePageViewController
        pageViewController.nextView()
    }
    @IBAction func skip(_ sender: Any) {
        let pageViewController = self.parent as! WelcomePageViewController
        pageViewController.skip()
    }
}
