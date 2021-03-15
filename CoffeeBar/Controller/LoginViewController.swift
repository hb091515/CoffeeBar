//
//  LoginViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/9.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices



class LoginViewController: UIViewController {
    
    let fbLoginManager = LoginManager()
    
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func loginButton(_ sender: UIButton) {
        loginWithFirebase()
    }
    @IBAction func facebookButton(_ sender: UIButton) {
        loginWithFacebook()
    }
    @IBAction func appleButton(_ sender: UIButton) {
        loginWithApple()
        
    }
    @IBAction func signUpButton(_ sender: UIButton) {
        popAlertSignUp()
        
    }
    @IBOutlet weak var appleBtnStyle: UIButton!
    
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
    
    func popAlertSignUp(){
        let alertController = UIAlertController(title: "會員註冊", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "註冊", style: .default){
            (action) in
            let email = alertController.textFields![0]
            let password = alertController.textFields![1]
            Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: {
                ( user , error) in
                if error == nil {
                    let success = UIAlertController(title: "註冊成功", message: "", preferredStyle: .alert)
                    success.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(success, animated: true, completion: nil)
                }else{
                    let fail = UIAlertController(title: "錯誤!", message: error?.localizedDescription, preferredStyle: .alert)
                    fail.addAction((UIAlertAction(title: "OK", style: .cancel, handler: nil)))
                    self.present(fail, animated: true, completion: nil)
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addTextField{
            textField in
            textField.placeholder = "請輸入Email..."
        }
        alertController.addTextField{
            textField in
            textField.placeholder = "請輸入密碼..."
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loginWithFirebase(){
        Auth.auth().signIn(withEmail: accountField.text!, password: passwordField.text!)
        { (user, error) in
            if (error != nil) {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.prepareForStoryBoard()
            }
        }
    }
    
    
    func loginWithFacebook(){
        
        
    
        fbLoginManager.logIn(permissions: ["public_profile","email"], from: self)
        { (result, error) in
            if result != nil{
                if let cancel = result?.isCancelled{
                    let tokenInfo = result?.token
                    let tokenString = tokenInfo?.tokenString
                    let uid = tokenInfo?.userID

                    if !cancel{
                        print("登入成功")
                        self.prepareForStoryBoard()
                    }
                }
            }else{
                print(error!.localizedDescription)
            }
        }
        
    }
    
    //蘋果登入
    func loginWithApple(){
        
        //建立取得使用者資訊請求
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()

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

extension LoginViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    //授權成功
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                return
            }
            // upload credential to api
        }
    
    /* credential 資料包含
     Authorization Code
     Identity Token
     Email (Optional)
     User Identifier
     Name (Family Name / Given Name…) (Optional)
     */
    
    //授權失敗
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Show error
        switch (error) {
        case ASAuthorizationError.canceled:
            break
        case ASAuthorizationError.failed:
            break
        case ASAuthorizationError.invalidResponse:
            break
        case ASAuthorizationError.notHandled:
            break
        case ASAuthorizationError.unknown:
            break
        default:
            break
        }
        
        print("didCompleteWithError: \(error.localizedDescription)")
        }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
        }
    
}
    
    
    



