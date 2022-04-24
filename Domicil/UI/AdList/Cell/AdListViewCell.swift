//
//  AdListViewCell.swift
//  Domicil
//
//  Created by Никита Гусев on 20.04.2022.
//

import RxSwift
import UIKit

class AdListViewCell: UITableViewCell {
    @IBOutlet private var infoContentView: UIView!
    @IBOutlet private var previewImageView: UIImageView!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var roomsCountLabel: UILabel!
    @IBOutlet private var totalAreaLabel: UILabel!
    @IBOutlet private var floorLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    
    static let identifier = "AdListViewCell"
    
    var viewModel: AdListViewCellViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViewComponents()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        viewModel?.prepareForReuse()
    }
    
    private let style = AdListViewCellStyle()
    private var disposeBag = DisposeBag()
}

private extension AdListViewCell {
    func configureViewComponents() {
        selectionStyle = .none
        
        favoriteButton.tintColor = style.favoriteButtonTintColor
        favoriteButton.setBackgroundImage(style.selectedFavoriteButtonImage, for: .selected)
        favoriteButton.setBackgroundImage(style.notSelectedFavoriteButtonImage, for: .normal)
        
        infoContentView.layer.shadowRadius = style.cellShadowRadius
        infoContentView.layer.shadowColor = style.cellShadowColor.cgColor
        infoContentView.layer.shadowOpacity = style.cellShadowOpacity
        infoContentView.layer.shadowOffset = style.cellShadowOffset
    }
    
    func bindViewModel() {
        disposeBag = DisposeBag()
        
        guard let viewModel = viewModel else { return }
        
        viewModel.previewImage
            .drive(previewImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.price
            .mapStyle(style.price)
            .drive(priceLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.roomsCount
            .mapStyle(style.roomsCount)
            .drive(roomsCountLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.totalArea
            .mapStyle(style.totalArea)
            .drive(totalAreaLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.floor
            .mapStyle(style.floor)
            .drive(floorLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.address
            .mapStyle(style.address)
            .drive(addressLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.isFavoriteButtonSelected
            .drive(favoriteButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        viewModel.bindViewEvents(favoriteButtonTap: favoriteButton.rx.tap.asSignal())
    }
}
