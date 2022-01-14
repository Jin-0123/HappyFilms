//
//  FilmDetailViewController.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 14/1/22.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class FilmDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    @IBOutlet weak var watchedDate: UILabel!
    @IBOutlet weak var memoLabel: UIButton!
    
    private var likeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "🤍", style: .plain, target: nil, action: nil)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private var viewModel = HFAppDI.shared.filmDetailViewModel
    
    static func push(on topVC: UIViewController, film: Film) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Self.id()) as? Self else { return }
        vc.title = film.prettyTitle
        vc.viewModel.setup(film)
        topVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        bindViewModel()
    }
    
    private func setView() {
        navigationItem.rightBarButtonItem = likeButton
    }
    
    private func bindViewModel() {
        // Input
        let inputs = FilmDetailViewModel.Inputs(tapLikeButton: likeButton.rx.tap.asObservable())
        viewModel.bind(inputs)
        
        // Output
        viewModel.outputs.film.drive(onNext: { [weak self] film in
            guard let self = self else { return }
            self.imageView.kf.setImage(with: URL(string: film.image))
            self.directorLabel.text = film.director.prettyNames
            self.actorsLabel.text = film.actor.prettyNames
            self.pubDateLabel.text = "\(film.prettyTitle)(\(film.pubDate))"
            self.watchedDate.text = film.watchedDateString
            self.memoLabel.setTitle(film.memo, for: .normal)
            self.likeButton.title = film.isLiked ? "❤️" : "🤍"
        }).disposed(by: disposeBag)
        
        viewModel.outputs.action.drive(onNext: { action in
            switch action {
            default: break;
            }
        }).disposed(by: disposeBag)
    }

}
