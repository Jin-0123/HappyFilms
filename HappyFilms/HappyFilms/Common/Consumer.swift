//
//  Consumer.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation
import RxCocoa

protocol Consumer {
    
    associatedtype Item
    
    func accept(item: Item)
}

extension PublishRelay: Consumer {
    
    func accept(item: Element) {
        self.accept(item)
    }
}

extension BehaviorRelay: Consumer {
    
    func accept(item: Element) {
        self.accept(item)
    }
}

struct EmptyConsumer<T> { }

extension EmptyConsumer: Consumer {
    
    func accept(item: T) { }
}

struct OneConsumer<T> {
    
    let accept: (T) -> Void
}

extension OneConsumer: Consumer {
    
    func accept(item: T) {
        self.accept(item)
    }
}
