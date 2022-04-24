//
//  ControlTowerCommonContext.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation

typealias CommonContext = APIContext
    & NavigatorsContext
    & ServicesContext

struct ControlTowerCommonContext: CommonContext {
    let searchNavigator: SearchNavigatorType
    let favoritesNavigator: FavoritesNavigatorType
    let networkService: NetworkServiceType
    let localStorageService: LocalStorageServiceType
    let adAPI: AdAPIType
    let adService: AdServiceType
}
