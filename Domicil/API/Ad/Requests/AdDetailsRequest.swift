//
//  AdDetailsRequest.swift
//  Domicil
//
//  Created by Никита Гусев on 23.04.2022.
//

import Foundation

struct AdDetailsRequest {
    let accomodationKind: AdParams.AccommodationKind
    let transactionKind: AdParams.TransactionKind
    let sourceKind: AdParams.SourceKind
    let roomsCount: Int
    let street: String?
    let houseNumber: String?
    let partOfTown: String
    let totalArea: Int
    let floor: Int
    let numberOfFloors: Int?
    let price: Int
    let imageUrl: URL?
    let sourceUrl: URL
}

extension AdDetailsRequest: RequestParametersConvertible {
    func toParameters() -> [String : Any] {
        var params: [String: Any] = [
            "accommodationType": accomodationKind.rawValue.uppercased(),
            "transactionType": transactionKind.rawValue.uppercased(),
            "sourceType": sourceKind.rawValue.uppercased(),
            "roomsCount": roomsCount,
            "partOfTown": partOfTown,
            "totalArea": totalArea,
            "floor": floor,
            "price": price,
            "sourceUrl": sourceUrl
        ]
        
        if let street = street {
            params["street"] = street
        }
        if let houseNumber = houseNumber {
            params["houseNumber"] = houseNumber
        }
        if let numberOfFloors = numberOfFloors {
            params["numberOfFloors"] = numberOfFloors
        }
        if let imageUrl = imageUrl {
            params["imageUrl"] = imageUrl
        }
        
        return params
    }
}
