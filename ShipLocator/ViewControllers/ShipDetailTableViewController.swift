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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = ship?.name
        tableView.delegate = self
        shipDetailModel = ShipDetailModelImpl() { details in
            self.tableView.reloadData()
        }
        shipDetailModel?.fetchDetailsFor(ship: ship)
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
