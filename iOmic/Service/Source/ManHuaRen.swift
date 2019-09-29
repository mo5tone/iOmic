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

class ManHuaRen {
    // MARK: - Static properties

    static let shared: ManHuaRen = .init(source: .manhuaren)

    // MARK: - Instance properties

    let source: Source

    // MARK: - Init

    private init(source: Source) {
        self.source = source
    }
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

// MARK: - RequestInterceptor

extension ManHuaRen: RequestInterceptor {
    private func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
        let request = urlRequest
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
            } catch let error as AFError {
                completion(.failure(error))
            } catch {
                completion(.success(request))
            }
        } else {
            completion(.success(request))
        }
    }
}

// MARK: - SourceProtocol

extension ManHuaRen: SourceProtocol {
    var name: String { return "漫画人" }

    var available: Bool {
        set { KeyValues.shared.set(souce: source, available: newValue) }
        get { return KeyValues.shared.isAvailable(source) }
    }

    var imageDownloadRequestModifier: ImageDownloadRequestModifier {
        return AnyModifier { request -> URLRequest? in
            var req = request
            req.addValue(#"{"le": "zh"}"#, forHTTPHeaderField: "X-Yq-Yqci")
            req.addValue("http://www.dm5.com/dm5api/", forHTTPHeaderField: "Referer")
            req.addValue("http://mangaapi.manhuaren.com/", forHTTPHeaderField: "clubReferer")
            return req
        }
    }

    func fetchBooks(where page: Int, query: String, sortedBy fetchingSort: Source.FetchingSort) -> Single<[Book]> {
        let convertible = Router.books(page, query, fetchingSort)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .map { [weak self] response -> [Book] in
                guard let self = self else { return [] }
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)
                    return (json["response", "result"].array ?? json["response", "mangas"].arrayValue).compactMap { ele -> Book? in
                        let bookId = ele["mangaId"].intValue
                        var book = Book(source: self.source, url: "/v1/manga/getDetail?mangaId=\(bookId)")
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

    func fetchBook(where book: Book) -> Single<Book> {
        let convertible = Router.book(book)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .map { response -> Book in
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)["response"]
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
                    detail.summary = json["mangaIntro"].string
                    return detail
                case let .failure(error):
                    throw error
                }
            }
    }

    func fetchChapters(where book: Book) -> Single<[Chapter]> {
        let convertible = Router.chapters(book)
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .map { response -> [Chapter] in
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)["response"]
                    var book = book
                    book.title = json["mangaName"].string
                    if let thumbnailUrl = json["mangaCoverimageUrl"].string, !thumbnailUrl.isEmpty {
                        book.thumbnailUrl = thumbnailUrl
                    } else if let thumbnailUrl = json["mangaPicimageUrl"].string, !thumbnailUrl.isEmpty {
                        book.thumbnailUrl = thumbnailUrl
                    } else if let thumbnailUrl = json["shareIcon"].string, !thumbnailUrl.isEmpty {
                        book.thumbnailUrl = thumbnailUrl
                    }
                    book.author = json["mangaAuthors"].arrayValue.compactMap({ $0.string }).joined(separator: ", ")
                    book.genre = json["mangaTheme"].string?.replacingOccurrences(of: " ", with: ", ")
                    book.status = Book.Status(mangaIsOver: json["mangaIsOver"].int)
                    book.summary = json["mangaIntro"].string
                    // chapters
                    var chapters: [Chapter] = []
                    ["mangaEpisode", "mangaWords", "mangaRolls"].forEach { type in
                        guard let array = json[type].array else { return }
                        array.forEach { ele in
                            guard let sectionId = ele["sectionId"].int else { return }
                            var chapter = Chapter(book: book, url: "/v1/manga/getRead?mangaSectionId=\(sectionId)")
                            chapter.name = "\(type == "mangaEpisode" ? "[番外] " : "")\(ele["sectionName"].stringValue)\(ele["sectionTitle"].stringValue == "" ? "" : ": \(ele["sectionTitle"].stringValue)")"
                            chapter.updateAt = ele["releaseTime"].string?.convert2Date(dateFormat: "yyyy-MM-dd")
                            chapter.chapterNumber = ele["sectionSort"].double ?? -1
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
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .map { response -> (Book, [Chapter]) in
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)["response"]
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
                    detail.summary = json["mangaIntro"].string
                    // chapters
                    var chapters: [Chapter] = []
                    ["mangaEpisode", "mangaWords", "mangaRolls"].forEach { type in
                        guard let array = json[type].array else { return }
                        array.forEach { ele in
                            guard let sectionId = ele["sectionId"].int else { return }
                            var chapter = Chapter(book: detail, url: "/v1/manga/getRead?mangaSectionId=\(sectionId)")
                            chapter.name = "\(type == "mangaEpisode" ? "[番外] " : "")\(ele["sectionName"].stringValue)\(ele["sectionTitle"].stringValue == "" ? "" : ": \(ele["sectionTitle"].stringValue)")"
                            chapter.updateAt = ele["releaseTime"].string?.convert2Date(dateFormat: "yyyy-MM-dd")
                            chapter.chapterNumber = ele["sectionSort"].double ?? -1
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
        return AF.request(convertible, interceptor: convertible.interceptor).validate().response()
            .map { response -> [Page] in
                switch response.result {
                case let .success(data):
                    guard let data = data else { throw Whoops.Networking.nilDataReponse(response) }
                    let json = try JSON(data: data)["response"]
                    guard let host = json["hostList"].array?.first?.string else { throw Whoops.Source.noPageContentToShow }
                    let array = json["mangaSectionImages"].arrayValue
                    let query = json["query"].stringValue
                    return array.enumerated().compactMap { offset, ele -> Page? in
                        var page = Page(chapter: chapter, index: offset)
                        page.imageUrl = "\(host)\(ele.stringValue)\(query)"
                        return page
                    }
                case let .failure(error):
                    throw error
                }
            }
    }
}

private extension ManHuaRen {
    enum Router: RequestConvertible {
        case books(Int, String, Source.FetchingSort)
        case book(Book)
        case chapters(Book)
        case pages(Chapter)

        // MARK: - RequestConvertible

        var baseURLString: URLConvertible { return "http://mangaapi.manhuaren.com" }

        var method: HTTPMethod { return .get }

        var path: String {
            switch self {
            case let .books(_, query, _):
                return query.isEmpty ? "/v2/manga/getCategoryMangas" : "/v1/search/getSearchManga"
            case let .book(book), let .chapters(book):
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

        var parameterEncoding: ParameterEncoding { return URLEncoding.default }

        var parameters: Parameters {
            var parameters: Parameters = ["gsm": "md5", "gft": "json", "gts": Date().convert2String(), "gak": "android_manhuaren2", "gat": "", "gaui": "191909801", "gui": "191909801", "gut": "0"]
            switch self {
            case let .books(page, query, fetchingSort):
                let pageSize = 20
                parameters["start"] = "\(page * pageSize)"
                parameters["limit"] = "\(pageSize)"
                if query.isEmpty {
                    parameters["sort"] = fetchingSort == .popularity ? "0" : "1"
                    parameters["subCategoryType"] = "0"
                    parameters["subCategoryId"] = "0"
                } else {
                    parameters["keywords"] = query
                }
            case let .book(book), let .chapters(book):
                URLComponents(string: book.url)?.queryItems?.forEach { parameters[$0.name] = $0.value }
            case let .pages(chapter):
                parameters["netType"] = "4"
                parameters["loadreal"] = "1"
                parameters["imageQuality"] = "2"
                URLComponents(string: chapter.url)?.queryItems?.forEach { parameters[$0.name] = $0.value }
            }
            return parameters
        }

        var interceptor: RequestInterceptor? { return ManHuaRen.shared }
    }
}
