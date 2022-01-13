//
//  RequestBuilder.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 10/1/22.
//

import Alamofire
import Foundation
import RxSwift

class RequestBuilder<T: Decodable> {
    
    private let parameters: [String:Any]?
    private let isBody: Bool
    private let method: HTTPMethod
    private let URLString: String
    private var headers: [String:String]
    private var willRequest: DataRequest?
    
    init(method: HTTPMethod = .get, URLString: String, parameters: [String:Any]?, isBody: Bool, headers: [String:String] = [:]) {
        self.method = method
        self.URLString = URLString
        self.parameters = parameters
        self.isBody = isBody
        self.headers = headers
    }
    
    @discardableResult private func makeRequest() -> DataRequest {
        let request = AF.request(URLString, method: method, parameters: parameters, headers: HTTPHeaders(headers))
        willRequest = request
        return request
    }
    
    private func cancel() {
        willRequest?.cancel()
        willRequest = nil
    }
    
    private func excute(_ completion: @escaping (_ response: Response<T>?, _ error: Error?) -> Void) {
        makeRequest().responseDecodable(of: T.self) { result in
            if let error = result.error {
                completion(nil, ErrorResponse.error(error.errorDescription))
            }
                
            guard let response = result.response, let data = result.value else {
                completion(nil, ErrorResponse.empty)
                return
            }
                
            completion(Response(response: response, data: data), nil)
        }
    }
}


// MARK: - RequestBuilder+Rx

extension RequestBuilder {
    
    func returnObservable() -> Observable<T> {
        return Observable.create { observer -> Disposable in
            self.excute { response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                if let data = response?.data {
                    observer.onNext(data)
                    observer.onCompleted()
                    return
                }
                
                observer.onError(ErrorResponse.empty)
            }
            
            return Disposables.create { self.cancel() }
        }
    }
}
