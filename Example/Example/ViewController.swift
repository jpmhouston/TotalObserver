//
//  ViewController.swift
//  TotalObserver
//
//  Created by Pierre Houston on 2015-11-11.
//  Copyright © 2015 Pierre Houston. All rights reserved.
//

import Foundation

class ViewControllerSwiftSubclass : ViewController
{
    override func viewDidLoad() -> () {
        super.viewDidLoad()
        
        self.modelObject.to_observeChangesToKeyPath("flag") { obs in
            self.addLineToTextView("observed model.flag property from swift")
        }
        
        self.modelObject.to_observeNotificationsNamed(NameChangedNotification) { obs in
            self.addLineToTextView("observed NameChangedNotification from swift")
        }
    }
}
