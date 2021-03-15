//
//  MyFavoriteViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/11.
//

import UIKit

class MyFavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var coffeeBarTableViewController: CoffeeBarTableViewController?

    var likeCoffeeBar:[CoffeeBar] = []
    
    var refreshControl:UIRefreshControl!
    
    
    @IBOutlet weak var btnSelectCity: UIButton!
    @IBOutlet weak var btnSelectAttributes: UIButton!
    @IBOutlet weak var btnselectValue: UIButton!
    @IBAction func onClickSelectCity(_ sender: UIButton) {
    }
    @IBAction func onClickSelectAttributes(_ sender: UIButton) {
    }
    @IBAction func onClickSelectValue(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? MyFavoriteTableViewCell{
            
            
            
            return cell
        }else{
            let cell = UITableViewCell()
            cell.textLabel?.text = ""
            
            return cell
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
