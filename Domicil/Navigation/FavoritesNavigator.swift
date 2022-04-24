//
//  FavoritesNavigator.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import UIKit

enum FavoritesNavigationTarget {
    case favoritesList
    case details(PreviewAd)
}

protocol FavoritesNavigatorType {
    func navigate(to target: FavoritesNavigationTarget)
}

extension AppNavigator: FavoritesNavigatorType {
    func navigate(to target: FavoritesNavigationTarget) {
        switch target {
            case .favoritesList:
                let controller = makeFavoritesList()
                favoritesContainer.push(controller: controller)
            case let .details(ad):
                let controller = makeDetails(ad: ad, containerKind: .favorites)
                favoritesContainer.push(controller: controller)
        }
    }
}

extension AppNavigator {
    func makeFavoritesList() -> UIViewController {
        let storyboard = UIStoryboard(name: "AdList", bundle: .main)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "adList"
        ) as! AdListViewController
        let viewModel = AdFavoritesListViewModel(context: context)
        controller.viewModel = viewModel
        return controller
    }
}
