//
//  AdSearchListVM.swift
//  Domicil
//
//  Created by Никита Гусев on 24.04.2022.
//

import Foundation
import RxCocoa
import RxSwift

final class AdSearchListViewModel: AdListViewModelType {
    typealias Context = AdAPIContext
        & AdServiceContext
        & LocalStorageServiceContext
        & NetworkServiceContext
        & SearchNavigatorContext
    
    var navigationTitle: Driver<String> {
        .just(NSLocalizedString("AdList.Search.NavigationBar.Title", comment: ""))
    }
    
    var isFiltersButtonHidden: Driver<Bool> {
        .just(false)
    }
    
    let cellViewModels: Driver<[AdListViewCellViewModelType]>
    let isLoading: Driver<Bool>
    let placeholder: Driver<String?>
    
    private let context: Context
    private let disposeBag = DisposeBag()
    
    init(context: Context) {
        self.context = context
        
        cellViewModels = context.adService.ads
            .map { $0.map { AdListViewCellViewModel(context: context, ad: $0) } }
        
        isLoading = context.adService.isLoading
        
        placeholder = context.adService.ads
            .map { !$0.isEmpty }
            .map { isNotEmpty in
                isNotEmpty
                    ? nil
                    : NSLocalizedString("AdList.Search.Placeholder", comment: "")
            }
    }
    
    func bindViewEvents(
        didPullToRefresh: Signal<Void>,
        didScrollToBottom: Signal<Void>,
        filtersButtonTap: Signal<Void>
    ) {
        didPullToRefresh
            .emit(onNext: { [weak self] in
                self?.context.adService.reload()
            })
            .disposed(by: disposeBag)
        
        didScrollToBottom
            .emit(onNext: { [weak self] in
                self?.context.adService.loadNextAds()
            })
            .disposed(by: disposeBag)
        
        filtersButtonTap
            .emit(onNext: { [weak self] in
                self?.context.searchNavigator.navigate(to: .filters)
            })
            .disposed(by: disposeBag)
    }
    
    func bindViewEvents(didSelectCell: Signal<Int>) {
        didSelectCell
            .asDriver(onErrorDriveWith: .empty())
            .withLatestFrom(context.adService.ads) { ($0, $1) }
            .compactMap { index, ads in ads[index] }
            .drive(onNext: { [weak self] ad in
                self?.context.searchNavigator.navigate(to: .details(ad))
            })
            .disposed(by: disposeBag)
    }
}
