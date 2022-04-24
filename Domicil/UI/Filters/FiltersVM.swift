//
//  FiltersVM.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import RxCocoa
import RxSwift

struct Filters {
    enum TransactionKind: Int, CaseIterable {
        case sell = 0
        case rent
    }

    enum AccommodationKind: Int, CaseIterable {
        case apartment = 0
        case room
        case cottage
    }
    
    let transaction: TransactionKind
    let accommodation: AccommodationKind
    let rooms: [Int]?
    let minTotalArea: Int?
    let maxTotalArea: Int?
    let minFloor: Int?
    let maxFloor: Int?
    let minPrice: Int?
    let maxPrice: Int?
}

protocol FiltersViewModelType {
    var transactionKinds: [Filters.TransactionKind] { get }
    var accommodationKinds: [Filters.AccommodationKind] { get }
    var selectedRooms: Driver<[Int]> { get }
    
    func bindViewEvents(
        selectedTransaction: Driver<Int>,
        selectedAccommodation: Driver<Int>,
        selectedRoom: Signal<Int>,
        minTotalArea: Driver<String>,
        maxTotalArea: Driver<String>,
        minFloor: Driver<String>,
        maxFloor: Driver<String>,
        minPrice: Driver<String>,
        maxPrice: Driver<String>,
        confirmButtonTap: Signal<Void>
    )
}

final class FiltersViewModel: FiltersViewModelType {
    typealias Context = AdServiceContext & SearchNavigatorContext
    
    var transactionKinds: [Filters.TransactionKind] {
        Filters.TransactionKind.allCases
    }
    
    var accommodationKinds: [Filters.AccommodationKind] {
        Filters.AccommodationKind.allCases
    }
    
    var selectedRooms: Driver<[Int]> {
        selectedRoomsRelay.asDriver()
    }
    
    private let context: Context
    private let selectedTransactionRelay = BehaviorRelay<Filters.TransactionKind>(value: .sell)
    private let selectedAccommodationRelay = BehaviorRelay<Filters.AccommodationKind>(value: .apartment)
    private let selectedRoomsRelay = BehaviorRelay<[Int]>(value: [])
    private let minTotalAreaRelay = BehaviorRelay<String>(value: "")
    private let maxTotalAreaRelay = BehaviorRelay<String>(value: "")
    private let minFloorRelay = BehaviorRelay<String>(value: "")
    private let maxFloorRelay = BehaviorRelay<String>(value: "")
    private let minPriceRelay = BehaviorRelay<String>(value: "")
    private let maxPriceRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    init(context: Context) {
        self.context = context
    }
    
    func bindViewEvents(
        selectedTransaction: Driver<Int>,
        selectedAccommodation: Driver<Int>,
        selectedRoom: Signal<Int>,
        minTotalArea: Driver<String>,
        maxTotalArea: Driver<String>,
        minFloor: Driver<String>,
        maxFloor: Driver<String>,
        minPrice: Driver<String>,
        maxPrice: Driver<String>,
        confirmButtonTap: Signal<Void>
    ) {
        selectedTransaction
            .compactMap(Filters.TransactionKind.init)
            .drive(selectedTransactionRelay)
            .disposed(by: disposeBag)
        
        selectedAccommodation
            .compactMap(Filters.AccommodationKind.init)
            .drive(selectedAccommodationRelay)
            .disposed(by: disposeBag)
        
        selectedRoom
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(selectedRooms) { ($0, $1) }
            .drive(onNext: { [weak self] in
                self?.handleRoomSelection(newSelectedRoom: $0, currentSelectedRooms: $1)
            })
            .disposed(by: disposeBag)
            
        minTotalArea
            .drive(minTotalAreaRelay)
            .disposed(by: disposeBag)
        
        maxTotalArea
            .drive(maxTotalAreaRelay)
            .disposed(by: disposeBag)
        
        minFloor
            .drive(minFloorRelay)
            .disposed(by: disposeBag)
        
        maxFloor
            .drive(maxFloorRelay)
            .disposed(by: disposeBag)
        
        minPrice
            .drive(minPriceRelay)
            .disposed(by: disposeBag)
        
        maxPrice
            .drive(maxPriceRelay)
            .disposed(by: disposeBag)
        
        let selectedFilters = Driver.combineLatest(
            selectedTransactionRelay.asDriver(),
            selectedAccommodationRelay.asDriver(),
            selectedRooms
        )
        
        let inputFilters = Driver.combineLatest(
            minTotalAreaRelay.asDriver().map(Int.init),
            maxTotalAreaRelay.asDriver().map(Int.init),
            minFloorRelay.asDriver().map(Int.init),
            maxFloorRelay.asDriver().map(Int.init),
            minPriceRelay.asDriver().map(Int.init),
            maxPriceRelay.asDriver().map(Int.init)
        )
        
        let allFilters = Driver.combineLatest(
            selectedFilters,
            inputFilters
        )
        .map { ($0.0, $0.1, $0.2, $1.0, $1.1, $1.2, $1.3, $1.4, $1.5) }
        .map(Filters.init)
        .flatMap { [weak self] filters -> Driver<Filters> in
            guard let self = self else {
                return .empty()
            }
            return .just(self.erasedFilters(from: filters))
        }
        
        confirmButtonTap
            .withLatestFrom(allFilters)
            .emit(onNext: { [weak self] filters in
                self?.handleConfirmButtonTap(using: filters)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private methods
private extension FiltersViewModel {
    func handleRoomSelection(newSelectedRoom: Int, currentSelectedRooms: [Int]) {
        if currentSelectedRooms.contains(newSelectedRoom) {
            selectedRoomsRelay.accept(currentSelectedRooms.filter { $0 != newSelectedRoom })
        } else {
            selectedRoomsRelay.accept((currentSelectedRooms + [newSelectedRoom]).sorted())
        }
    }
    
    func erasedFilters(from filters: Filters) -> Filters {
        Filters(
            transaction: filters.transaction,
            accommodation: filters.accommodation,
            rooms: filters.rooms == [] ? nil : filters.rooms,
            minTotalArea: filters.minTotalArea == 0 ? nil : filters.minTotalArea,
            maxTotalArea: filters.maxTotalArea == 0 ? nil : filters.maxTotalArea,
            minFloor: filters.minFloor == 0 ? nil : filters.minFloor,
            maxFloor: filters.maxFloor == 0 ? nil : filters.maxFloor,
            minPrice: filters.minPrice == 0 ? nil : filters.minPrice,
            maxPrice: filters.maxPrice == 0 ? nil : filters.maxPrice
        )
    }
    
    func handleConfirmButtonTap(using filters: Filters) {
        context.adService.loadAds(with: filters)
        context.searchNavigator.navigate(to: .back)
    }
}
