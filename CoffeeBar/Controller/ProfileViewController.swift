//
//  ProfileViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/10.
//

import UIKit
import FBSDKLoginKit
import Firebase


class ProfileViewController: UIViewController {
    
  
    

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let userinfo = Auth.auth().currentUser
//        if let user = userinfo{
//            let uid = user.uid
//            let email = user.email
//            let photo = user.photoURL
//            print(uid)
//            print(email!)
//            print("photo\(String(describing: photo))")
//        }
//
//        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
//        request.start { (response, result, error) in
//           if let result = result as? [String:String] {
//            if let name = result["name"], let email = result["email"]{
//                self.UserName.text = name
//            }
//           }
//        }
        
    }
//        UserName.text = profile!.name!
//        infoTableViewController?.emailAddress.text = profile!.email!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UserImage.layer.cornerRadius = UserImage.frame.size.width / 2
//        UserImage.clipsToBounds = true
    }


    
}
