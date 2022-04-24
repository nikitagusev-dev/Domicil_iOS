//
//  FiltersVC.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import RxCocoa
import RxSwift
import UIKit

class FiltersViewController: UIViewController {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var transactionLabel: UILabel!
    @IBOutlet private weak var transactionSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var accommodationLabel: UILabel!
    @IBOutlet private weak var accommodationSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var roomsLabel: UILabel!
    @IBOutlet private weak var oneRoomButton: UIButton!
    @IBOutlet private weak var twoRoomsButton: UIButton!
    @IBOutlet private weak var threeRoomsButton: UIButton!
    @IBOutlet private weak var fourRoomsButton: UIButton!
    @IBOutlet private weak var fiveRoomsButton: UIButton!
    @IBOutlet private weak var totalAreaLabel: UILabel!
    @IBOutlet private weak var minTotalAreaLabel: UILabel!
    @IBOutlet private weak var maxTotalAreaLabel: UILabel!
    @IBOutlet private weak var minTotalAreaTextField: UITextField!
    @IBOutlet private weak var maxTotalAreaTextField: UITextField!
    @IBOutlet private weak var floorLabel: UILabel!
    @IBOutlet private weak var minFloorLabel: UILabel!
    @IBOutlet private weak var maxFloorLabel: UILabel!
    @IBOutlet private weak var minFloorTextField: UITextField!
    @IBOutlet private weak var maxFloorTextField: UITextField!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var minPriceLabel: UILabel!
    @IBOutlet private weak var maxPriceLabel: UILabel!
    @IBOutlet private weak var minPriceTextField: UITextField!
    @IBOutlet private weak var maxPriceTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!
    
    var viewModel: FiltersViewModelType?
    
    private let style = FiltersStyle()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        configureViewComponents()
    }
}

// MARK: - Private methods
private extension FiltersViewController {
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        configureTransactionSegmentedControl(with: viewModel.transactionKinds)
        configureAccommodationSegmentedControler(with: viewModel.accommodationKinds)
        
        viewModel.selectedRooms
            .drive(onNext: { [weak self] in
                self?.handle(selectedRooms: $0)
            })
            .disposed(by: disposeBag)
        
        let selectedRooms = [
            oneRoomButton,
            twoRoomsButton,
            threeRoomsButton,
            fourRoomsButton,
            fiveRoomsButton
        ]
        .compactMap { $0 }
        .enumerated()
        .map { index, button in
            button.rx.tap
                .asSignal()
                .map { index + 1 }
        }
        
        viewModel.bindViewEvents(
            selectedTransaction: transactionSegmentedControl.rx.selectedSegmentIndex.asDriver(),
            selectedAccommodation: accommodationSegmentedControl.rx.selectedSegmentIndex.asDriver(),
            selectedRoom: Signal.merge(selectedRooms),
            minTotalArea: minTotalAreaTextField.rx.text.orEmpty.asDriver(),
            maxTotalArea: maxTotalAreaTextField.rx.text.orEmpty.asDriver(),
            minFloor: minFloorTextField.rx.text.orEmpty.asDriver(),
            maxFloor: maxFloorTextField.rx.text.orEmpty.asDriver(),
            minPrice: minPriceTextField.rx.text.orEmpty.asDriver(),
            maxPrice: maxPriceTextField.rx.text.orEmpty.asDriver(),
            confirmButtonTap: confirmButton.rx.tap.asSignal()
        )
    }
    
    func configureViewComponents() {
        navigationItem.title = NSLocalizedString("Filters.NavigationBar.Title", comment: "")
        
        configureLabels()
        configureButtons()
        configureTextFields()
    }
    
    func configureLabels() {
        transactionLabel.attributedText = NSLocalizedString("Filters.Headers.Transaction", comment: "")
            .styled(with: style.header)
        accommodationLabel.attributedText = NSLocalizedString("Filters.Headers.Accommodation", comment: "")
            .styled(with: style.header)
        roomsLabel.attributedText = NSLocalizedString("Filters.Headers.Rooms", comment: "")
            .styled(with: style.header)
        totalAreaLabel.attributedText = NSLocalizedString("Filters.Headers.TotalArea", comment: "")
            .styled(with: style.header)
        floorLabel.attributedText = NSLocalizedString("Filters.Headers.Floor", comment: "")
            .styled(with: style.header)
        priceLabel.attributedText = NSLocalizedString("Filters.Headers.Price", comment: "")
            .styled(with: style.header)
        minTotalAreaLabel.attributedText = NSLocalizedString("Filters.Range.From", comment: "")
            .styled(with: style.description)
        maxTotalAreaLabel.attributedText = NSLocalizedString("Filters.Range.To", comment: "")
            .styled(with: style.description)
        minFloorLabel.attributedText = NSLocalizedString("Filters.Range.From", comment: "")
            .styled(with: style.description)
        maxFloorLabel.attributedText = NSLocalizedString("Filters.Range.To", comment: "")
            .styled(with: style.description)
        minPriceLabel.attributedText = NSLocalizedString("Filters.Range.From", comment: "")
            .styled(with: style.description)
        maxPriceLabel.attributedText = NSLocalizedString("Filters.Range.To", comment: "")
            .styled(with: style.description)
    }
    
    func configureButtons() {
        oneRoomButton.layer.cornerRadius = style.roomButtonCornerRadius
        twoRoomsButton.layer.cornerRadius = style.roomButtonCornerRadius
        threeRoomsButton.layer.cornerRadius = style.roomButtonCornerRadius
        fourRoomsButton.layer.cornerRadius = style.roomButtonCornerRadius
        fiveRoomsButton.layer.cornerRadius = style.roomButtonCornerRadius
        confirmButton.layer.cornerRadius = style.confirmButtonCornerRadius
        
        let oneRoomButtonTitle = NSLocalizedString("Filters.Room.One", comment: "")
            .styled(with: style.roomButtonTitle)
        let twoRoomsButtonTitle = NSLocalizedString("Filters.Room.Two", comment: "")
            .styled(with: style.roomButtonTitle)
        let threeRoomsButtonTitle = NSLocalizedString("Filters.Room.Three", comment: "")
            .styled(with: style.roomButtonTitle)
        let fourRoomsButtonTitle = NSLocalizedString("Filters.Room.Four", comment: "")
            .styled(with: style.roomButtonTitle)
        let fiveRoomsButtonTitle = NSLocalizedString("Filters.Room.FivePlus", comment: "")
            .styled(with: style.roomButtonTitle)
        let confirmButtonTitle = NSLocalizedString("Filters.ConfirmButton.Title", comment: "")
            .styled(with: style.confirmButtonTitle)
        
        oneRoomButton.setAttributedTitle(oneRoomButtonTitle, for: .normal)
        twoRoomsButton.setAttributedTitle(twoRoomsButtonTitle, for: .normal)
        threeRoomsButton.setAttributedTitle(threeRoomsButtonTitle, for: .normal)
        fourRoomsButton.setAttributedTitle(fourRoomsButtonTitle, for: .normal)
        fiveRoomsButton.setAttributedTitle(fiveRoomsButtonTitle, for: .normal)
        confirmButton.setAttributedTitle(confirmButtonTitle, for: .normal)
        
        confirmButton.backgroundColor = style.enabledButtonColor
    }
    
    func configureTextFields() {
        minTotalAreaTextField.placeholder = NSLocalizedString(
            "Filters.TextField.Placeholder.SquareMeter",
            comment: ""
        )
        maxTotalAreaTextField.placeholder = NSLocalizedString(
            "Filters.TextField.Placeholder.SquareMeter",
            comment: ""
        )
        minPriceTextField.placeholder = NSLocalizedString(
            "Filters.TextField.Placeholder.Ruble",
            comment: ""
        )
        maxPriceTextField.placeholder = NSLocalizedString(
            "Filters.TextField.Placeholder.Ruble",
            comment: ""
        )
    }
    
    func configureTransactionSegmentedControl(with kinds: [Filters.TransactionKind]) {
        for (index, kind) in kinds.enumerated() {
            switch kind {
                case .sell:
                    transactionSegmentedControl.setTitle(
                        NSLocalizedString("Filters.Transaction.Sell", comment: ""),
                        forSegmentAt: index
                    )
                case .rent:
                    transactionSegmentedControl.setTitle(
                        NSLocalizedString("Filters.Transaction.Rent", comment: ""),
                        forSegmentAt: index
                    )
            }
        }
    }
    
    func configureAccommodationSegmentedControler(with kinds: [Filters.AccommodationKind]) {
        for (index, kind) in kinds.enumerated() {
            switch kind {
                case .apartment:
                    accommodationSegmentedControl.setTitle(
                        NSLocalizedString("Filters.Accommodation.Apartment", comment: ""),
                        forSegmentAt: index
                    )
                case .room:
                    accommodationSegmentedControl.setTitle(
                        NSLocalizedString("Filters.Accommodation.Room", comment: ""),
                        forSegmentAt: index
                    )
                case .cottage:
                    accommodationSegmentedControl.setTitle(
                        NSLocalizedString("Filters.Accommodation.House", comment: ""),
                        forSegmentAt: index
                    )
            }
        }
    }
    
    func handle(selectedRooms: [Int]) {
        [
            oneRoomButton,
            twoRoomsButton,
            threeRoomsButton,
            fourRoomsButton,
            fiveRoomsButton
        ]
        .enumerated()
        .map { index, button in (index + 1, button) }
        .forEach { currentRoomsCount, button in
            button?.backgroundColor = selectedRooms.contains(currentRoomsCount)
                ? style.enabledButtonColor
                : style.disabledButtonColor
        }
    }
}
