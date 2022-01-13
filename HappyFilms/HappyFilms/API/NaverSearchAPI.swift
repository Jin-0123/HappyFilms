//
//  NaverSearchAPI.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation
import RxSwift

struct NaverSearchAPI {
    
    private static let URL = "https://openapi.naver.com/v1/search/movie.json"
    private static let KEY_PARAMS_QUERY = "query"
    private static let KEY_CLIENT_ID = "X-Naver-Client-Id"
    private static let KEY_CLIENT_SECRET = "X-Naver-Client-Secret"
    private static let CLIENT_ID = "50CjTKfSIkyokg7T4PYD"
    private static let CLIENT_SECRET  = "GTbp4ibKg9"
    
    static func searchFilms(_ query: String) -> Observable<FilmsDTO?> {
        let parameters = [KEY_PARAMS_QUERY: query]
        let headers = [
            KEY_CLIENT_ID: CLIENT_ID,
            KEY_CLIENT_SECRET: CLIENT_SECRET
        ]
        
        return RequestBuilder<FilmsDTO?>(method: .get, URLString: Self.URL, parameters: parameters, isBody: false, headers: headers).returnObservable()
    }
}
