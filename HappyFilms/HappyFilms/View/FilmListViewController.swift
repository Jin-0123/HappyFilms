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
    
    static func push(on topVC: UIViewController, genre: Genre) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Self.id()) as? Self else { return }
        vc.title = genre.title
        topVC.navigationController?.pushViewController(vc, animated: true)
    }
    
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
        headerView.set(viewModel.sortOption)
    }
    
    private func bindViewModel() {
        let tapFilmRelay = PublishRelay<FilmListCellEvent>()
        let sortRelay: BehaviorRelay<SortOption?> = BehaviorRelay(value: nil)
        
        // Input
        let inputs = FilmListViewModel.Inputs(tapFilm: tapFilmRelay.mapAt(\.film).unwrap().asObservable(),
                                              tapAdd: addButton.rx.tap.asObservable(),
                                              tapSortButton: headerView.titleButton.rx.tap.asObservable(),
                                              selectSortOption: sortRelay.asObservable())
        viewModel.bind(inputs)
        
        // Output
        viewModel.outputs.films.map { $0 }.drive(tableView.rx.items) { tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withClass: FilmListTableViewCell.self, for: indexPath)
            cell.set(item)
            cell.bind(to: tapFilmRelay)
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.outputs.action.drive(onNext: { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .showAddFilm1:
                AddFilm1ViewController.push(on: self)
            case .showDetail(let film):
                FilmDetailViewController.push(on: self, film: film)
            case .showSortSheet:
                self.rx.showActionSheet(title: SortOption.title,
                                        firstTitle: SortOption.allCases[0].optionName,
                                        secondTitle: SortOption.allCases[1].optionName,
                                        thirdTitle: SortOption.allCases[2].optionName)
                    .map { 
                        return SortOption(rawValue: $0) ?? .saveDate
                    }
                    .bind(to: sortRelay)
                    .disposed(by: self.disposeBag)
            case .selectedSortOption(let option):
                self.headerView.set(option)            
            default:
                break    
            }
        }).disposed(by: disposeBag)
    }
    
}
