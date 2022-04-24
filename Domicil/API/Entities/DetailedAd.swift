//
//  DetailedAd.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation

struct DetailedAd: Decodable {
    struct AdAddress: Decodable {
        let street: String
        let houseNumber: String
    }
    
    let roomsCount: Int
    let address: AdAddress?
    let partOfTown: String
    let totalArea: Int
    let floor: Int
    let numberOfFloors: Int?
    let price: Int
    let imageUrls: [URL]
    let sourceUrl: URL
    let description: String
}
