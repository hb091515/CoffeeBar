//
//  ProfileTableViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/11.
//

import UIKit
import FBSDKLoginKit
import Firebase
import CoreData

class FavoriteTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {

    var favoriteCoffeebar:[CoffeebarModel] = []
    
    var fetchResultController : NSFetchedResultsController<CoffeebarModel>!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCoreDataWithFavorite()
        tableView.tableFooterView = UIView()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
//        var numOfSection: Int = 0
//        if favoriteCoffeebar.count == 0{
//            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//            noDataLabel.text = "還沒加入任何收藏"
//            noDataLabel.textColor = UIColor.black
//            noDataLabel.textAlignment = .center
//            tableView.backgroundView = noDataLabel
//            tableView.separatorStyle = .none
//        }else{
//            numOfSection = 1
//            tableView.backgroundView = nil
//        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteCoffeebar.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.shopName.text = favoriteCoffeebar[indexPath.row].name
        cell.cityName.text = favoriteCoffeebar[indexPath.row].city
        cell.addressLabel.text = favoriteCoffeebar[indexPath.row].address
        cell.likeImage.isHidden = (favoriteCoffeebar[indexPath.row].like) ? false : true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: {
            (action, sourceView, completionHandler) in
            
            //儲存喜好咖啡廳狀態
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                self.favoriteCoffeebar[indexPath.row].like = false
                
                appDelegate.saveContext()
            }
            
            completionHandler(true)
        })
        
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        deleteAction.image = UIImage(systemName: "trash")
        
        
        

        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration

        
    }
    
    func popAlert(title: String){
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "是", style: .default, handler: {
            (action) in
            
            //獲取當前登入用戶,如未登入則為nil
            if Auth.auth().currentUser != nil{
                do{
                    try Auth.auth().signOut()
                    self.dismiss(animated: true, completion: nil)
                }catch{
                    print(error.localizedDescription)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "否", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchCoreDataWithFavorite() {
        
        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<CoffeebarModel> = CoffeebarModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.predicate = NSPredicate(format: "%K == true","like")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchObjects = fetchResultController.fetchedObjects {
                    favoriteCoffeebar = fetchObjects
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
            favoriteCoffeebar = fetchObjects as! [CoffeebarModel]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo"{
            if let dest = segue.destination as? CoffeeBarDetailViewController{
                //目前選到哪個列,點到哪個section哪個row
                let selectedIndexPath = self.tableView.indexPathForSelectedRow
                if let selectedRow = selectedIndexPath?.row {
                    dest.coffeeBarInfo = favoriteCoffeebar[selectedRow]

                }
                
            }
        }
        
    }
}
