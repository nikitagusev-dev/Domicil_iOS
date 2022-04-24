//
//  ServicesContext.swift
//  Domicil
//
//  Created by Никита Гусев on 20.04.2022.
//

import Foundation

typealias ServicesContext = AdServiceContext
    & LocalStorageServiceContext
    & NetworkServiceContext

protocol AdServiceContext {
    var adService: AdServiceType { get }
}

protocol LocalStorageServiceContext {
    var localStorageService: LocalStorageServiceType { get }
}

protocol NetworkServiceContext {
    var networkService: NetworkServiceType { get }
}
