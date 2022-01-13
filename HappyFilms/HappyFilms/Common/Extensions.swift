//
//  Extensions.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation
import UIKit
import RxSwift

// MARK: - NSObject

extension NSObject {
    
    static func id() -> String {
        return String(describing: self)
    }
}


// MARK: - UITableView

extension UITableView {
    func register(_ id: String) {
        register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
    }
    
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }

        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(nibWithHeaderFooterViewClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?

        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        register(UINib(nibName: identifier, bundle: bundle), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError(
                "Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }
}


// MARK: - UIAlertController+Rx

extension UIViewController {
    
    static func push(on topVC: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Self.id()) as? Self else { return }
        topVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTextFieldAlert(title: String? = nil, message: String? = nil, confirmHandler: ((String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "완료", style: .default, handler: { action in
            confirmHandler?(alert.textFields?.first?.text)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Reactive where Base: UIViewController {
    
    func showTextFieldAlert(title: String? = nil, message: String? = nil) -> Observable<String?> {
        return Observable<String?>.create { [weak base] observer in
            base?.showTextFieldAlert(title: title, message: message, confirmHandler: {
                observer.onNext($0)
                observer.onCompleted()
            })
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
}


// MARK: - String

extension String {

    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
     
        return try? NSMutableAttributedString(data: data, options: [
            .documentType: NSMutableAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)
    }
}
