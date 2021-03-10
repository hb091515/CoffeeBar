//
//  ProfileViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/10.
//

import UIKit
import FBSDKLoginKit


class ProfileViewController: UIViewController {
    
  
    
    var infoTableViewController: ProfileTableViewController?

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
        request.start { (response, result, error) in
           if let result = result as? [String:String] {
            if let name = result["name"], let email = result["email"]{
                self.UserName.text = name
                self.infoTableViewController?.emailAddress.text = email
            }
           }
        }
        
    }
//        UserName.text = profile!.name!
//        infoTableViewController?.emailAddress.text = profile!.email!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserImage.layer.cornerRadius = UserImage.frame.size.width / 2
        UserImage.clipsToBounds = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileInfo"{
            infoTableViewController = segue.destination as? ProfileTableViewController
        }
    }
}
