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
    
    private let cellIdentifier = "shipDetailCell"
    
    var ship: Ship?
    var shipDetailModel: ShipDetailModel?
    var shipViewModel: [(key: String, value:String)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateShipInfo()
        navigationItem.largeTitleDisplayMode = .never
        self.title = ship?.name
        tableView.delegate = self
    }
    /*
    let referencePointA: Int
    let referencePointB: Int
    let referencePointC: Int
    let referencePointD: Int
    let shipType: Int
    let mmsi: Int
    let destination: String?
    let eta: Int
    let callSign: String?
    let imo: Int
    let draught: Int
    let name: String
    */
    
    private func populateShipInfo() {
        shipViewModel = [
            ("Latitude", "0.00"),
            ("Longitude", "0.00"),
            ("Callsign", ship?.callSign ?? ""),
            ("Destination", ship?.destination ?? ""),
            ("Type", "\(String(describing: ship?.shipType))"),
            ("Draught", "\(String(describing: ship?.draught))"),
            ("IMO", "\(String(describing: ship?.imo))"),
            ("MMSI", "\(String(describing: ship?.mmsi))"),
            ("ETA", "\(String(describing: ship?.eta))")
        ]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipViewModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        let detail = shipViewModel?[indexPath.row]
        
        cell?.textLabel?.text = detail?.key ?? ""
        cell?.detailTextLabel?.text = detail?.value ?? ""
        
        return cell!
    }
}
