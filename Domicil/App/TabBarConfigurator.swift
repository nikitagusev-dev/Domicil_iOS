//
//  TabBarConfigurator.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import UIKit

struct TabBarConfigurator {
    private let tabBarController = UITabBarController()
    private let style = BarStyle()
    
    init(window: UIWindow) {
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = style.barTintColor
    }
    
    func set(controllers: [ViewControllerMappable]) {
        tabBarController.viewControllers = controllers.map { $0.asController() }
    }
}
