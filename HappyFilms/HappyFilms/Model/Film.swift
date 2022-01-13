//
//  Film.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

enum SortOption: Int, CaseIterable {
    case saveDate, watchedDate, pubDate
    
    static var title: String {
        "정렬 방식"
    }
    
    var optionName: String {
        switch self {
        case .saveDate:
            return "기록 생성 순"
        case .watchedDate:
            return "영화 본 날짜 순"
        case .pubDate:
            return "개봉 연도 순"
        }
    }
}

struct Film: Equatable {
    let title: String
    let image: String
    let director: String
    let actor: String
    let pubDate: String
    let userRating: String
    var isSelected: Bool
    var isLiked: Bool
    var saveDate: Date?
    var watchedDate: Date?
    var memo: String?
    
    var prettyTitle: String {
        title.htmlToString ?? ""
    }
    
    var watchedDateString: String {
        watchedDate?.toYYYYMMDD() ?? ""
    }
    
    init(from dto: FilmItemDTO) {
        title = dto.title
        image = dto.image
        director = dto.director
        actor = dto.actor
        pubDate = dto.pubDate
        userRating = dto.userRating
        isSelected = false
        isLiked = false
    }
    
    static func == (lhs: Film, rhs: Film) -> Bool {
        return lhs.title == rhs.title &&
        lhs.image == rhs.image &&
        lhs.director == rhs.director &&
        lhs.actor == rhs.actor &&
        lhs.pubDate == rhs.pubDate &&
        lhs.userRating == rhs.userRating
    }
}

class FilmList {
    private let id: UUID
    fileprivate let filmsRelay: BehaviorRelay<[Film]> = BehaviorRelay(value: [])
    var films: [Film] {
        filmsRelay.value
    }
    
    init(id: UUID) {
        self.id = id
    }
    
    func fetch(_ genres: [Film]?) {
        filmsRelay.accept(genres ?? [])
    }
    
    fileprivate func add(_ film: Film) {
        var cached = filmsRelay.value
        cached.append(film)
        filmsRelay.accept(cached)
    }
}

class FilmsManager {
    
    static let shared: FilmsManager = FilmsManager()
    
    private init() { }
    
    private let selectedGenreRelay: BehaviorRelay<UUID?> = BehaviorRelay(value: nil)
    private var filmsDic: [UUID:FilmList] = [:]
    let sortOptionRelay: BehaviorRelay<SortOption> = BehaviorRelay(value: .saveDate)
    var sortOption: SortOption {
        sortOptionRelay.value
    }
    
    func selectGenre(_ id: UUID) {
        selectedGenreRelay.accept(id)
    }
    
    func selectSortOption(_ option: SortOption) {
        sortOptionRelay.accept(option)
    }
    
    func get() -> Observable<[Film]> {
        guard let id = selectedGenreRelay.value else { return .empty() }
        
        if filmsDic[id] == nil {
            filmsDic[id] = FilmList(id: id)
        }
        return filmsDic[id]!.filmsRelay.asObservable()
    }
    
    func add(_ film: Film) {
        guard let id = selectedGenreRelay.value else { return }
        
        filmsDic[id]?.add(film)
    }
}
