//
//  AdDetailsVM.swift
//  Domicil
//
//  Created by Никита Гусев on 24.04.2022.
//

import Foundation
import RxCocoa
import RxSwift
import class UIKit.UIApplication

protocol AdDetailsViewModelType {
    var imageItems: Driver<[AdDetailsImageViewCellViewModelType]> { get }
    var price: Driver<String> { get }
    var roomsCount: Driver<String> { get }
    var totalArea: Driver<String> { get }
    var floor: Driver<String> { get }
    var address: Driver<String> { get }
    var description: Driver<String> { get }
    var isFavoriteButtonSelected: Driver<Bool> { get }
    var recommendationItems: Driver<[AdDetailsRecommendationViewCellViewModelType]> { get }
    
    func bindViewEvents(
        favoriteButtonTap: Signal<Void>,
        didSelectRecommendation: Signal<Int>,
        openAdButtonTap: Signal<Void>
    )
}

final class AdDetailsViewModel: AdDetailsViewModelType {
    typealias Context = AdAPIContext
        & FavoritesNavigatorContext
        & LocalStorageServiceContext
        & NetworkServiceContext
        & SearchNavigatorContext
    
    let imageItems: Driver<[AdDetailsImageViewCellViewModelType]>
    let price: Driver<String>
    let roomsCount: Driver<String>
    let totalArea: Driver<String>
    let floor: Driver<String>
    let address: Driver<String>
    let description: Driver<String>
    let isFavoriteButtonSelected: Driver<Bool>
    let recommendationItems: Driver<[AdDetailsRecommendationViewCellViewModelType]>
    
    private let context: Context
    private let previewAd: PreviewAd
    private let containerKind: NavigationContainerKind
    private let recommendations: Driver<[PreviewAd]>
    private var disposeBag = DisposeBag()
    
    init(
        context: Context,
        ad: PreviewAd,
        containerKind: NavigationContainerKind
    ) {
        self.context = context
        self.containerKind = containerKind
        previewAd = ad
        
        price = .just(
            Self.separated(price: String(ad.price))
                + " "
                + NSLocalizedString("Filters.TextField.Placeholder.Ruble", comment: "")
        )
        roomsCount = .just(String(ad.roomsCount) + "-ком.,")
        totalArea = .just(String(ad.totalArea) + "м²")
        
        if let numberOfFloors = ad.numberOfFloors {
            floor = .just(String(ad.floor) + "/" + String(numberOfFloors) + " эт.")
        } else {
            floor = .just(String(ad.floor) + " этажн.")
        }
        
        var fullAddress = ""
        if let address = ad.address {
            fullAddress.append(address.street + ", д." + String(address.houseNumber))
            fullAddress.append(", ")
        }
        fullAddress.append(ad.partOfTown)
        address = .just(fullAddress)
        
        isFavoriteButtonSelected = context.localStorageService.favoriteAds
            .map { $0.contains(where: { $0.sourceUrl == ad.sourceUrl }) }
        
        let adRecommendationsRequest = Self.makeAdRecommendationsRequest(from: ad)
        recommendations = context.adAPI.getRecommendations(using: adRecommendationsRequest)
            .asDriver(onErrorJustReturn: [])
            .startWith([])
        
        recommendationItems = recommendations
            .map { $0.map { AdDetailsRecommendationViewCellViewModel(context: context, ad: $0) } }
        
        let adDetailsRequest = Self.makeAdDetailsRequest(from: previewAd)
        let detailedAd = context.adAPI.getDetails(using: adDetailsRequest)
            .asDriver(onErrorDriveWith: .empty())
        
        imageItems = detailedAd
            .map { $0.imageUrls }
            .map { $0.map { AdDetailsImageViewCellViewModel(context: context, imageUrl: $0) } }
        
        description = detailedAd
            .map { $0.description }
            .startWith("")
    }
    
    func bindViewEvents(
        favoriteButtonTap: Signal<Void>,
        didSelectRecommendation: Signal<Int>,
        openAdButtonTap: Signal<Void>
    ) {
        disposeBag = DisposeBag()
        
        favoriteButtonTap
            .emit(onNext: { [weak self] in
                self?.toggleAdStoring()
            })
            .disposed(by: disposeBag)
        
        didSelectRecommendation
            .asDriver(onErrorDriveWith: .empty())
            .withLatestFrom(recommendations) { ($0, $1) }
            .compactMap { index, recommendations in recommendations[index] }
            .drive(onNext: { [weak self] ad in
                guard let self = self else { return }
                
                switch self.containerKind {
                    case .search:
                        self.context.searchNavigator.navigate(to: .details(ad))
                    case .favorites:
                        self.context.favoritesNavigator.navigate(to: .details(ad))
                }
            })
            .disposed(by: disposeBag)
        
        openAdButtonTap
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                
                UIApplication.shared.open(self.previewAd.sourceUrl)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private methods
private extension AdDetailsViewModel {
    static func separated(price: String, by separator: String = " ", stride: Int = 3) -> String {
        let reversedPrice = String(price.reversed())
        
        let separatedReversedPrice = reversedPrice
            .enumerated()
            .map { $0.isMultiple(of: stride) && ($0 != 0) ? "\(separator)\($1)" : String($1) }
            .joined()
        
        return String(separatedReversedPrice.reversed())
    }
    
    static func makeAdDetailsRequest(from ad: PreviewAd) -> AdDetailsRequest {
        AdDetailsRequest(
            accomodationKind: ad.accommodationKind.asParamsAccommodation(),
            transactionKind: ad.transactionKind.asParamsTransaction(),
            sourceKind: ad.sourceKind.asParamsSource(),
            roomsCount: ad.roomsCount,
            street: ad.address?.street,
            houseNumber: ad.address?.houseNumber,
            partOfTown: ad.partOfTown,
            totalArea: ad.totalArea,
            floor: ad.floor,
            numberOfFloors: ad.numberOfFloors,
            price: ad.price,
            imageUrl: ad.imageUrl,
            sourceUrl: ad.sourceUrl
        )
    }
    
    static func makeAdRecommendationsRequest(from ad: PreviewAd) -> AdRecommendationsRequest {
        AdRecommendationsRequest(
            accomodationKind: ad.accommodationKind.asParamsAccommodation(),
            transactionKind: ad.transactionKind.asParamsTransaction(),
            sourceKind: ad.sourceKind.asParamsSource(),
            roomsCount: ad.roomsCount,
            street: ad.address?.street,
            houseNumber: ad.address?.houseNumber,
            partOfTown: ad.partOfTown,
            totalArea: ad.totalArea,
            floor: ad.floor,
            numberOfFloors: ad.numberOfFloors,
            price: ad.price,
            imageUrl: ad.imageUrl,
            sourceUrl: ad.sourceUrl
        )
    }
    
    func toggleAdStoring() {
        context.localStorageService.toggleStoring(of: previewAd)
    }
}

private extension PreviewAd.AccommodationKind {
    func asParamsAccommodation() -> AdParams.AccommodationKind {
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

private extension PreviewAd.TransactionKind {
    func asParamsTransaction() -> AdParams.TransactionKind {
        switch self {
            case .sell:
                return .sell
            case .rent:
                return .rent
        }
    }
}

private extension PreviewAd.SourceKind {
    func asParamsSource() -> AdParams.SourceKind {
        switch self {
            case .n1:
                return .n1
            case .cian:
                return .cian
        }
    }
}
