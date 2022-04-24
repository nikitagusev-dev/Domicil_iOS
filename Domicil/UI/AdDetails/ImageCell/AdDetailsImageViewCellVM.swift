//
//  AdDetailsImageViewCellVM.swift
//  Domicil
//
//  Created by Никита Гусев on 24.04.2022.
//

import Foundation
import RxCocoa
import UIKit

protocol AdDetailsImageViewCellViewModelType {
    var image: Driver<UIImage?> { get }
}

final class AdDetailsImageViewCellViewModel: AdDetailsImageViewCellViewModelType {
    typealias Context = NetworkServiceContext
    
    let image: Driver<UIImage?>
    
    private let context: Context
    
    init(context: Context, imageUrl: URL) {
        self.context = context
        
        image = context.networkService.fetchData(from: imageUrl)
            .map(UIImage.init)
            .asDriver(onErrorJustReturn: UIImage(named: "preview_placeholder"))
            .startWith(UIImage(named: "preview_placeholder"))
    }
}
