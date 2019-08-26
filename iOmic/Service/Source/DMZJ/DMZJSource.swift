//
//  DMZJSource.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation

class DMZJSource: NSObject, OnlineSourceProtocol {
    // MARK: - Static

    static let shared = DMZJSource()

    // MARK: - OnlineSourceProtocol

    var identifier: SourceIdentifier { return .dmzj }

    var name: String { return "动漫之家" }

    func fetchBooksWhere(page: Int, query: String, filters: [Filter]) -> [Book] {
        AF.request(Router.booksWhere(page: page, query: query, filters: filters))
            .validate()
        return []
    }

    func fetchChaptersIn(book _: Book) -> (book: Book, chapters: [Chapter]) {
        return (Book(), [])
    }

    func fetchPagesIn(chapter _: Chapter) -> (chapter: Chapter, pages: [Page]) {
        return (Chapter(), [])
    }

    // MARK: - Props.

    // MARK: - Private

    private override init() {
        super.init()
    }

    // MARK: - Public
}

// MARK: - DMZJSource.Router

extension DMZJSource {
    private enum Router: URLRequestConvertible {
        case booksWhere(page: Int, query: String, filters: [Filter])
        case chaptersIn(book: Book)
        case pagesIn(chapter: Chapter)

        var baseURLString: String {
            if case let .booksWhere(_, query, _) = self, !query.isEmpty {
                return "http://s.acg.dmzj.com/comicsum/search.php"
            }
            return "http://v2.api.dmzj.com"
        }

        var headers: HTTPHeaders {
            return HTTPHeaders()
        }

        var method: HTTPMethod { return .get }

        var path: String {
            switch self {
            case let .booksWhere(page, query, filters):
                var types = filters.filter { !($0 is SortFilter) }.compactMap { $0.value.isEmpty ? nil : $0.value }.joined(separator: "-")
                if types.isEmpty { types = "0" }
                var order = filters.filter { $0 is SortFilter }.compactMap { $0.value.isEmpty ? nil : $0.value }.joined()
                if order.isEmpty { order = "0" }
                if query.isEmpty {
                    return "/classify/\(types)/\(order)/\(page).json"
                } else {
                    return ""
                }
            case let .chaptersIn(book):
                return book.url
            case let .pagesIn(chapter):
                return chapter.url
            }
        }

        var parameters: Parameters {
            if case let .booksWhere(_, query, _) = self, !query.isEmpty {
                return ["s": query]
            }
            return [:]
        }

        // MARK: - URLRequestConvertible

        func asURLRequest() throws -> URLRequest {
            let url = try baseURLString.asURL()
            let request = try URLRequest(url: url.appendingPathComponent(path), method: method, headers: headers)
            return try URLEncoding.default.encode(request, with: parameters)
        }
    }
}

// MARK: - DMZJSource Filters

extension DMZJSource {
    private class GenreFilter: Filter {
        init() {
            super.init(title: "分类", keyValues: [("全部", ""), ("冒险", "4"), ("百合", "3243"), ("生活", "3242"), ("四格", "17"), ("伪娘", "3244"), ("悬疑", "3245"), ("后宫", "3249"), ("热血", "3248"), ("耽美", "3246"), ("其他", "16"), ("恐怖", "14"), ("科幻", "7"), ("格斗", "6"), ("欢乐向", "5"), ("爱情", "8"), ("侦探", "9"), ("校园", "13"), ("神鬼", "12"), ("魔法", "11"), ("竞技", "10"), ("历史", "3250"), ("战争", "3251"), ("魔幻", "5806"), ("扶她", "5345"), ("东方", "5077"), ("奇幻", "5848"), ("轻小说", "6316"), ("仙侠", "7900"), ("搞笑", "7568"), ("颜艺", "6437"), ("性转换", "4518"), ("高清单行", "4459"), ("治愈", "3254"), ("宅系", "3253"), ("萌系", "3252"), ("励志", "3255"), ("节操", "6219"), ("职场", "3328"), ("西方魔幻", "3365"), ("音乐舞蹈", "3326"), ("机战", "3325")])
        }
    }

    private class StatusFilter: Filter {
        init() {
            super.init(title: "连载", keyValues: [("全部", ""), ("连载", "2309"), ("完结", "2310")])
        }
    }

    private class TypeFilter: Filter {
        init() {
            super.init(title: "地区", keyValues: [("全部", ""), ("日本", "2304"), ("韩国", "2305"), ("欧美", "2306"), ("港台", "2307"), ("内地", "2308"), ("其他", "8453")])
        }
    }

    private class SortFilter: Filter {
        init() {
            super.init(title: "排序", keyValues: [("人气", "0"), ("更新", "1")])
        }
    }

    private class ReaderFilter: Filter {
        init() {
            super.init(title: "读者", keyValues: [("全部", ""), ("少年", "3262"), ("少女", "3263"), ("青年", "3264")])
        }
    }
}
