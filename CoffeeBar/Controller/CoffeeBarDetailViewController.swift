//
//  CoffeeBarDetailViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/8.
//

import UIKit
import MapKit
import SafariServices

class CoffeeBarDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var hearderView: CoffeeBarDetailHeaderView!

    
    var coffeeBarInfo: CoffeeBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = coffeeBarInfo?.name!
        
        if let infoCoffeeData = coffeeBarInfo{
            if let lati = infoCoffeeData.latitude, let long = infoCoffeeData.longitude{
                mapSetting(withlatitude: Double("\(lati)")!, withlongitude: Double("\(long)")!)
            }
        }
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(named: "store")
            cell.showTextLabel.text = coffeeBarInfo?.name!
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(systemName: "location")
            cell.showTextLabel.text = coffeeBarInfo?.address!
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(systemName: "wifi")
            cell.showTextLabel.text = "WIFI穩定 \(coffeeBarInfo!.wifi!)"
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(named: "seat")
            cell.showTextLabel.text = "通常有位 \(coffeeBarInfo!.seat!)"
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(named: "tasty")
            cell.showTextLabel.text = "咖啡好喝 \(coffeeBarInfo!.tasty!)"
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(named: "cost")
            cell.showTextLabel.text = "價格便宜 \(coffeeBarInfo!.cheap!)"
            
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(systemName: "music.note")
            cell.showTextLabel.text = "裝潢音樂 \(coffeeBarInfo!.music!)"
            
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
            cell.iconImage.image = UIImage(named: "web")
            cell.showTextLabel.text = "\(coffeeBarInfo!.name!)" + " " + "官方網站"
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 7{
            if let url = URL(string: coffeeBarInfo!.url!){
                let safariVC = SFSafariViewController(url: url)
                safariVC.preferredBarTintColor = .black
                safariVC.preferredControlTintColor = .white
                safariVC.dismissButtonStyle = .close
                safariVC.delegate = self
                self.present(safariVC, animated: true, completion: nil)
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    func mapSetting(withlatitude latitude:Double,withlongitude longitude:Double){
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let xScale:CLLocationDegrees = 0.01
        let yScale:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: xScale, longitudeDelta: yScale)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        hearderView.Map.setRegion(region, animated: true)
        
        let addAnnotation = MKPointAnnotation()
        addAnnotation.coordinate = location
        addAnnotation.title = coffeeBarInfo?.name!
        hearderView.Map.addAnnotation(addAnnotation)
    }

}
