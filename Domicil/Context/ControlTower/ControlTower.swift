//
//  ControlTower.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation

final class ControlTower {
    let context: CommonContext
    
    init(
        searchContainer: NavigationContainerType,
        favoritesContainer: NavigationContainerType
    ) {
        let contextProvider = ContextProvider()
        
        let appNavigator = AppNavigator(
            contextProvider: contextProvider,
            searchContainer: searchContainer,
            favoritesContainer: favoritesContainer
        )
        
        let networkService = NetworkService(
            baseUrl: URL(string: "http://localhost:8080")!,
            responseProcessor: BaseResponseProcessor(),
            session: URLSession.shared
        )
        
        let localStorageService = LocalStorageService()
        
        let adAPI = AdAPI(networkService: networkService)
        
        let adService = AdService(adAPI: adAPI)
        
        context = ControlTowerCommonContext(
            searchNavigator: appNavigator,
            favoritesNavigator: appNavigator,
            networkService: networkService,
            localStorageService: localStorageService,
            adAPI: adAPI,
            adService: adService
        )
        
        contextProvider.set(context: context)
    }
}

private struct BaseResponseProcessor: ResponseProcessorType {
    func extractError(from response: URLResponse) -> Error? {
        return nil
    }
}
