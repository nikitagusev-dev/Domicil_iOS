//
//  PreviewAd.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation

struct PreviewAd {
    enum TransactionKind: String, Decodable {
        case sell = "SELL"
        case rent = "RENT"
    }

    enum AccommodationKind: String, Decodable {
        case apartment = "APARTMENT"
        case room = "ROOM"
        case cottage = "COTTAGE"
    }
    
    enum SourceKind: String, Decodable {
        case n1 = "N1"
        case cian = "CIAN"
    }
    
    struct AdAddress: Decodable {
        let street: String
        let houseNumber: String
    }
    
    let transactionKind: TransactionKind
    let accommodationKind: AccommodationKind
    let sourceKind: SourceKind
    let roomsCount: Int
    let address: AdAddress?
    let partOfTown: String
    let totalArea: Int
    let floor: Int
    let numberOfFloors: Int?
    let price: Int
    let imageUrl: URL?
    let sourceUrl: URL
}

extension PreviewAd: Decodable {
    enum CodingKeys: String, CodingKey {
        case transactionKind = "transactionType"
        case accomodationKind = "accommodationType"
        case sourceKind = "sourceType"
        case roomsCount
        case address
        case partOfTown
        case totalArea
        case floor
        case numberOfFloors
        case price
        case imageUrl
        case sourceUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        transactionKind = try container.decode(TransactionKind.self, forKey: .transactionKind)
        accommodationKind = try container.decode(AccommodationKind.self, forKey: .accomodationKind)
        sourceKind = try container.decode(SourceKind.self, forKey: .sourceKind)
        roomsCount = try container.decode(Int.self, forKey: .roomsCount)
        address = try container.decode(AdAddress?.self, forKey: .address)
        partOfTown = try container.decode(String.self, forKey: .partOfTown)
        totalArea = try container.decode(Int.self, forKey: .totalArea)
        floor = try container.decode(Int.self, forKey: .floor)
        numberOfFloors = try container.decode(Int?.self, forKey: .numberOfFloors)
        price = try container.decode(Int.self, forKey: .price)
        imageUrl = try container.decode(URL?.self, forKey: .imageUrl)
        sourceUrl = try container.decode(URL.self, forKey: .sourceUrl)
    }
}
