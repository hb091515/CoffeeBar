//
//  CoffeeBarDetailViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/8.
//

import UIKit
import MapKit
import CoreData
import SafariServices

class CoffeeBarDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var hearderView: CoffeeBarDetailHeaderView!

    var coffeeBarInfo: CoffeebarModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = coffeeBarInfo?.name
        
        mapSetting(withlatitude: Double(coffeeBarInfo.latitude!)!, withlongitude: Double(coffeeBarInfo.longitude!)!)
        
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        tableView.tableFooterView = UIView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return 6
        case 2:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarInfoCell", for: indexPath) as! CoffeeBarInfoCell
        
        

        if indexPath.section == 0 {
            cell.iconImage.image = UIImage(named: "store")
            cell.showTextLabel.text = coffeeBarInfo?.name
            
            return cell
        }else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                cell.iconImage.image = UIImage(named: "location")
                cell.showTextLabel.text = coffeeBarInfo?.address
                return cell
            case 1:
                cell.iconImage.image = UIImage(named: "wifi")
                if String(coffeeBarInfo!.wifi) == "0.0"{
                    cell.showTextLabel.text = "尚無資訊"
                    cell.showTextLabel.textColor = .red
                }else{
                    cell.showTextLabel.text = "WIFI穩定 \(coffeeBarInfo!.wifi)"
                }
                return cell
            case 2:
                cell.iconImage.image = UIImage(named: "seat")
                if String(coffeeBarInfo!.seat) == "0.0"{
                    cell.showTextLabel.text = "尚無資訊"
                    cell.showTextLabel.textColor = .red
                }else{
                    cell.showTextLabel.text = "通常有位 \(coffeeBarInfo!.seat)"
                }
                return cell
            case 3:
                cell.iconImage.image = UIImage(named: "tasty")
                if String(coffeeBarInfo!.tasty) == "0.0"{
                    cell.showTextLabel.text = "尚無資訊"
                    cell.showTextLabel.textColor = .red
                }else{
                    cell.showTextLabel.text = "咖啡好喝 \(coffeeBarInfo!.tasty)"
                }

                return cell
            case 4:
                cell.iconImage.image = UIImage(named: "cost")
                if String(coffeeBarInfo!.cheap) == "0.0"{
                    cell.showTextLabel.text = "尚無資訊"
                    cell.showTextLabel.textColor = .red
                }else{
                    cell.showTextLabel.text = "價格便宜 \(coffeeBarInfo!.cheap)"
                }

                return cell
            case 5:
                cell.iconImage.image = UIImage(named: "music")
                if String(coffeeBarInfo!.music) == "0.0"{
                    cell.showTextLabel.text = "尚無資訊"
                    cell.showTextLabel.textColor = .red
                }else{
                    cell.showTextLabel.text = "裝潢音樂 \(coffeeBarInfo!.music)"
                }

                return cell
            default:
                return cell
            }
        }else if indexPath.section == 2{
            if coffeeBarInfo.url == ""{
                cell.showTextLabel.text = "尚無網站資訊"
                cell.showTextLabel.textColor = .red
            }else{
                cell.iconImage.image = UIImage(named: "web")
                cell.showTextLabel.text = "\(coffeeBarInfo.name!)" + " " + "網站"
            }
            

            return cell
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 :
            return "店名"
        case 1 :
            return "咖啡廳資訊"
        case 2:
            return "店家網址"
        default:
            return nil
        }
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 204/255, green: 119/255, blue: 34/255, alpha: 0.7)
        header.textLabel?.font = UIFont.systemFont(ofSize: 18.0)
        
    }
    
    
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if indexPath.row == 0{
                if let url = URL(string: coffeeBarInfo!.url!){
                    let safariVC = SFSafariViewController(url: url)
                    safariVC.preferredBarTintColor = .black
                    safariVC.preferredControlTintColor = .white
                    safariVC.dismissButtonStyle = .close
                    safariVC.delegate = self
                    self.present(safariVC, animated: true, completion: nil)
                }
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
        addAnnotation.title = coffeeBarInfo?.name
        hearderView.Map.addAnnotation(addAnnotation)
    }
    


}
