//
//  RequestParametersConvertible.swift
//  Domicil
//
//  Created by Никита Гусев on 23.04.2022.
//

import Foundation

protocol RequestParametersConvertible {
    func toParameters() -> [String: Any]
}
