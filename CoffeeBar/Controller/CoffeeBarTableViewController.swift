//
//  CoffeeShopTableViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/5.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData


class CoffeeBarTableViewController: UITableViewController,UISearchResultsUpdating,NSFetchedResultsControllerDelegate {
    
    var coffeeBars:[CoffeebarModel] = []
    
    var searchController: UISearchController!
    var searchResults:[CoffeebarModel] = []
    
    let apiAddress = "https://cafenomad.tw/api/v1.2/cafes/"
    var urlSession = URLSession(configuration: .default)
    
    var fetchResultController : NSFetchedResultsController<CoffeebarModel>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        searchBarSetting()
        //resetAllRecord(in: "Coffeebar")
        //getDataFromAlamofire(webAddress: apiAddress)
        fetchDataFromCoreData()
        
        

    }
    
    //刪除全部紀錄
    func resetAllRecord(in entity: String){
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let delete = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: delete)
        
        do {
            try context?.execute(request)
            try context?.save()
        } catch {
            print("there was an error")
        }
        
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
    
    //滑動加入喜愛名單
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let likeAction = UIContextualAction(style: .normal, title: (coffeeBars[indexPath.row].like) ? "UnLike" : "Like", handler: {
            (action, sourceView, completionHandler) in
            
            //儲存喜好咖啡廳狀態
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                let cell = tableView.cellForRow(at: indexPath) as! CoffeeBarTableViewCell
                self.coffeeBars[indexPath.row].like = (self.coffeeBars[indexPath.row].like) ? false : true
                cell.likeImage.isHidden = self.coffeeBars[indexPath.row].like ? false : true
                
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        })
        
        let checkInIcon = coffeeBars[indexPath.row].like ? "heart.slash" : "heart.fill"
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


/*
    // MARK: - API Service methods
    func getDataFromAlamofire(webAddress:String){
        //判斷 string 能否轉換成 url
        guard let url = URL(string: webAddress) else { return }
        // 使用 Alamofire 獲取 url 上的資料
        AF.request(url, method: .get).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("多少\(json.count)")
                for (_, subJson) in json {
                    //let data = CoffeeBar(name: subJson["name"].stringValue, city: subJson["city"].stringValue, address: subJson["address"].stringValue, wifi: subJson["wifi"].doubleValue, seat: subJson["seat"].doubleValue, quiet: subJson["quiet"].doubleValue, cheap: subJson["cheap"].doubleValue, tasty: subJson["tasty"].doubleValue, music: subJson["music"].doubleValue, latitude: subJson["latitude"].stringValue, longitude: subJson["longitude"].stringValue, url: subJson["url"].stringValue, like: false)
                    //self.coffeeBars.append(data)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }

    }
        
    }
    */
    
    func fetchDataFromCoreData(){
        
        
        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<CoffeebarModel> = CoffeebarModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchObjects = fetchResultController.fetchedObjects {
                    coffeeBars = fetchObjects
                }
            } catch {
                print(error)
            }
        }
    }
    
    //準備處理內容變更時會呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type{
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        if let fetchObjects = controller.fetchedObjects{
            coffeeBars = fetchObjects as! [CoffeebarModel]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
            let isMatch = name!.localizedCaseInsensitiveContains(searchText) || city!.localizedCaseInsensitiveContains(searchText) || address!.localizedCaseInsensitiveContains(searchText)
                
            return isMatch
            
            
        }
        )
    }
    
    //設定搜尋列
    func searchBarSetting(){
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "輸入店家名稱,城市,地址..."
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
