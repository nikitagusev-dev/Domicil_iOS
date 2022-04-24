//
//  ApiContext.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation

typealias APIContext = AdAPIContext

protocol AdAPIContext {
    var adAPI: AdAPIType { get }
}
