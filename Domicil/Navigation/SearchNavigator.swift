//
//  MainNavigator.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import UIKit

enum SearchNavigationTarget {
    case filters
    case searchList
    case details(PreviewAd)
    case back
}

protocol SearchNavigatorType {
    func navigate(to target: SearchNavigationTarget)
}

extension AppNavigator: SearchNavigatorType {
    func navigate(to target: SearchNavigationTarget) {
        switch target {
            case .filters:
                let controller = makeFilters()
                searchContainer.push(controller: controller)
            case .searchList:
                let controller = makeSearchList()
                searchContainer.push(controller: controller)
            case let .details(ad):
                let controller = makeDetails(ad: ad, containerKind: .search)
                searchContainer.push(controller: controller)
            case .back:
                searchContainer.pop()
        }
    }
}

// MARK: - Factory methods
extension AppNavigator {
    func makeFilters() -> UIViewController {
        let storyboard = UIStoryboard(name: "Filters", bundle: .main)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "filters"
        ) as! FiltersViewController
        let viewModel = FiltersViewModel(context: context)
        controller.viewModel = viewModel
        return controller
    }
    
    func makeSearchList() -> UIViewController {
        let storyboard = UIStoryboard(name: "AdList", bundle: .main)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "adList"
        ) as! AdListViewController
        let viewModel = AdSearchListViewModel(context: context)
        controller.viewModel = viewModel
        return controller
    }
    
    func makeDetails(ad: PreviewAd, containerKind: NavigationContainerKind) -> UIViewController {
        let storyboard = UIStoryboard(name: "AdDetails", bundle: .main)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "adDetails"
        ) as! AdDetailsViewController
        let viewModel = AdDetailsViewModel(
            context: context,
            ad: ad,
            containerKind: containerKind
        )
        controller.viewModel = viewModel
        return controller
    }
}
