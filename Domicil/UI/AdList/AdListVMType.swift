//
//  AdListVM.swift
//  Domicil
//
//  Created by Никита Гусев on 20.04.2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol AdListViewModelType {
    var cellViewModels: Driver<[AdListViewCellViewModelType]> { get }
    var isLoading: Driver<Bool> { get }
    var placeholder: Driver<String?> { get }
    var navigationTitle: Driver<String> { get }
    var isFiltersButtonHidden: Driver<Bool> { get }
    
    func bindViewEvents(
        didPullToRefresh: Signal<Void>,
        didScrollToBottom: Signal<Void>,
        filtersButtonTap: Signal<Void>
    )
    func bindViewEvents(didSelectCell: Signal<Int>)
}

extension AdListViewModelType {
    func bindViewEvents(
        didPullToRefresh: Signal<Void>,
        didScrollToBottom: Signal<Void>,
        filtersButtonTap: Signal<Void>
    ) {}
}
