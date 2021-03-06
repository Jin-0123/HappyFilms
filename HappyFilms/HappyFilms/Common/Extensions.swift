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


// MARK: - UIViewController+Rx

extension UIViewController {
    
    static func push(on topVC: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: Self.id()) as? Self else { return }
        topVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTextFieldAlert(title: String? = nil, message: String? = nil, confirmHandler: ((String?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "??????", style: .default, handler: { action in
            confirmHandler?(alert.textFields?.first?.text)
        }))
        alert.addAction(UIAlertAction(title: "??????", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(title: String, firstTitle: String, firstAction: ((UIAlertAction) -> Void)?, secondTitle: String, secondAction: ((UIAlertAction) -> Void)?, thirdTitle: String, thirdAction: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let first = UIAlertAction(title: firstTitle, style: .default, handler: firstAction)
        let second = UIAlertAction(title: secondTitle, style: .default, handler: secondAction)
        let third = UIAlertAction(title: thirdTitle, style: .default, handler: thirdAction)
        let cancel = UIAlertAction(title: "??????", style: .cancel, handler: nil)
        
        alert.addAction(first)
        alert.addAction(second)
        alert.addAction(third)
        alert.addAction(cancel)
        
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
    
    func showActionSheet(title: String, firstTitle: String, secondTitle: String, thirdTitle: String) -> Observable<Int> {
        return Observable<Int>.create { [weak base] observer in
            base?.showActionSheet(title: title,
                                  firstTitle: firstTitle,
                                  firstAction: { _ in observer.onNext(0); observer.onCompleted() },
                                  secondTitle: secondTitle,
                                  secondAction: { _ in observer.onNext(1); observer.onCompleted() },
                                  thirdTitle: thirdTitle,
                                  thirdAction: { _ in observer.onNext(2); observer.onCompleted() })
            return Disposables.create()
        }.observe(on: MainScheduler.instance)
    }
}


// MARK: - String

extension String {

    var htmlToString: String? {
        guard let data = data(using: .utf8) else { return nil }
     
        return try? NSMutableAttributedString(data: data, options: [
            .documentType: NSMutableAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string
    }
    
    var prettyNames: String {
        if components(separatedBy: ["|"]).count > 2 {
            return String(replacingOccurrences(of: "|", with: " | ").dropLast().dropLast())
        } else {
            return replacingOccurrences(of: "|", with: "")
        }
    }
}


// MARK: - Date

extension Date {
    func toYYYYMMDD() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY. MM. dd"

        return dateFormatter.string(from: self)
    }
}
