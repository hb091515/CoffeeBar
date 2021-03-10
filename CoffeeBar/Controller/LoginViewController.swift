//
//  LoginViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/9.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController{
    
    let fbLoginManager = LoginManager()

    @IBAction func facebookButton(_ sender: UIButton) {
        
        
        fbLoginManager.logIn(permissions: [.publicProfile, .email]) { (result) in
              if case LoginResult.success(granted: _, declined: _, token: _) = result {
                  print("login ok")
              } else {
                  print("login fail")
              }
        }
        
//        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self)
//        { (result, error) in
//            if result != nil{
//                if let cancel = result?.isCancelled{
//                    let tokenInfo = result?.token
//                    let tokenString = tokenInfo?.tokenString
//                    let uid = tokenInfo?.userID
//
//                    if !cancel{
//                        print("登入成功")
//                        self.prepareForStoryBoard()
//                    }
//                }
//            }else{
//                print(error!.localizedDescription)
//            }
//        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let accessToken = AccessToken.current {
//            Profile.loadCurrentProfile { (profile, error) in
//                if let profile = profile {
//                   print(profile.name)
//                   print(profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300)))
//                }
//            }
//         }
       
        //透過GraphRequest取得相關資訊
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
        request.start { (response, result, error) in
           if let result = result as? [String:String] {
              print(result)
           }
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //AccessToken 有值表示使用者登入過了
//        if let accessToken = AccessToken.current {
//            if accessToken.userID.isEmpty {
//                print("no login")
//            }else{
//                prepareForStoryBoard()
//            }
//        }
    }
    
    
    //轉跳到主頁面
    func prepareForStoryBoard(){
        let homepageStoryBoard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homepage")
        self.present(homepageStoryBoard, animated: true, completion: nil)
    }
    


    // Swift override func viewDidLoad() { super.viewDidLoad() if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller. } }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
