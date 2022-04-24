//
//  NavigatorsContext.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation

typealias NavigatorsContext = FavoritesNavigatorContext
    & SearchNavigatorContext

protocol SearchNavigatorContext {
    var searchNavigator: SearchNavigatorType { get }
}

protocol FavoritesNavigatorContext {
    var favoritesNavigator: FavoritesNavigatorType { get }
}
