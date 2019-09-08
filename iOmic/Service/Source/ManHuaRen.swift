//
//  ManHuaRen.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation
import Kingfisher
import RxSwift
import SwiftyJSON

class ManHuaRen: Source {
    // MARK: - Types

    fileprivate enum Router {
        case books(Int, String, [FilterProrocol])
        case chapters(Book)
        case pages(Chapter)
    }

    fileprivate class Interceptor: RequestInterceptor {
        func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
            var request = urlRequest
            if let url = request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                let cipher = "4e0a48e1c0b54041bce9c8f0e036124d"
                var key = cipher + "GET"
                let queryItems = components.queryItems ?? []
                queryItems.filter { $0.name != "gsn" }.sorted(by: { $0.name < $1.name }).forEach {
                    guard let value = $0.value?.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) else { return }
                    key += $0.name
                    key += value
                }
                key += cipher
                do {
                    completion(.success(try URLEncoding.default.encode(request, with: ["gsn": key.md5String()])))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.success(request))
            }
        }
    }

    // MARK: - Static

    static let shared = ManHuaRen()

    // MARK: - props.

    // MARK: - Private

    private override init() {
        super.init()
    }

    // MARK: - Public
}

extension Book.Status {
    fileprivate init(mangaIsOver: Int?) {
        switch mangaIsOver {
        case 0:
            self = .ongoing
        case 1:
            self = .completed
        default:
            self = .unknown
        }
    }
}

extension ManHuaRen: OnlineSourceProtocol {
    var identifier: Source.Identifier { return .manhuaren }

    var name: String { return "漫画人" }

    var defaultFilters: [FilterProrocol] {
        return [ManHuaRen.SortFilter(title: "状态", options: [("热门", "0"), ("更新", "1"), ("新作", "2"), ("完结", "3")]), ManHuaRen.CategoryFilter(title: "分类", options: [("全部", ["0", "0"]), ("热血", ["0", "31"]), ("恋爱", ["0", "26"]), ("校园", ["0", "1"]), ("百合", ["0", "3"]), ("耽美", ["0", "27"]), ("伪娘", ["0", "5"]), ("冒险", ["0", "2"]), ("职场", ["0", "6"]), ("后宫", ["0", "8"]), ("治愈", ["0", "9"]), ("科幻", ["0", "25"]), ("励志", ["0", "10"]), ("生活", ["0", "11"]), ("战争", ["0", "12"]), ("悬疑", ["0", "17"]), ("推理", ["0", "33"]), ("搞笑", ["0", "37"]), ("奇幻", ["0", "14"]), ("魔法", ["0", "15"]), ("恐怖", ["0", "29"]), ("神鬼", ["0", "20"]), ("萌系", ["0", "21"]), ("历史", ["0", "4"]), ("美食", ["0", "7"]), ("同人", ["0", "30"]), ("运动", ["0", "34"]), ("绅士", ["0", "36"]), ("机甲", ["0", "40"]), ("限制级", ["0", "61"]), ("少年向", ["1", "1"]), ("少女向", ["1", "2"]), ("青年向", ["1", "3"]), ("港台", ["2", "35"]), ("日韩", ["2", "36"]), ("大陆", ["2", "37"]), ("欧美", ["2", "52"])])]
    }

    var modifier: AnyModifier {
        return AnyModifier { request -> URLRequest? in
            var req = request
            req.addValue(#"{"le": "zh"}"#, forHTTPHeaderField: "X-Yq-Yqci")
            req.addValue("http://www.dm5.com/dm5api/", forHTTPHeaderField: "Referer")
            req.addValue("http://mangaapi.manhuaren.com/", forHTTPHeaderField: "clubReferer")
            return req
        }
    }

    func fetchBooks(page: Int, query: String, filters: [FilterProrocol]) -> Observable<[Book]> {
        let convertible = Router.books(page, query, filters)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .compactMap { [weak self] response -> [Book] in
                guard let strongSelf = self else { return [] }
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)
                    return (json["response", "result"].array ?? json["response", "mangas"].arrayValue).compactMap { ele -> Book? in
                        let bookId = ele["mangaId"].intValue
                        var book = Book(source: strongSelf, url: "/v1/manga/getDetail?mangaId=\(bookId)")
                        book.title = ele["mangaName"].string
                        book.thumbnailUrl = ele["mangaCoverimageUrl"].string
                        book.author = ele["mangaAuthor"].string
                        book.status = Book.Status(mangaIsOver: ele["mangaIsOver"].int)
                        return book
                    }
                case let .failure(error):
                    throw error
                }
            }
    }

    func fetchChapters(book: Book) -> Observable<[Chapter]> {
        let convertible = Router.chapters(book)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .compactMap { response -> [Chapter] in
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)["response"]
                    let book = Book(source: book.source, url: book.url)
                    var detail = book
                    detail.title = json["mangaName"].string
                    if let thumbnailUrl = json["mangaCoverimageUrl"].string, !thumbnailUrl.isEmpty {
                        detail.thumbnailUrl = thumbnailUrl
                    } else if let thumbnailUrl = json["mangaPicimageUrl"].string, !thumbnailUrl.isEmpty {
                        detail.thumbnailUrl = thumbnailUrl
                    } else if let thumbnailUrl = json["shareIcon"].string, !thumbnailUrl.isEmpty {
                        detail.thumbnailUrl = thumbnailUrl
                    }
                    detail.author = json["mangaAuthors"].arrayValue.compactMap({ $0.string }).joined(separator: ", ")
                    detail.genre = json["mangaTheme"].string?.replacingOccurrences(of: " ", with: ", ")
                    detail.status = Book.Status(mangaIsOver: json["mangaIsOver"].int)
                    detail.description = json["mangaIntro"].string
                    // chapters
                    var chapters: [Chapter] = []
                    ["mangaEpisode", "mangaWords", "mangaRolls"].forEach { type in
                        guard let array = json[type].array else { return }
                        array.forEach { ele in
                            guard let sectionId = ele["sectionId"].int else { return }
                            var chapter = Chapter(book: detail, url: "/v1/manga/getRead?mangaSectionId=\(sectionId)")
                            chapter.name = "\(type == "mangaEpisode" ? "[番外] " : "")\(ele["sectionName"].stringValue)\(ele["sectionTitle"].stringValue == "" ? "" : ": \(ele["sectionTitle"].stringValue)")"
                            chapter.updateAt = ele["releaseTime"].string?.convert2Date(dateFormat: "yyyy-MM-dd")
                            chapter.chapterNumber = ele["sectionSort"].double
                            chapters.append(chapter)
                        }
                    }
                    return chapters
                case let .failure(error):
                    throw error
                }
            }
    }

    func fetchPages(chapter: Chapter) -> Observable<[Page]> {
        let convertible = Router.pages(chapter)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .compactMap { response -> [Page] in
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)["response"]
                    guard let host = json["hostList"].array?.first?.string else { return [] }
                    let array = json["mangaSectionImages"].arrayValue
                    let query = json["query"].stringValue
                    return array.enumerated().compactMap { offset, ele -> Page? in
                        var page = Page(chapter: chapter, index: offset)
                        page.imageURL = "\(host)\(ele.stringValue)\(query)"
                        return page
                    }
                case let .failure(error):
                    throw error
                }
            }
    }
}

extension ManHuaRen.Router: RequestConvertible {
    var baseURLString: URLConvertible { return "http://mangaapi.manhuaren.com" }

    var path: String {
        switch self {
        case let .books(_, query, _):
            return query.isEmpty ? "/v2/manga/getCategoryMangas" : "/v1/search/getSearchManga"
        case let .chapters(book):
            return URLComponents(string: book.url)?.path ?? book.url
        case let .pages(chapter):
            return URLComponents(string: chapter.url)?.path ?? chapter.url
        }
    }

    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "X-Yq-Yqci", value: #"{"le": "zh"}"#)
        headers.add(name: "Referer", value: "http://www.dm5.com/dm5api/")
        headers.add(name: "clubReferer", value: "http://mangaapi.manhuaren.com/")
        return headers
    }

    var method: HTTPMethod { return .get }

    var parameters: Parameters {
        var parameters: Parameters = ["gsm": "md5", "gft": "json", "gts": Date().convert2String(), "gak": "android_manhuaren2", "gat": "", "gaui": "191909801", "gui": "191909801", "gut": "0"]
        switch self {
        case let .books(page, query, filters):
            let pageSize = 20
            parameters["start"] = "\(page * pageSize)"
            parameters["limit"] = "\(pageSize)"
            if query.isEmpty {
                if let sortFilter = filters.first(where: { $0 is ManHuaRen.SortFilter }) as? ManHuaRen.SortFilter {
                    parameters["sort"] = sortFilter.value[0]
                }
                if let categoryFilter = filters.first(where: { $0 is ManHuaRen.CategoryFilter }) as? ManHuaRen.CategoryFilter {
                    parameters["subCategoryType"] = categoryFilter.categoryType
                    parameters["subCategoryId"] = categoryFilter.categoryId
                }
            } else {
                parameters["keywords"] = query
            }
        case let .chapters(book):
            URLComponents(string: book.url)?.queryItems?.forEach { parameters[$0.name] = $0.value }
        case let .pages(chapter):
            parameters["netType"] = "4"
            parameters["loadreal"] = "1"
            parameters["imageQuality"] = "2"
            URLComponents(string: chapter.url)?.queryItems?.forEach { parameters[$0.name] = $0.value }
        }
        return parameters
    }

    var parameterEncoding: ParameterEncoding { return URLEncoding.default }

    var interceptor: RequestInterceptor? { return ManHuaRen.Interceptor() }
}

extension ManHuaRen {
    class SortFilter: SinglePickFilter {}

    class CategoryFilter: SinglePickFilter {
        var categoryType: String {
            return value[0]
        }

        var categoryId: String {
            return value[1]
        }
    }
}
