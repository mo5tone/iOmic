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

class DongManZhiJia {
    // MARK: - Static properties

    static let shared: DongManZhiJia = .init(source: .dongmanzhijia)

    // MARK: - Instance properties

    let source: Source

    // MARK: - Init

    private init(source: Source) {
        self.source = source
    }
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

// MARK: - SourceProtocol

extension DongManZhiJia: SourceProtocol {
    var name: String { return "动漫之家" }

    var available: Bool {
        set { KeyValues.shared.set(souce: source, available: newValue) }
        get { return KeyValues.shared.isAvailable(source) }
    }

    var imageDownloadRequestModifier: ImageDownloadRequestModifier {
        return AnyModifier { request -> URLRequest? in
            var req = request
            req.addValue("http://www.dmzj.com/", forHTTPHeaderField: "Referer")
            return req
        }
    }

    func fetchBooks(where page: Int, query: String, sortedBy fetchingSort: Source.FetchingSort) -> Single<[Book]> {
        func jsonParser(json: JSON) -> [Book] {
            return json.arrayValue.compactMap { json -> Book? in
                guard let bookId = json["id"].int else { return nil }
                var book = Book(source: source, url: "/comic/\(bookId).json")
                book.title = json["title"].string
                book.author = json["authors"].string
                book.thumbnailUrl = json["cover"].string?.fixScheme()
                book.status = Book.Status(string: json["status"].string)
                book.summary = json["description"].string
                return book
            }
        }
        func stringParser(string: String) throws -> [Book] {
            let regEx = try NSRegularExpression(pattern: #"g_search_data = (.*);"#)
            let results = regEx.matches(in: string, range: NSRange(string.startIndex..., in: string))
            guard let result = results.first, result.numberOfRanges > 1, let range = Range(result.range(at: 1), in: string) else { return [] }
            return JSON(parseJSON: String(string[range])).arrayValue.compactMap { json -> Book? in
                guard let bookId = json["id"].int else { return nil }
                var book = Book(source: source, url: "/comic/\(bookId).json")
                book.title = json["comic_name"].string
                book.author = json["comic_author"].string
                book.thumbnailUrl = json["cover"].string?.fixScheme()
                book.status = json["status"].string?.contains("完") ?? false ? .completed : .ongoing
                book.summary = json["description"].string
                return book
            }
        }
        let convertible = Router.books(page, query, fetchingSort)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().responseData()
            .map { response -> [Book] in
                switch response.result {
                case let .success(data):
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

    func fetchBook(where book: Book) -> Single<Book> {
        let convertible = Router.chapters(book)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().responseData()
            .map { response -> Book in
                switch response.result {
                case let .success(data):
                    let json = try JSON(data: data)
                    var detail = book
                    detail.title = json["title"].string
                    detail.thumbnailUrl = json["cover"].string?.fixScheme()
                    detail.author = json["authors"].arrayValue.compactMap { $0["tag_name"].string }.joined(separator: ", ")
                    detail.genre = json["types"].arrayValue.compactMap { $0["tag_name"].string }.joined(separator: ", ")
                    detail.status = Book.Status(string: "\(json["status"][0]["tag_id"].intValue)")
                    detail.summary = json["description"].string
                    return detail
                case let .failure(error):
                    throw error
                }
            }
    }

    func fetchChapters(where book: Book) -> Single<[Chapter]> {
        let convertible = Router.chapters(book)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().responseData()
            .map { response -> [Chapter] in
                switch response.result {
                case let .success(data):
                    let json = try JSON(data: data)
                    var chapters: [Chapter] = []
                    let bookId = json["id"].intValue
                    json["chapters"].arrayValue.forEach { item in
                        let prefix = item["title"].stringValue
                        item["data"].arrayValue.forEach { item1 in
                            let chapterId = item1["chapter_id"].intValue
                            var chapter = Chapter(book: book, url: "/chapter/\(bookId)/\(chapterId).json")
                            let chapterTitle = item1["chapter_title"].stringValue
                            chapter.name = "[\(prefix)]\(chapterTitle)"
                            chapter.updateAt = Date(timeIntervalSince1970: item1["updatetime"].doubleValue)
                            chapters.append(chapter)
                        }
                    }
                    return chapters
                case let .failure(error):
                    throw error
                }
            }
    }

    func fetchBookAndChapters(where book: Book) -> Single<(Book, [Chapter])> {
        let convertible = Router.chapters(book)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().responseData()
            .map { response -> (Book, [Chapter]) in
                switch response.result {
                case let .success(data):
                    let json = try JSON(data: data)
                    var detail = book
                    detail.title = json["title"].string
                    detail.thumbnailUrl = json["cover"].string?.fixScheme()
                    detail.author = json["authors"].arrayValue.compactMap { $0["tag_name"].string }.joined(separator: ", ")
                    detail.genre = json["types"].arrayValue.compactMap { $0["tag_name"].string }.joined(separator: ", ")
                    detail.status = Book.Status(string: "\(json["status"][0]["tag_id"].intValue)")
                    detail.summary = json["description"].string
                    var chapters: [Chapter] = []
                    let bookId = json["id"].intValue
                    json["chapters"].arrayValue.forEach { item in
                        let prefix = item["title"].stringValue
                        item["data"].arrayValue.forEach { item1 in
                            let chapterId = item1["chapter_id"].intValue
                            var chapter = Chapter(book: detail, url: "/chapter/\(bookId)/\(chapterId).json")
                            let chapterTitle = item1["chapter_title"].stringValue
                            chapter.name = "[\(prefix)]\(chapterTitle)"
                            chapter.updateAt = Date(timeIntervalSince1970: item1["updatetime"].doubleValue)
                            chapters.append(chapter)
                        }
                    }
                    return (detail, chapters)
                case let .failure(error):
                    throw error
                }
            }
    }

    func fetchPages(where chapter: Chapter) -> Single<[Page]> {
        let convertible = Router.pages(chapter)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().responseData()
            .map { response -> [Page] in
                switch response.result {
                case let .success(data):
                    let json = try JSON(data: data)
                    var pages = [Page]()
                    json["page_url"].arrayValue.enumerated().forEach { offset, element in
                        var page = Page(chapter: chapter, index: offset)
                        page.imageUrl = element.string
                        pages.append(page)
                    }
                    return pages
                case let .failure(error):
                    throw error
                }
            }
    }
}

private extension DongManZhiJia {
    enum Router: RequestConvertible {
        case books(Int, String, Source.FetchingSort)
        case book(Book)
        case chapters(Book)
        case pages(Chapter)

        // MARK: - RequestConvertible

        var baseURLString: URLConvertible {
            if case let .books(_, query, _) = self, !query.isEmpty {
                return "http://s.acg.dmzj.com/comicsum/search.php"
            }
            return "http://v2.api.dmzj.com"
        }

        var method: HTTPMethod { return .get }

        var path: String {
            switch self {
            case let .books(page, query, fetchingSort):
                if query.isEmpty {
                    return "/classify/0/\(fetchingSort == .popularity ? "0" : "1")/\(page).json"
                } else {
                    return ""
                }
            case let .book(book), let .chapters(book):
                return URLComponents(string: book.url)?.path ?? book.url
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

        var parameterEncoding: ParameterEncoding { return URLEncoding.default }

        var parameters: Parameters {
            var parameters: Parameters = [:]
            switch self {
            case let .books(_, query, _):
                parameters["s"] = query
            case let .book(book), let .chapters(book):
                URLComponents(string: book.url)?.queryItems?.forEach { parameters[$0.name] = $0.value }
            case .pages:
                break
            }
            return parameters
        }

        var interceptor: RequestInterceptor? { return nil }
    }
}
