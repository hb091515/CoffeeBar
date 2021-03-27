//
//  UINavigationController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/24.
//

import UIKit


extension UINavigationController{
    
    open override var childForStatusBarStyle: UIViewController?{
        return topViewController
}
}
