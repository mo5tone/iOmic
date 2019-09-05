//
//  DongManZhiJia.swift
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

class DongManZhiJia: Source {
    // MARK: - Types

    fileprivate enum Router {
        case books(Int, String, [FilterProrocol])
        case chapters(Book)
        case pages(Chapter)
    }

    // MARK: - Static

    static let shared = DongManZhiJia()

    // MARK: - Props.

    // MARK: - Private

    private override init() {
        super.init()
    }

    // MARK: - Public
}

extension Book.Status {
    fileprivate init(string: String?) {
        switch string {
        case "2310", "已完结":
            self = .completed
        case "2309", "连载中":
            self = .ongoing
        default:
            self = .unknown
        }
    }
}

// MARK: - OnlineSourceProtocol

extension DongManZhiJia: OnlineSourceProtocol {
    var identifier: Source.Identifier { return .dongmanzhijia }

    var name: String { return "动漫之家" }

    var defaultFilters: [FilterProrocol] {
        return [DongManZhiJia.SortFilter(title: "排序", options: [("人气", "0"), ("更新", "1")]), DongManZhiJia.GenreFilter(title: "分类", options: [("全部", ""), ("冒险", "4"), ("百合", "3243"), ("生活", "3242"), ("四格", "17"), ("伪娘", "3244"), ("悬疑", "3245"), ("后宫", "3249"), ("热血", "3248"), ("耽美", "3246"), ("其他", "16"), ("恐怖", "14"), ("科幻", "7"), ("格斗", "6"), ("欢乐向", "5"), ("爱情", "8"), ("侦探", "9"), ("校园", "13"), ("神鬼", "12"), ("魔法", "11"), ("竞技", "10"), ("历史", "3250"), ("战争", "3251"), ("魔幻", "5806"), ("扶她", "5345"), ("东方", "5077"), ("奇幻", "5848"), ("轻小说", "6316"), ("仙侠", "7900"), ("搞笑", "7568"), ("颜艺", "6437"), ("性转换", "4518"), ("高清单行", "4459"), ("治愈", "3254"), ("宅系", "3253"), ("萌系", "3252"), ("励志", "3255"), ("节操", "6219"), ("职场", "3328"), ("西方魔幻", "3365"), ("音乐舞蹈", "3326"), ("机战", "3325")]), DongManZhiJia.StatusFilter(title: "连载", options: [("全部", ""), ("连载", "2309"), ("完结", "2310")]), DongManZhiJia.TypeFilter(title: "地区", options: [("全部", ""), ("日本", "2304"), ("韩国", "2305"), ("欧美", "2306"), ("港台", "2307"), ("内地", "2308"), ("其他", "8453")]), DongManZhiJia.ReaderFilter(title: "读者", options: [("全部", ""), ("少年", "3262"), ("少女", "3263"), ("青年", "3264")])]
    }

    var modifier: AnyModifier {
        return AnyModifier { request -> URLRequest? in
            var req = request
            req.addValue("http://www.dmzj.com/", forHTTPHeaderField: "Referer")
            return req
        }
    }

    func fetchBooks(page: Int, query: String, filters: [FilterProrocol]) -> Observable<[Book]> {
        func jsonParser(json: JSON) -> [Book] {
            return (json.array ?? []).compactMap { json -> Book? in
                guard let bookId = json["id"].int else { return nil }
                let book = Book(source: self, url: "/comic/\(bookId).json")
                book.title = json["title"].string
                book.author = json["authors"].string
                book.thumbnailUrl = json["cover"].string?.fixScheme()
                book.status = Book.Status(string: json["status"].string)
                book.description = json["description"].string
                return book
            }
        }
        func stringParser(string: String) throws -> [Book] {
            let regEx = try NSRegularExpression(pattern: #"g_search_data = (.*);"#)
            let results = regEx.matches(in: string, range: NSRange(string.startIndex..., in: string))
            guard let result = results.first, result.numberOfRanges > 1, let range = Range(result.range(at: 1), in: string) else { return [] }
            return (JSON(parseJSON: String(string[range])).array ?? []).compactMap { json -> Book? in
                guard let bookId = json["id"].string else { return nil }
                let book = Book(source: self, url: "/comic/\(bookId).json")
                book.title = json["name"].string
                book.author = json["authors"].string
                book.thumbnailUrl = json["cover"].string?.fixScheme()
                book.status = Book.Status(string: json["status_tag_id"].string)
                book.description = json["description"].string
                return book
            }
        }
        let convertible = Router.books(page, query, filters)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .compactMap { response -> [Book] in
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    if query.isEmpty {
                        return jsonParser(json: try JSON(data: data))
                    } else if let string = String(data: data, encoding: .utf8) {
                        return try stringParser(string: string)
                    } else {
                        throw Whoops.Codeing.decodeFailed
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
                    let json = try JSON(data: data)
                    book.title = json["title"].string
                    book.thumbnailUrl = json["cover"].string?.fixScheme()
                    book.author = (json["authors"].array ?? []).compactMap { $0["tag_name"].string }.joined(separator: ", ")
                    book.genre = (json["types"].array ?? []).compactMap { $0["tag_name"].string }.joined(separator: ", ")
                    if let intValue = json["status"][0]["tag_id"].int { book.status = Book.Status(string: "\(intValue)") }
                    book.description = json["description"].string
                    var chapters: [Chapter] = []
                    if let bookId = json["id"].string {
                        (json["chapters"].array ?? []).forEach { item in
                            let prefix = item["title"].stringValue
                            (item["data"].array ?? []).forEach { item1 in
                                guard let chapterId = item1["chapter_id"].string else { return }
                                let chapter = Chapter(book: book, url: "/chapter/\(bookId)/\(chapterId).json")
                                let chapterTitle = item1["chapter_title"].stringValue
                                chapter.name = "[\(prefix)]\(chapterTitle)"
                                chapter.updateAt = Date(timeIntervalSince1970: item1["updatetime"].doubleValue)
                                chapters.append(chapter)
                            }
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
                    let json = try JSON(data: data)
                    var pages = [Page]()
                    (json["page_url"].array ?? []).enumerated().forEach { offset, element in
                        let page = Page(chapter: chapter, index: offset)
                        page.imageURL = element.string
                        pages.append(page)
                    }
                    return pages
                case let .failure(error):
                    throw error
                }
            }
    }
}

// MARK: - RequestConvertible

extension DongManZhiJia.Router: RequestConvertible {
    var baseURLString: URLConvertible {
        if case let .books(_, query, _) = self, !query.isEmpty {
            return "http://s.acg.dmzj.com/comicsum/search.php"
        }
        return "http://v2.api.dmzj.com"
    }

    var path: String {
        switch self {
        case let .books(page, query, filters):
            var types = filters.filter { !($0 is DongManZhiJia.SortFilter) }
                .compactMap { $0 as? SinglePickFilter }
                .compactMap { $0.value[0].isEmpty ? nil : $0.value[0] }
                .joined(separator: "-")
            if types.isEmpty { types = "0" }
            var order = filters.compactMap { $0 as? DongManZhiJia.SortFilter }
                .compactMap { $0.value[0].isEmpty ? nil : $0.value[0] }
                .joined()
            if order.isEmpty { order = "0" }
            if query.isEmpty {
                return "/classify/\(types)/\(order)/\(page).json"
            } else {
                return ""
            }
        case let .chapters(book):
            return book.url
        case let .pages(chapter):
            return chapter.url
        }
    }

    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Referer", value: "http://www.dmzj.com/")
        headers.add(name: "User-Agent", value: ["Mozilla/5.0 (X11; Linux x86_64)", "AppleWebKit/537.36 (KHTML, like Gecko)", "Chrome/56.0.2924.87", "Safari/537.36", "iOmic/1.0"].joined(separator: " "))
        return headers
    }

    var method: HTTPMethod { return .get }

    var parameters: Parameters {
        if case let .books(_, query, _) = self, !query.isEmpty {
            return ["s": query]
        }
        return [:]
    }

    var parameterEncoding: ParameterEncoding { return URLEncoding.default }

    var interceptor: RequestInterceptor? { return nil }
}

// MARK: - Filters

extension DongManZhiJia {
    class GenreFilter: SinglePickFilter {
        var parameter: String { return value[0] }
    }

    class StatusFilter: SinglePickFilter {
        var parameter: String { return value[0] }
    }

    class TypeFilter: SinglePickFilter {
        var parameter: String { return value[0] }
    }

    class SortFilter: SinglePickFilter {
        var parameter: String { return value[0] }
    }

    class ReaderFilter: SinglePickFilter {
        var parameter: String { return value[0] }
    }
}
