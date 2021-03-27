//
//  CityTableViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/24.
//

import UIKit

class CityTableViewController: UITableViewController {
    
    let cityName = ["台北","基隆","桃園","新竹","苗栗","台中","南投","彰化","雲林","嘉義","台南","高雄","屏東","宜蘭","花蓮","台東","澎湖","連江"]
    let cityimage = ["taipei","keelung","taoyuan","hsinchu","miaoli","taichung","nantou","changhua","yunlin","chiayi","tainan","kaohsiung","pingtung","yilan","hualien","taitung","penghu","lienchiang"]

        
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityimage.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityTableViewCell

        cell.cityLabel.text = cityName[indexPath.row]
        cell.cityImage.image = UIImage(named: cityimage[indexPath.row])

        return cell
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citySegue"{
            //目前選到哪個列,點到哪個section哪個row
            if let indexPath = tableView.indexPathForSelectedRow{
                let tabbarController = self.tabBarController?.viewControllers?[0] as? CoffeeBarTableViewController
            }
            
        }
        
        
        
    }
    

    
}
