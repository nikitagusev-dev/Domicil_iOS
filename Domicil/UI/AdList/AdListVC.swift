//
//  AdListVC.swift
//  Domicil
//
//  Created by Никита Гусев on 20.04.2022.
//

import RxSwift
import UIKit

class AdListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    var viewModel: AdListViewModelType?
    
    private let style = AdListStyle()
    private let backgroundLabel = UILabel()
    private let filtersBarButtonItem = UIBarButtonItem()
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewComponents()
        bindViewModel()
    }
}

// MARK: - Private methods
private extension AdListViewController {
    func configureViewComponents() {        
        tableView.register(
            UINib(nibName: "AdListViewCell", bundle: .main),
            forCellReuseIdentifier: AdListViewCell.identifier
        )
        tableView.addSubview(refreshControl)
        tableView.separatorStyle = .none
        
        backgroundLabel.numberOfLines = 0
        tableView.backgroundView = backgroundLabel
        
        filtersBarButtonItem.tintColor = style.filtersImageTintColor
        filtersBarButtonItem.image = style.filtersImage
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.cellViewModels
            .drive(tableView.rx.items(
                cellIdentifier: AdListViewCell.identifier,
                cellType: AdListViewCell.self
            )) { _, viewModel, cell in
                cell.prepareForReuse()
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        viewModel.cellViewModels
            .map { !$0.isEmpty }
            .drive(backgroundLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        viewModel.placeholder
            .mapStyle(style.placeholder)
            .drive(backgroundLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.placeholder
            .map { $0 == nil }
            .drive(backgroundLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.navigationTitle
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.isFiltersButtonHidden
            .drive(onNext: { [weak self] isHidden in
                guard let self = self else { return }
                
                if isHidden {
                    self.navigationItem.rightBarButtonItem = nil
                } else {
                    self.navigationItem.rightBarButtonItem = self.filtersBarButtonItem
                }
            })
            .disposed(by: disposeBag)
        
        let didScrollToBottom = tableView.rx.willDisplayCell
            .map { $0.indexPath.row }
            .withLatestFrom(viewModel.cellViewModels) { ($0, $1) }
            .filter { row, cells in row == cells.count - 1 }
            .map { _ in }
            .asSignal(onErrorSignalWith: .empty())
        
        let didSelectCell = tableView.rx.itemSelected
            .asSignal()
            .map { $0.row }
        
        viewModel.bindViewEvents(
            didPullToRefresh: refreshControl.rx.controlEvent(.valueChanged).asSignal(),
            didScrollToBottom: didScrollToBottom,
            filtersButtonTap: filtersBarButtonItem.rx.tap.asSignal()
        )
        
        viewModel.bindViewEvents(didSelectCell: didSelectCell)
    }
}
