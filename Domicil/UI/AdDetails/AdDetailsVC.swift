//
//  AdDetailsVC.swift
//  Domicil
//
//  Created by Никита Гусев on 24.04.2022.
//

import RxSwift
import UIKit

class AdDetailsViewController: UIViewController {
    @IBOutlet private var imagesCollectionView: UICollectionView!
    @IBOutlet private var roomsLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var floorTitleLabel: UILabel!
    @IBOutlet private var floorLabel: UILabel!
    @IBOutlet private var totalAreaTitleLabel: UILabel!
    @IBOutlet private var totalAreaLabel: UILabel!
    @IBOutlet private var descriptionTitleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var recommendationsTitleLabel: UILabel!
    @IBOutlet private var recommendationCollectionView: UICollectionView!
    @IBOutlet private var separatorViews: [UIView]!
    @IBOutlet private var favoritesButton: UIButton!
    @IBOutlet private var openAdButton: UIButton!
    
    var viewModel: AdDetailsViewModelType?
    
    private let style = AdDetailsStyle()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewComponents()
        bindViewModel()
    }
}

// MARK: - Private methods
private extension AdDetailsViewController {
    func configureViewComponents() {
        navigationItem.largeTitleDisplayMode = .never
        
        imagesCollectionView.collectionViewLayout = makeCollectionViewLayout(sideEdgeInset: 0)
        imagesCollectionView.register(
            UINib(nibName: "AdDetailsImageViewCell", bundle: .main),
            forCellWithReuseIdentifier: AdDetailsImageViewCell.identifier
        )
        
        recommendationCollectionView.collectionViewLayout = makeCollectionViewLayout(sideEdgeInset: 15)
        recommendationCollectionView.register(
            UINib(nibName: "AdDetailsRecommendationViewCell", bundle: .main),
            forCellWithReuseIdentifier: AdDetailsRecommendationViewCell.identifier
        )
        
        favoritesButton.tintColor = style.favoriteButtonTintColor
        favoritesButton.setBackgroundImage(style.selectedFavoriteButtonImage, for: .selected)
        favoritesButton.setBackgroundImage(style.notSelectedFavoriteButtonImage, for: .normal)
        
        openAdButton.layer.cornerRadius = style.openAdButtonCornerRadius
        openAdButton.backgroundColor = style.openAdButtonBackgroundColor
        let openAdButtonTitle = NSLocalizedString("AdDetails.OpenAdButton.Title", comment: "")
            .styled(with: style.openAdButtonTitle)
        openAdButton.setAttributedTitle(openAdButtonTitle, for: .normal)
    
        totalAreaTitleLabel.attributedText = NSLocalizedString("AdDetails.TotalAreaHeader", comment: "")
            .styled(with: style.parameter)
        floorTitleLabel.attributedText = NSLocalizedString("AdDetails.FloorHeader", comment: "")
            .styled(with: style.parameter)
        descriptionTitleLabel.attributedText = NSLocalizedString("AdDetails.DescriptionHeader", comment: "")
            .styled(with: style.header)
        recommendationsTitleLabel.attributedText = NSLocalizedString("AdDetails.RecommendationsHeader", comment: "")
            .styled(with: style.header)
        
        separatorViews.forEach { $0.backgroundColor = style.separatorBackgroundColor }
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.roomsCount
            .mapStyle(style.roomsCount)
            .drive(roomsLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.price
            .mapStyle(style.price)
            .drive(priceLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.address
            .mapStyle(style.address)
            .drive(addressLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.totalArea
            .mapStyle(style.parameter)
            .drive(totalAreaLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.floor
            .mapStyle(style.parameter)
            .drive(floorLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.description
            .mapStyle(style.description)
            .drive(descriptionLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.imageItems
            .drive(imagesCollectionView.rx.items(
                cellIdentifier: AdDetailsImageViewCell.identifier,
                cellType: AdDetailsImageViewCell.self
            )) { _, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        viewModel.recommendationItems
            .drive(recommendationCollectionView.rx.items(
                cellIdentifier: AdDetailsRecommendationViewCell.identifier,
                cellType: AdDetailsRecommendationViewCell.self
            )) { _, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        viewModel.isFavoriteButtonSelected
            .drive(favoritesButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        let didSelectRecommendation = recommendationCollectionView.rx.itemSelected
            .asSignal()
            .map { $0.row }
        
        viewModel.bindViewEvents(
            favoriteButtonTap: favoritesButton.rx.tap.asSignal(),
            didSelectRecommendation: didSelectRecommendation,
            openAdButtonTap: openAdButton.rx.tap.asSignal()
        )
    }
    
    func makeCollectionViewLayout(sideEdgeInset: CGFloat) -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: NSCollectionLayoutDimension.fractionalWidth(0.9),
            heightDimension: NSCollectionLayoutDimension.fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: sideEdgeInset,
            bottom: 10,
            trailing: sideEdgeInset
        )
        section.interGroupSpacing = 10
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        
        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
}
