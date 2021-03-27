//
//  AppDelegate.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/5.
//

import UIKit
import CoreData
import FBSDKLoginKit
import Firebase
import Alamofire
import SwiftyJSON


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let defaults = UserDefaults.standard
        let isPreloaded = defaults.bool(forKey: "isPreloaded")
        if !isPreloaded {
            getDataFromAlamofire(webAddress: "https://cafenomad.tw/api/v1.2/cafes/")
            defaults.set(true, forKey: "isPreloaded")
        }
        
        //Thread.sleep(forTimeInterval: 2.0)
        
        //FirebaseApp.configure()
        
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
    
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
                    DispatchQueue.main.async {
                        
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                        let cofedata = CoffeebarModel(context: appDelegate.persistentContainer.viewContext)
                        cofedata.name = subJson["name"].stringValue
                        cofedata.city = subJson["city"].stringValue
                        cofedata.address = subJson["address"].stringValue
                        cofedata.wifi = subJson["wifi"].doubleValue
                        cofedata.seat = subJson["seat"].doubleValue
                        cofedata.cheap = subJson["cheap"].doubleValue
                        cofedata.tasty = subJson["tasty"].doubleValue
                        cofedata.music = subJson["music"].doubleValue
                        cofedata.latitude = subJson["latitude"].stringValue
                        cofedata.longitude = subJson["longitude"].stringValue
                        cofedata.url = subJson["url"].stringValue
                        cofedata.like = false
                        
                        appDelegate.saveContext()
                    }
//                    let data = CoffeeBar(name: subJson["name"].stringValue, city: subJson["city"].stringValue, address: subJson["address"].stringValue, wifi: subJson["wifi"].doubleValue, seat: subJson["seat"].doubleValue, quiet: subJson["quiet"].doubleValue, cheap: subJson["cheap"].doubleValue, tasty: subJson["tasty"].doubleValue, music: subJson["music"].doubleValue, latitude: subJson["latitude"].stringValue, longitude: subJson["longitude"].stringValue, url: subJson["url"].stringValue, like: false)
//                    self.coffeeBars.append(data)
                }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }

    }
        
    }
    
    
    //fb
//    func application( _ app:UIApplication, open url:URL, options: [UIApplication.OpenURLOptionsKey :Any] = [:] ) -> Bool {
//
//        ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] ) }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoffeeBar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


