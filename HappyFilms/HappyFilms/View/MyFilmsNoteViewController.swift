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
        view.set("🎬 나의 영화 노트")
        return view
    }()

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(nibWithCellClass: MyFilmsNoteTableViewCell.self)
            tableView.tableHeaderView = headerView
        }
    }
    
    private let disposeBag = DisposeBag()
    private var viewModel = HFAppDI.shared.myFilmsNoteViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    private func bindViewModel() {
        let tapGenreRelay = PublishRelay<MyFilmsNoteCellEvent>()
        
        // Input
        let inputs = MyFilmsNoteViewModel.Inputs(tapGenre: tapGenreRelay.mapAt(\.genre).unwrap().asObservable())
        viewModel.bind(inputs)
        
        // Output
        viewModel.outputs.genres.drive(tableView.rx.items) { tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withClass: MyFilmsNoteTableViewCell.self, for: indexPath)
            cell.set(item)
            cell.bind(to: tapGenreRelay)
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.outputs.action.drive(onNext: { action in
            switch action {
            case .showFilmsList(let genre):
                FilmListViewController.push(on: self, genre: genre)
            default: break
            }
        }).disposed(by: disposeBag)
    }
}
