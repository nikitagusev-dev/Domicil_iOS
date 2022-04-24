//
//  AdFavoritesListVM.swift
//  Domicil
//
//  Created by Никита Гусев on 24.04.2022.
//

import Foundation
import RxCocoa
import RxSwift

final class AdFavoritesListViewModel: AdListViewModelType {
    typealias Context = LocalStorageServiceContext
        & NetworkServiceContext
        & SearchNavigatorContext
    
    var isLoading: Driver<Bool> {
        .just(false)
    }
    
    var navigationTitle: Driver<String> {
        .just(NSLocalizedString("AdList.Favorites.NavigationBar.Title", comment: ""))
    }
    
    var isFiltersButtonHidden: Driver<Bool> {
        .just(true)
    }
    
    let cellViewModels: Driver<[AdListViewCellViewModelType]>
    let placeholder: Driver<String?>
    
    private let context: Context
    private let disposeBag = DisposeBag()
    
    init(context: Context) {
        self.context = context
        
        cellViewModels = context.localStorageService.favoriteAds
            .map { $0.map { AdListViewCellViewModel(context: context, ad: $0) } }
        
        placeholder = context.localStorageService.favoriteAds
            .map { !$0.isEmpty }
            .map { isNotEmpty in
                isNotEmpty
                    ? nil
                    : NSLocalizedString("AdList.Favorites.Placeholder", comment: "")
            }
    }
    
    func bindViewEvents(didSelectCell: Signal<Int>) {
        didSelectCell
            .asDriver(onErrorDriveWith: .empty())
            .withLatestFrom(context.localStorageService.favoriteAds) { ($0, $1) }
            .compactMap { index, ads in ads[index] }
            .drive(onNext: { [weak self] ad in
                self?.context.searchNavigator.navigate(to: .details(ad))
            })
            .disposed(by: disposeBag)
    }
}
