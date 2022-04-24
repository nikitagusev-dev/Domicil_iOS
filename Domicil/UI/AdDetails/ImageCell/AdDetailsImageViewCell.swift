//
//  AdDetailsImageViewCell.swift
//  Domicil
//
//  Created by Никита Гусев on 24.04.2022.
//

import Foundation
import RxSwift
import UIKit

class AdDetailsImageViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    
    static let identifier = "AdDetailsImageViewCell"
    
    var viewModel: AdDetailsImageViewCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

private extension AdDetailsImageViewCell {
    func bindViewModel() {
        disposeBag = DisposeBag()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.image
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
