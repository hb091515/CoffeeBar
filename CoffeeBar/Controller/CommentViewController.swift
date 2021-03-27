//
//  MyFavoriteViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/11.
//

import UIKit
import CoreData
import CloudKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!

    var fetchResultController: NSFetchedResultsController<CommentModel>!
    var comments: [CommentModel] = []   //CoreData用
    var cloudComments: [CKRecord] = []
    var activityIndicator = UIActivityIndicatorView()
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorSetting()
        fetchRecordsFromCloud()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        pulltoRefresh()
        
    }
    
    func activityIndicatorSetting(){
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        activityIndicator.startAnimating()
        
    }
    
    func pulltoRefresh(){
        tableView.refreshControl = UIRefreshControl()
        
        tableView.refreshControl?.tintColor = .gray
        tableView.refreshControl?.backgroundColor = .white
        //更新元件呼叫fetchRecordsFromCloud來更新餐廳紀錄
        tableView.refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
    }
    
    
    @objc func fetchRecordsFromCloud(){
        
        //更新之前移除資料記錄
        cloudComments.removeAll()
        tableView.reloadData()
        
        //便利型API取得資料
        let cloudContainer = CKContainer(identifier: "iCloud.cofeBarContainer")
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)   //指定資料過濾方式
        let query = CKQuery(recordType: "Comment", predicate: predicate)
        
        //以 query 建立查詢方式(操作型API)
        let queryOperation = CKQueryOperation(query: query)
        //queryOperation.desiredKeys = ["name","description","image"] //指定要取得的欄位
        queryOperation.desiredKeys = ["name","description"]
        queryOperation.queuePriority = .veryHigh    //指定操作的執行順序
        queryOperation.resultsLimit = 50  //紀錄最大數量
        
        //每一筆資料回傳時執行
        queryOperation.recordFetchedBlock = {
            (record) in
            self.cloudComments.append(record)  //將資料加入Array
            
        }
        
        //取得所有資料後執行
        queryOperation.queryCompletionBlock = {
            [unowned self] (cursor, error) in
            if let error = error{
                print("failed")
                return
            }
            
            print("success")
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                if let refresh = self.tableView.refreshControl{
                    if refresh.isRefreshing{
                        refresh.endRefreshing()
                    }
                }
                
            }
        }
        
        //執行查詢
        publicDatabase.add(queryOperation)
        
        //便利型API的perform方法
//        publicDatabase.perform(query, inZoneWith: nil, completionHandler: {
//            (result, error) -> Void in
//
//            if let error = error {
//                print(error)
//                return
//            }
//
//            if let result = result{
//                print("成功下載資料")
//                self.cloudComments = result
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        })
    }
    
    
    //Core Data用的方法
    func fetchRecordFromCoreData(){
        //從CommentModel取得NSFetchRequest物件
        let fetchRequest: NSFetchRequest<CommentModel> = CommentModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)  //以name作為鍵值
        fetchRequest.sortDescriptors = [sortDescriptor]    //指定CommentModel物件為升序排列
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            //初始化fetchResultController
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            //指定委派來監聽資料存取變化
            fetchResultController.delegate = self
            
            do{
                try fetchResultController.performFetch()
                if let fetchObjects = fetchResultController.fetchedObjects{
                    comments = fetchObjects
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cloudComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell{
            
            let comment = cloudComments[indexPath.row]
            cell.nameLabel.text = comment.object(forKey: "name") as? String
            cell.descTextfield.text = comment.object(forKey: "description") as? String
            
            //設定預設圖片
            cell.commentImage.image = UIImage(systemName: "photo")
            
            //檢查圖片已存在快取
            if let imageFileURL = imageCache.object(forKey: comment.recordID){
                if let imageData = try? Data.init(contentsOf: imageFileURL as URL){
                    cell.commentImage.image = UIImage(data: imageData)
                }
            }else{
                //從雲端取得圖片(須將CKContainer.default().publicCloudDatabase寫法改成下面)
                let publicDatabase = CKContainer(identifier: "iCloud.cofeBarContainer").publicCloudDatabase
                let fetchRecordImage = CKFetchRecordsOperation(recordIDs: [comment.recordID]) //取得特定資料
                fetchRecordImage.desiredKeys = ["image"]
                fetchRecordImage.queuePriority = .veryHigh
                
                //取得紀錄後指定程式碼區塊來執行
                fetchRecordImage.perRecordCompletionBlock = {
                    [unowned self](record,recordID,error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    if let commentRecord = record, let image = commentRecord.object(forKey: "image"),let imageAsset = image as? CKAsset{
                        if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!){
                            DispatchQueue.main.async {
                                //取得圖片後，預設圖片會被剛下載的圖片取代
                                cell.commentImage.image = UIImage(data: imageData)
                                cell.setNeedsLayout()   //要求cell重新佈局視圖
                            }
                        }
                    }
                }
                publicDatabase.add(fetchRecordImage)
            }
                
            
            
            //cloud
//            if let image = comment.object(forKey: "image"),let imageAsset = image as? CKAsset{
//                if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!){
//                    cell.commentImage.image = UIImage(data: imageData)
//                }
//            }
            
//            cell.nameLabel.text = comments[indexPath.row].name
//            cell.descTextfield.text = comments[indexPath.row].desc
//
//            if let image = comments[indexPath.row].image{
//                cell.commentImage.image = UIImage(data: image as Data)
//            }
            cell.commentImage.layer.cornerRadius = cell.commentImage.frame.size.width / 2
            cell.commentImage.clipsToBounds = true
            
            return cell
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.text = ""
            
            return cell
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}
