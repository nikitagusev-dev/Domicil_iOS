//
//  AdsRequest.swift
//  Domicil
//
//  Created by Никита Гусев on 23.04.2022.
//

import Foundation

struct AdsRequest {
    let accommodationKind: AdParams.AccommodationKind
    let transactionKind: AdParams.TransactionKind
    let roomsCount: [Int]?
    let minTotalArea: Int?
    let maxTotalArea: Int?
    let minFloor: Int?
    let maxFloor: Int?
    let minPrice: Int?
    let maxPrice: Int?
    let page: Int
}

extension AdsRequest: RequestParametersConvertible {
    func toParameters() -> [String : Any] {
        var params: [String: Any] = [
            "accommodationType": accommodationKind.rawValue.uppercased(),
            "transactionType": transactionKind.rawValue.uppercased(),
            "page": page
        ]
        
        if let roomsCount = roomsCount {
            params["roomsCount"] = roomsCount
        }
        if let minTotalArea = minTotalArea {
            params["minTotalArea"] = minTotalArea
        }
        if let maxTotalArea = maxTotalArea {
            params["maxTotalArea"] = maxTotalArea
        }
        if let minFloor = minFloor {
            params["minFloor"] = minFloor
        }
        if let maxFloor = maxFloor {
            params["maxFloor"] = maxFloor
        }
        if let minPrice = minPrice {
            params["minPrice"] = minPrice
        }
        if let maxPrice = maxPrice {
            params["maxPrice"] = maxPrice
        }
        
        return params
    }
}
