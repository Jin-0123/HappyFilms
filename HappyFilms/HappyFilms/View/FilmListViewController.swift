//
//  FilmListViewController.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import UIKit
import RxCocoa
import RxSwift

class FilmListViewController: UIViewController {

    private var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        return button
    }()
    
    private let headerView: SortTableHeaderView = {
        let view = SortTableHeaderView()
        return view
    }()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nibWithCellClass: FilmListTableViewCell.self)
            tableView.tableHeaderView = headerView
        }
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel = HFAppDI.shared.filmListViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setView() {
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func bindViewModel() {
        // Input
        let inputs = FilmListViewModel.Inputs(tapAdd: addButton.rx.tap.asObservable())
        viewModel.bind(inputs)
        
        // Output
//        viewModel.outputs.genres.drive(tableView.rx.items) { tableView, row, item in
//            let indexPath = IndexPath(row: row, section: 0)
//            let cell = tableView.dequeueReusableCell(withClass: MyFilmsNoteTableViewCell.self, for: indexPath)
//            cell.set(item.id, title: item.title)
//            cell.bind(to: tapGenreRelay)
//            return cell
//        }.disposed(by: disposeBag)
        
        viewModel.outputs.action.drive(onNext: { action in
            switch action {
            case .showAddFilm1:
                AddFilm1ViewController.push(on: self)
            }
        }).disposed(by: disposeBag)
    }
    
}
