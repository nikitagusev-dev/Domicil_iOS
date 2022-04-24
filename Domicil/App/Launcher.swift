//
//  Launcher.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation

final class Launcher {
    typealias Context = FavoritesNavigatorContext & SearchNavigatorContext
    
    private let context: Context
    
    init(context: Context) {
        self.context = context
    }
    
    func launch() {
        context.searchNavigator.navigate(to: .searchList)
        context.favoritesNavigator.navigate(to: .favoritesList)
    }
}
