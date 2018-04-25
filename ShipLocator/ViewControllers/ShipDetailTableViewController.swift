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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = ship?.name
        tableView.delegate = self
        shipDetailModel = ShipDetailModelImpl() { details in
            self.tableView.reloadData()
        }
        shipDetailModel?.fetchDetailsFor(mmsi: (ship?.mmsi)!, withLocation: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ShipDetailTableViewController.shipLocationChanged), name: NSNotification.Name(rawValue: Constants.shipLocationNotifications), object: nil)
    }
    
    @objc private func shipLocationChanged(notification: Notification) {
        guard let location = notification.userInfo![Constants.shipLocationNotifications] as? ShipLocation else {
            debugPrint("invalid payload in", notification.userInfo)
            return
        }
        if location.data.mmsi == ship?.mmsi {
            debugPrint("Received new location for", String(describing: ship))
            shipDetailModel?.fetchDetailsFor(mmsi: (ship?.mmsi)!, withLocation: location)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipDetailModel?.shipDetail?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: cellIdentifier)
        }
        let detail = shipDetailModel?.shipDetail?[indexPath.row]
        
        cell?.textLabel?.text = detail?.key ?? ""
        cell?.detailTextLabel?.text = detail?.value ?? ""
        
        return cell!
    }
}
