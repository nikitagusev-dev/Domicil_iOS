//
//  Navigator.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import UIKit

protocol ViewControllerMappable {
    func asController() -> UIViewController
}

protocol NavigationContainerType {
    var containedItems: [UIViewController] { get }
    
    func push(controller: UIViewController)
    func pop()
    func present(controller: UIViewController)
    func dismiss()
}

final class NavigationContainer: NavigationContainerType, ViewControllerMappable {
    var containedItems: [UIViewController] {
        container.viewControllers
    }
    
    private let container: UINavigationController
    
    init(container: UINavigationController) {
        self.container = container
    }
    
    func push(controller: UIViewController) {
        container.pushViewController(controller, animated: true)
    }
    
    func pop() {
        container.popViewController(animated: true)
    }
    
    func present(controller: UIViewController) {
        container.present(controller, animated: true)
    }
    
    func dismiss() {
        container.dismiss(animated: true)
    }
    
    func asController() -> UIViewController {
        container
    }
}
