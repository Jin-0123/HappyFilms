//
//  GenreSettingViewController.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import UIKit
import RxCocoa
import RxSwift

class GenreSettingViewController: UIViewController {
    
    private let headerView: CommonTableHeaderView = {
        let view = CommonTableHeaderView()
        view.set("장르 관리", useAddButton: true)
        return view
    }()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nibWithCellClass: GenreSettingTableViewCell.self)
            tableView.tableHeaderView = headerView
        }
    }

    private let disposeBag = DisposeBag()
    private var viewModel = HFAppDI.shared.genreSettingViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    private func bindViewModel() {
        let tapAddConfirmRelay = PublishRelay<String?>()
        let toggleRelay = PublishRelay<GenreSettingCellEvent>()
        
        // Input
        let input = GenreSettingViewModel.Inputs(tapAdd: headerView.addButton.rx.tap.asObservable(),
                                                 tapAddConfirm: tapAddConfirmRelay.unwrap().asObservable(),
                                                 toggle: toggleRelay.mapAt(\.info).unwrap().asObservable())
        viewModel.bind(input)
        
        // Output
        viewModel.outputs.genres.drive(tableView.rx.items) { tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withClass: GenreSettingTableViewCell.self, for: indexPath)
            
            cell.set(item.id, title: item.title, isOn: item.isOn)
            cell.bind(to: toggleRelay)
            
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.outputs.action.drive(onNext: { [weak self] action in
            guard let self = self else { return }
            
            switch action {
            case .showAddAlert:
                self.rx.showTextFieldAlert(title: "장르 추가")
                    .unwrap()
                    .bind(to: tapAddConfirmRelay)
                    .disposed(by: self.disposeBag)
            case .refresh:
                self.tableView.reloadData()
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

}
