//
//  ShipTableViewController.swift
//  ShipLocator
//
//  Created by Tomi Lahtinen on 23/04/2018.
//  Copyright © 2018 Tomi Lahtinen. All rights reserved.
//

import Foundation
import UIKit

class ShipListViewContoller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let detailSegue = "shipInformationSeque"
    
    private var mapViewController: MapViewController? {
        return navigationController?.parent?.childViewControllers
            .filter() { $0 is MapViewController }
            .map() { $0 as! MapViewController }
            .first
    }
    
    @IBOutlet var tableView: UITableView!
    var shipDataModel: ShipDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.shipDataModel = ShipDataModel {
            debugPrint("Meta data changed")
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapViewController?.zoomToAllShips()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("Segue")
        if segue.identifier == detailSegue {
            guard let destination = segue.destination as? ShipDetailTableViewController,
                  let ship = sender as? Ship
            else {
                debugPrint("Something wrong in navigation or sender data", segue, sender ?? "")
                return
            }
            destination.ship = ship
            self.mapViewController?.zoomToSingleShip(mmsi: ship.mmsi)
            debugPrint("Here we go!!", self.mapViewController)
        }
    }
    
    //MARK:-UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shipDataModel?.model.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "shipCellIdentifier"
        let keys = (shipDataModel?.model.keys.map(){ $0 })!
        let shipData = shipDataModel?.model[keys[indexPath.row]]
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        cell!.textLabel?.text = shipData?.name
        cell!.detailTextLabel?.text = (shipData?.callSign ?? "") + " " + (shipData?.destination ?? "")
        
        debugPrint("Celll")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keys = (shipDataModel?.model.keys.map(){ $0 })!
        let shipData = shipDataModel?.model[keys[indexPath.row]]
        debugPrint("Focus on ship", shipData)
        performSegue(withIdentifier: detailSegue, sender: shipData)
    }
}
