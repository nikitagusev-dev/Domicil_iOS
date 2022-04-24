//
//  AdParams.swift
//  Domicil
//
//  Created by Никита Гусев on 23.04.2022.
//

import Foundation

enum AdParams {
    enum AccommodationKind: String {
        case apartment
        case room
        case cottage
    }
    
    enum TransactionKind: String {
        case sell
        case rent
    }
    
    enum SourceKind: String {
        case n1
        case cian
    }
}
