//
//  AddFilm1ViewController.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import UIKit
import RxCocoa
import RxSwift

class AddFilm1ViewController: UIViewController {
    
    private var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "다음", style: .plain, target: nil, action: nil)
        return button
    }()
    
    private let headerView: SearchTableHeaderView = {
        let view = SearchTableHeaderView()
        return view
    }()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nibWithCellClass: AddFilm1TableViewCell.self)
            tableView.tableHeaderView = headerView
        }
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel = HFAppDI.shared.addFilm1ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        bindViewModel()
    }
    

    private func setView() {
        navigationItem.rightBarButtonItem = nextButton
    }
    
    private func bindViewModel() {
        let selectedFilmRelay = PublishRelay<AddFilm1CellEvent>()
        
        // Input
        let inputs = AddFilm1ViewModel.Inputs(tapNext: nextButton.rx.tap.asObservable(),
                                              keyword: headerView.textField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
                                              select: selectedFilmRelay.mapAt(\.item).asObservable())
        viewModel.bind(inputs)
        
        // Output
        viewModel.outputs.films.drive(tableView.rx.items) { tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withClass: AddFilm1TableViewCell.self, for: indexPath)
            cell.set(item)
            cell.bind(to: selectedFilmRelay)
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.outputs.action.drive(onNext: { [weak self] action in
            guard let self = self else { return }
            
            switch action {
            case .showAddFilm2:
                AddFilm2ViewController.push(on: self)
            case .isActivateNext(let isActivate):
                self.navigationItem.rightBarButtonItem?.isEnabled = isActivate
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}
