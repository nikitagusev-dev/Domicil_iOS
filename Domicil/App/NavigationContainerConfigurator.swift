//
//  ContainersConfigurator.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import UIKit

typealias NavigationContainerConfigurable = NavigationContainerType & ViewControllerMappable

struct NavigationContainerConfigurator {
    private let style = BarStyle()
    
    func makeContainer(for kind: NavigationContainerKind) -> NavigationContainerConfigurable {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = style.barTintColor
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.view.backgroundColor = style.backgroundColor
        
        switch kind {
            case .search:
                navigationController.tabBarItem.title = NSLocalizedString("TabBarItem.Search.Title", comment: "")
                navigationController.tabBarItem.image = style.searchTabImage
            case .favorites:
                navigationController.tabBarItem.title = NSLocalizedString("TabBarItem.Favorites.Title", comment: "")
                navigationController.tabBarItem.image = style.favoritesTabImage
        }
        
        return NavigationContainer(container: navigationController)
    }
}
