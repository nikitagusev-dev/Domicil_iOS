//
//  AdAPI.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation
import RxSwift

protocol AdAPIType {
    func getAds(using request: AdsRequest) -> Single<[PreviewAd]>
    func getDetails(using request: AdDetailsRequest) -> Single<DetailedAd>
    func getRecommendations(using request: AdRecommendationsRequest) -> Single<[PreviewAd]>
}

final class AdAPI: AdAPIType {
    private let networkService: NetworkServiceType
    
    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }
    
    func getAds(using request: AdsRequest) -> Single<[PreviewAd]> {
        networkService.fetchModel(
            path: "/api/ads",
            method: .get,
            params: request.toParameters()
        )
    }
    
    func getDetails(using request: AdDetailsRequest) -> Single<DetailedAd> {
        networkService.fetchModel(
            path: "/api/details",
            method: .get,
            params: request.toParameters()
        )
    }
    
    func getRecommendations(using request: AdRecommendationsRequest) -> Single<[PreviewAd]> {
        networkService.fetchModel(
            path: "/api/rec",
            method: .get,
            params: request.toParameters()
        )
    }
}
