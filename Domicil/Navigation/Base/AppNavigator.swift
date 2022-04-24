//
//  AppNavigator.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import UIKit

enum NavigationContainerKind {
    case search
    case favorites
}

final class AppNavigator {
    var context: CommonContext {
        contextProvider.provideContext()
    }
    
    let searchContainer: NavigationContainerType
    let favoritesContainer: NavigationContainerType
    
    private let contextProvider: ContextProvider
    
    init(
        contextProvider: ContextProvider,
        searchContainer: NavigationContainerType,
        favoritesContainer: NavigationContainerType
    ) {
        self.contextProvider = contextProvider
        self.searchContainer = searchContainer
        self.favoritesContainer = favoritesContainer
    }
}
