//
//  MyFilmsNoteViewController.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import UIKit
import RxCocoa
import RxSwift

class MyFilmsNoteViewController: UIViewController {
    private let headerView: CommonTableHeaderView = {
        let view = CommonTableHeaderView()
        view.setTitle("나의 영화 노트")
        return view
    }()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nibWithCellClass: MyFilmsNoteTableViewCell.self)
            tableView.tableHeaderView = headerView
        }
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel = MyFilmsNoteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        viewModel.outputs.genres.drive(tableView.rx.items) { tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withClass: MyFilmsNoteTableViewCell.self, for: indexPath)
            cell.set(item)
            return cell
        }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // Input
        viewModel.bind(.init(tapGenre: tableView.rx.itemSelected.asObservable()))
        
        // Output
        viewModel.outputs.action.drive(onNext: { action in
            switch action {
            case .showFilmsList(let genreId):
                print("다음 화면으로 이동 \(genreId)")
            }
        }).disposed(by: disposeBag)
    }
}
