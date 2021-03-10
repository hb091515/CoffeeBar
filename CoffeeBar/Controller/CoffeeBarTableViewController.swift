//
//  CoffeeShopTableViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/5.
//

import UIKit
import DropDown

struct CoffeeBar:Decodable{
    var name:String?
    var city:String?
    var address:String?
    var wifi:Double?
    var seat:Double?
    var quiet:Double?
    var cheap:Double?
    var tasty:Double?
    var music:Double?
    var latitude:String?
    var longitude:String?
    var url:String?
    var like:Bool?
}


class CoffeeBarTableViewController: UITableViewController,UISearchResultsUpdating {
    
    var coffeeBars:[CoffeeBar] = []
    
    var searchController: UISearchController!
    var searchResults:[CoffeeBar] = []
    
    let apiAddress = "https://cafenomad.tw/api/v1.2/cafes"
    var urlSession = URLSession(configuration: .default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadInfo(webAddress: apiAddress)
        searchBarSetting()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return searchResults.count
        }else{
            return coffeeBars.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarCell", for: indexPath) as? CoffeeBarTableViewCell{
            
            let coffeebar = (searchController.isActive) ? searchResults[indexPath.row] : coffeeBars[indexPath.row]
            
            cell.coffeeBarName.text = coffeebar.name!
            cell.coffeeBarCity.text = coffeebar.city!
    
            if cell.coffeeBarCity.text == "taipei" {
                cell.coffeeBarCity.text = "台北市"
                } else if cell.coffeeBarCity.text == "chiayi" {
                    cell.coffeeBarCity.text = "嘉義市"
                } else if cell.coffeeBarCity.text == "taichung" {
                    cell.coffeeBarCity.text = "台中市"
                } else if cell.coffeeBarCity.text == "kaohsiung" {
                    cell.coffeeBarCity.text = "高雄市"
                } else if cell.coffeeBarCity.text == "taoyuan" {
                    cell.coffeeBarCity.text = "桃園市"
                } else if cell.coffeeBarCity.text == "yilan" {
                    cell.coffeeBarCity.text = "宜蘭縣"
                } else if cell.coffeeBarCity.text == "changhua" {
                    cell.coffeeBarCity.text = "彰化縣"
                } else if cell.coffeeBarCity.text == "tainan" {
                    cell.coffeeBarCity.text = "台南市"
                } else if cell.coffeeBarCity.text == "nantou" {
                    cell.coffeeBarCity.text = "南投縣"
                } else if cell.coffeeBarCity.text == "hualien" {
                    cell.coffeeBarCity.text = "花蓮縣"
                } else if cell.coffeeBarCity.text == "hsinchu" {
                    cell.coffeeBarCity.text = "新竹市"
                } else if cell.coffeeBarCity.text == "pingtung" {
                    cell.coffeeBarCity.text = "屏東市"
                } else if cell.coffeeBarCity.text == "miaoli" {
                    cell.coffeeBarCity.text = "苗栗縣"
                } else if cell.coffeeBarCity.text == "taitung" {
                    cell.coffeeBarCity.text = "台東縣"
                } else if cell.coffeeBarCity.text == "lienchiang" {
                    cell.coffeeBarCity.text = "連江縣"
                } else if cell.coffeeBarCity.text == "penghu" {
                    cell.coffeeBarCity.text = "澎湖縣"
                } else if cell.coffeeBarCity.text == "yunlin" {
                    cell.coffeeBarCity.text = "雲林縣"
                } else if cell.coffeeBarCity.text == "keelung" {
                    cell.coffeeBarCity.text = "基隆市"}
            cell.coffeeBarAddress.text = coffeebar.address!
            
            cell.likeImage.isHidden = (coffeebar.like!) ? false : true
            
            return cell
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.text = ""
            
            return cell
        }
}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let likeAction = UIContextualAction(style: .normal, title: "Like", handler: {
            (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! CoffeeBarTableViewCell
            self.coffeeBars[indexPath.row].like! = (self.coffeeBars[indexPath.row].like!) ? false : true
            cell.likeImage.isHidden = self.coffeeBars[indexPath.row].like! ? false : true

            completionHandler(true)
        })
        
        let checkInIcon = coffeeBars[indexPath.row].like! ? "heart.slash" : "heart.fill"
        likeAction.backgroundColor = UIColor(red: 255/255, green: 171/255, blue: 133/256, alpha: 1)
        likeAction.image = UIImage(systemName: checkInIcon)

        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [likeAction])
        
        return swipeConfiguration
        
        
    }
    
    //使用者選取搜尋列,呼叫此方法
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    // MARK: - API Service methods
    func downloadInfo(webAddress:String){
        if let url = URL(string: webAddress){
            let task = urlSession.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if error != nil{
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009{         //無網路
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "未連接網路服務")
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.popAlert(withTitle: "出現不明錯誤")
                        }
                    }
                    return
                }
                
                if let loadedData = data{
                    do{
                        let okData = try JSONDecoder().decode([CoffeeBar].self, from: loadedData)
                        for i in 0..<okData.count{
                            let name = okData[i].name!
                            let city = okData[i].city!
                            let address = okData[i].address!
                            let wifi = okData[i].wifi
                            let seat = okData[i].seat!
                            let music = okData[i].music!
                            let tasty = okData[i].tasty!
                            let cheap = okData[i].cheap!
                            let quiet = okData[i].quiet!
                            let longitude = okData[i].longitude!
                            let latitude = okData[i].latitude!
                            let url = okData[i].url!
                            let user = CoffeeBar(name: name, city: city, address: address, wifi: wifi, seat: seat, quiet: quiet, cheap: cheap, tasty: tasty, music: music, latitude: latitude, longitude: longitude, url: url, like: false)
                            self.coffeeBars.append(user)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            })
            task.resume()
        }
    }
    
    func popAlert(withTitle title:String){
        let alertController = UIAlertController(title: title, message: "請稍候再試", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Search methods
    func filterContent(for searchText: String) {
        searchResults = coffeeBars.filter({ (CoffeeBar) -> Bool in
            if let name = CoffeeBar.name, let city = CoffeeBar.city, let address = CoffeeBar.address{
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || city.localizedCaseInsensitiveContains(searchText) || address.localizedCaseInsensitiveContains(searchText)
                
                return isMatch
            }
            return false
        })
    }
    
    func searchBarSetting(){
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "輸入店家名稱,城市..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor.red
        searchController.searchBar.keyboardType = .default
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCoffeeBarDetail"{
            if let dest = segue.destination as? CoffeeBarDetailViewController{
                //目前選到哪個列,點到哪個section哪個row
                let selectedIndexPath = self.tableView.indexPathForSelectedRow
                if let selectedRow = selectedIndexPath?.row {
                    dest.coffeeBarInfo = (searchController.isActive) ? searchResults[selectedRow] : coffeeBars[selectedRow]
                    searchController.isActive = false

                }
                
            }
        }
    }

}
