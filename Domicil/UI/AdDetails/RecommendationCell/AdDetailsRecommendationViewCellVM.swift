//
//  AdDetailsRecommendationViewCellVM.swift
//  Domicil
//
//  Created by Никита Гусев on 20.04.2022.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol AdDetailsRecommendationViewCellViewModelType {
    var previewImage: Driver<UIImage> { get }
    var price: Driver<String> { get }
    var roomsCount: Driver<String> { get }
    var totalArea: Driver<String> { get }
    var floor: Driver<String> { get }
    var address: Driver<String> { get }
    var isFavoriteButtonSelected: Driver<Bool> { get }
    
    func bindViewEvents(favoriteButtonTap: Signal<Void>)
    func prepareForReuse()
}

final class AdDetailsRecommendationViewCellViewModel: AdDetailsRecommendationViewCellViewModelType {
    typealias Context = LocalStorageServiceContext & NetworkServiceContext
    
    let previewImage: Driver<UIImage>
    let price: Driver<String>
    let roomsCount: Driver<String>
    let totalArea: Driver<String>
    let floor: Driver<String>
    let address: Driver<String>
    let isFavoriteButtonSelected: Driver<Bool>
    
    private let context: Context
    private let ad: PreviewAd
    private var disposeBag = DisposeBag()
    
    init(
        context: Context,
        ad: PreviewAd
    ) {
        self.context = context
        self.ad = ad
        
        price = .just(
            Self.separated(price: String(ad.price))
                + " "
                + NSLocalizedString("Filters.TextField.Placeholder.Ruble", comment: "")
        )
        roomsCount = .just(String(ad.roomsCount) + "-ком.")
        totalArea = .just(String(ad.totalArea) + "м²")
        
        if let numberOfFloors = ad.numberOfFloors {
            floor = .just(String(ad.floor) + "/" + String(numberOfFloors) + " эт.")
        } else {
            floor = .just(String(ad.floor) + " этажей")
        }
        
        var fullAddress = ""
        if let address = ad.address {
            fullAddress.append(address.street + ", д." + String(address.houseNumber))
            fullAddress.append(", ")
        }
        fullAddress.append(ad.partOfTown)
        address = .just(fullAddress)
        
        if let imageUrl = ad.imageUrl {
            previewImage = context.networkService.fetchData(from: imageUrl)
                .asDriver(onErrorDriveWith: .empty())
                .compactMap(UIImage.init)
                .startWith(UIImage(named: "preview_placeholder")!)
        } else {
            previewImage = .just(UIImage(named: "preview_placeholder")!)
        }
        
        isFavoriteButtonSelected = context.localStorageService.favoriteAds
            .map { $0.contains(where: { $0.sourceUrl == ad.sourceUrl }) }
    }
    
    func bindViewEvents(favoriteButtonTap: Signal<Void>) {
        disposeBag = DisposeBag()
        
        favoriteButtonTap
            .emit(onNext: { [weak self] in
                self?.toggleAdStoring()
            })
            .disposed(by: disposeBag)
    }
    
    func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

// MARK: - Private methods
private extension AdDetailsRecommendationViewCellViewModel {
    static func separated(price: String, by separator: String = " ", stride: Int = 3) -> String {
        let reversedPrice = String(price.reversed())
        
        let separatedReversedPrice = reversedPrice
            .enumerated()
            .map { $0.isMultiple(of: stride) && ($0 != 0) ? "\(separator)\($1)" : String($1) }
            .joined()
        
        return String(separatedReversedPrice.reversed())
    }
    
    func toggleAdStoring() {
        context.localStorageService.toggleStoring(of: ad)
    }
}
