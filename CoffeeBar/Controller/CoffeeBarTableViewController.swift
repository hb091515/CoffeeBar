//
//  CoffeeShopTableViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/5.
//

import UIKit
import Alamofire
import SwiftyJSON


class CoffeeBarTableViewController: UITableViewController,UISearchResultsUpdating {
    
    var coffeeBars:[CoffeeBar] = []
    
    var searchController: UISearchController!
    var searchResults:[CoffeeBar] = []
    
    let apiAddress = "https://cafenomad.tw/api/v1.2/cafes"
    var urlSession = URLSession(configuration: .default)
    
    var likeVC: MyFavoriteViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  downloadInfo(webAddress: apiAddress)
        searchBarSetting()
        getDataFromAlamofire(webAddress: apiAddress)
        
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        }else {
            return coffeeBars.count
        }
       
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeBarCell", for: indexPath) as? CoffeeBarTableViewCell{
            
            
            let coffeebar = (searchController.isActive) ? searchResults[indexPath.row] : coffeeBars[indexPath.row]
            
            cell.coffeeBarName.text = coffeebar.name
            cell.coffeeBarCity.text = coffeebar.city

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
            
            cell.coffeeBarAddress.text = coffeebar.address
            cell.likeImage.isHidden = (coffeebar.like) ? false : true
           
            return cell
        }else{
            let cell = UITableViewCell()
            
            return cell
        }
        
}
    
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }else{
            return true
        }
    }
    
    //判斷使用者以滾動到最後一筆資料
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        print(offsetY,contentHeight)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let likeAction = UIContextualAction(style: .normal, title: (coffeeBars[indexPath.row].like) ? "UnLike" : "Like", handler: {
            (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! CoffeeBarTableViewCell
            self.coffeeBars[indexPath.row].like = (self.coffeeBars[indexPath.row].like) ? false : true
            cell.likeImage.isHidden = self.coffeeBars[indexPath.row].like ? false : true
            
            
            completionHandler(true)
        })
        
        let checkInIcon = coffeeBars[indexPath.row].like ? "heart.slash" : "heart.fill"
        likeAction.backgroundColor = UIColor(red: 255/255, green: 171/255, blue: 133/256, alpha: 1)
        likeAction.image = UIImage(systemName: checkInIcon)
        
        if self.coffeeBars[indexPath.row].like == true{
            self.likeVC?.likeCoffeeBar.append(self.coffeeBars[indexPath.row])
        }

        
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
    func getDataFromAlamofire(webAddress:String){
        //判斷 string 能否轉換成 url
        guard let url = URL(string: webAddress) else { return }
        
        // 使用 Alamofire 獲取 url 上的資料
        AF.request(url, method: .get).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_, subJson) in json {
                    let data = CoffeeBar(name: subJson["name"].stringValue, city: subJson["city"].stringValue, address: subJson["address"].stringValue, wifi: subJson["wifi"].doubleValue, seat: subJson["seat"].doubleValue, quiet: subJson["quiet"].doubleValue, cheap: subJson["cheap"].doubleValue, tasty: subJson["tasty"].doubleValue, music: subJson["music"].doubleValue, latitude: subJson["latitude"].stringValue, longitude: subJson["longitude"].stringValue, url: subJson["url"].stringValue, like: false)
                    self.coffeeBars.append(data)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }

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
            
            let name = CoffeeBar.name
            let city = CoffeeBar.city
            let address = CoffeeBar.address
            let isMatch = name.localizedCaseInsensitiveContains(searchText) || city.localizedCaseInsensitiveContains(searchText) || address.localizedCaseInsensitiveContains(searchText)
                
            return isMatch
            
            
        }
        )
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
