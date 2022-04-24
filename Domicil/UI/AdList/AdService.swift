//
//  AdService.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol AdServiceType {
    var ads: Driver<[PreviewAd]> { get }
    var isLoading: Driver<Bool> { get }
    
    func loadAds(with filters: Filters)
    func reload()
    func loadNextAds()
}

final class AdService: AdServiceType {
    var ads: Driver<[PreviewAd]> {
        adsRelay.asDriver()
    }
    
    var isLoading: Driver<Bool> {
        isLoadingRelay.asDriver()
    }
    
    private let adAPI: AdAPIType
    private let adsRelay = BehaviorRelay<[PreviewAd]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private var page = 1
    private var filters: Filters?
    private var isFinished = false
    private var disposeBag = DisposeBag()
    
    init(adAPI: AdAPIType) {
        self.adAPI = adAPI
    }
    
    func loadAds(with filters: Filters) {
        disposeBag = DisposeBag()
        
        adsRelay.accept([])
        isLoadingRelay.accept(true)
        page = 1
        isFinished = false
        self.filters = filters
        
        load(with: filters)
    }
    
    func reload() {
        guard !isLoadingRelay.value else { return }
        
        isLoadingRelay.accept(true)
        page = 1
        isFinished = false
        
        load(with: filters)
    }
    
    func loadNextAds() {
        guard !isFinished, !isLoadingRelay.value else { return }
        
        isLoadingRelay.accept(true)
        
        load(with: filters)
    }
}

private extension AdService {
    func load(with filters: Filters?) {
        guard let filters = filters else { return }

        let adsRequest = makeAdsRequest(using: filters)
        
        adAPI.getAds(using: adsRequest)
            .subscribe(
                onSuccess: { [weak self] ads in
                    self?.handleSuccessLoading(ads: ads)
                },
                onFailure: { [weak self] _ in
                    self?.isLoadingRelay.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func makeAdsRequest(using filters: Filters) -> AdsRequest {
        AdsRequest(
            accommodationKind: filters.accommodation.asParamsAccommodation,
            transactionKind: filters.transaction.asParamsTransaction,
            roomsCount: filters.rooms,
            minTotalArea: filters.minTotalArea,
            maxTotalArea: filters.maxTotalArea,
            minFloor: filters.minFloor,
            maxFloor: filters.maxFloor,
            minPrice: filters.minPrice,
            maxPrice: filters.maxPrice,
            page: page
        )
    }
    
    func handleSuccessLoading(ads: [PreviewAd]) {
        guard !ads.isEmpty else {
            isFinished = true
            return
        }
        adsRelay.accept(adsRelay.value + ads)
        isLoadingRelay.accept(false)
        page += 1
    }
}

private extension Filters.AccommodationKind {
    var asParamsAccommodation: AdParams.AccommodationKind {
        switch self {
            case .apartment:
                return .apartment
            case .room:
                return .room
            case .cottage:
                return .cottage
        }
    }
}

private extension Filters.TransactionKind {
    var asParamsTransaction: AdParams.TransactionKind {
        switch self {
            case .sell:
                return .sell
            case .rent:
                return .rent
        }
    }
}
