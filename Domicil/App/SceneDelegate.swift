//
//  SceneDelegate.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private var controlTower: ControlTower?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: scene)
        self.window = window
       
        let tabBarConfigurator = TabBarConfigurator(window: window)
        let containerConfigurator = NavigationContainerConfigurator()

        let searchContainer = containerConfigurator.makeContainer(for: .search)
        let favoritesContainer = containerConfigurator.makeContainer(for: .favorites)

        tabBarConfigurator.set(controllers: [searchContainer, favoritesContainer])

        let controlTower = ControlTower(
            searchContainer: searchContainer,
            favoritesContainer: favoritesContainer
        )
        self.controlTower = controlTower

        let launcher = Launcher(context: controlTower.context)
        launcher.launch()
    }
}
