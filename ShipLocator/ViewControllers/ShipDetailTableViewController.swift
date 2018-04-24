//
//  ShipDetailViewController.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 24/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class ShipDetailTableViewController: UITableViewController {
    
    var ship: Ship?
    var shipDetailModel: ShipDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateShipInfo()
    }
    
    private func populateShipInfo() {
        
    }
}
