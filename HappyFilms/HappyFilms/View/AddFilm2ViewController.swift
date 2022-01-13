//
//  AddFilm2ViewController.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import UIKit
import RxCocoa
import RxSwift

class AddFilm2ViewController: UIViewController {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
        button.isEnabled = false
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private var viewModel = HFAppDI.shared.addFilm2ViewModel
    
    static func push(on topVC: UIViewController, film: Film) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Self.id()) as? Self else { return }
        vc.title = film.title.htmlToString
        vc.viewModel.setup(film)
        topVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        bindViewModel()
    }
    
    private func setView() {
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func bindViewModel() {
        
        let watchedDateRelay = datePicker.rx.controlEvent(.valueChanged).map { [weak self] in
            self?.datePicker.date ?? nil
        }.unwrap().asObservable()
        
        // Input
        let inputs = AddFilm2ViewModel.Inputs(tapDateButton: dateButton.rx.tap.asObservable(),
                                              tapDone: doneButton.rx.tap.asObservable(),
                                              watchedDate: watchedDateRelay,
                                              memo: textField.rx.text.orEmpty.distinctUntilChanged().asObservable())
        viewModel.bind(inputs)
        
        // Output
        viewModel.outputs.action.drive(onNext: { [weak self] action in
            guard let self = self else { return }
            
            switch action {
            case .showPicker:
                self.datePicker.isHidden.toggle()
            case .changeDate(let date):
                self.dateButton.setTitle(date.toYYYYMMDD(), for: .normal)
            case .popToFilmList:
                guard let fileListVC = self.navigationController?.viewControllers.first(where: { $0 is FilmListViewController }) else { return }
                self.navigationController?.popToViewController(fileListVC, animated: true)
            case .isActivateDone(let isActivate):
                self.navigationItem.rightBarButtonItem?.isEnabled = isActivate
            default:
                break
            }
        }).disposed(by: disposeBag)
    }
}
