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

    func fetchBooksWhere(page _: Int, query _: String, filters _: [Filter<AnyHashable>]) -> [Book] {
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
        case booksWhere(page: Int, query: String, filters: [Filter<AnyHashable>])
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
                if query.isEmpty {
                    return "/classify/$params/$order/\(page).json"
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

        func asURLRequest() throws -> URLRequest {
            let url = try baseURLString.asURL()
            let request = try URLRequest(url: url.appendingPathComponent(path), method: method, headers: headers)
            return try URLEncoding.default.encode(request, with: parameters)
        }
    }
}

extension DMZJSource {
    private class 分类: Filter<String> {
        static let 全部 = 分类(name: "全部", state: "")
        static let 冒险 = 分类(name: "冒险", state: "4")
        static let 百合 = 分类(name: "百合", state: "3243")
        static let 生活 = 分类(name: "生活", state: "3242")
        static let 四格 = 分类(name: "四格", state: "17")
        static let 伪娘 = 分类(name: "伪娘", state: "3244")
        static let 悬疑 = 分类(name: "悬疑", state: "3245")
        static let 后宫 = 分类(name: "后宫", state: "3249")
        static let 热血 = 分类(name: "热血", state: "3248")
        static let 耽美 = 分类(name: "耽美", state: "3246")
        static let 其他 = 分类(name: "其他", state: "16")
        static let 恐怖 = 分类(name: "恐怖", state: "14")
        static let 科幻 = 分类(name: "科幻", state: "7")
        static let 格斗 = 分类(name: "格斗", state: "6")
        static let 欢乐向 = 分类(name: "欢乐向", state: "5")
        static let 爱情 = 分类(name: "爱情", state: "8")
        static let 侦探 = 分类(name: "侦探", state: "9")
        static let 校园 = 分类(name: "校园", state: "13")
        static let 神鬼 = 分类(name: "神鬼", state: "12")
        static let 魔法 = 分类(name: "魔法", state: "11")
        static let 竞技 = 分类(name: "竞技", state: "10")
        static let 历史 = 分类(name: "历史", state: "3250")
        static let 战争 = 分类(name: "战争", state: "3251")
        static let 魔幻 = 分类(name: "魔幻", state: "5806")
        static let 扶她 = 分类(name: "扶她", state: "5345")
        static let 东方 = 分类(name: "东方", state: "5077")
        static let 奇幻 = 分类(name: "奇幻", state: "5848")
        static let 轻小说 = 分类(name: "轻小说", state: "6316")
        static let 仙侠 = 分类(name: "仙侠", state: "7900")
        static let 搞笑 = 分类(name: "搞笑", state: "7568")
        static let 颜艺 = 分类(name: "颜艺", state: "6437")
        static let 性转换 = 分类(name: "性转换", state: "4518")
        static let 高清单行 = 分类(name: "高清单行", state: "4459")
        static let 治愈 = 分类(name: "治愈", state: "3254")
        static let 宅系 = 分类(name: "宅系", state: "3253")
        static let 萌系 = 分类(name: "萌系", state: "3252")
        static let 励志 = 分类(name: "励志", state: "3255")
        static let 节操 = 分类(name: "节操", state: "6219")
        static let 职场 = 分类(name: "职场", state: "3328")
        static let 西方魔幻 = 分类(name: "西方魔幻", state: "3365")
        static let 音乐舞蹈 = 分类(name: "音乐舞蹈", state: "3326")
        static let 机战 = 分类(name: "机战", state: "3325")

        static let values: [分类] = [全部, 冒险, 百合, 生活, 四格, 伪娘, 悬疑, 后宫, 热血, 耽美, 其他, 恐怖, 科幻, 格斗, 欢乐向, 爱情, 侦探, 校园, 神鬼, 魔法, 竞技, 历史, 战争, 魔幻, 扶她, 东方, 奇幻, 轻小说, 仙侠, 搞笑, 颜艺, 性转换, 高清单行, 治愈, 宅系, 萌系, 励志, 节操, 职场, 西方魔幻, 音乐舞蹈, 机战]
    }
}
