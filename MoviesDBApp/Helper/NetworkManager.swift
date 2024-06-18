//
//  NetworkManager.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 31/05/24.
//

import Foundation

enum EndPoint: String {
    case topRatedMovies = "movie/top_rated"
    case popularMovies = "movie/popular"
    case nowPlayingMovies = "movie/now_playing"
    case trendingTodayMovies = "trending/movie/day"
    case trendingWeekMovies = "trending/movie/week"
    
    var title: String {
        switch self {
        case .topRatedMovies:
            return "Top rated movies"
        case .popularMovies:
            return "Top popular"
        case .nowPlayingMovies:
            return "Now Playing"
        case .trendingTodayMovies:
            return "Trending"
        case .trendingWeekMovies:
            return "Trending"
        }
    }
}

enum APIError: Error {
    case decodingError
    case networkError
    
    var description: String {
        switch self {
        case .decodingError:
            "Decoding Error"
        case .networkError:
            "Network Error"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    let baseUrl = "https://api.themoviedb.org/3/"
    
    let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    
    let apiKey = ""
    
    func getRequest<T: Decodable>(endpoint: EndPoint, method: HTTPMethod = .get, queryParams: [String: Any]? = nil, responseModel: T.Type, completion: ((Swift.Result<T, APIError>) -> Void)?) {
        
        guard let url = URL(string: baseUrl + endpoint.rawValue), var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion?(.failure(.networkError))
            return
        }

        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "api_key", value: apiKey),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        
        if let url = components.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.timeoutInterval = 90
            request.allHTTPHeaderFields = ["accept": "application/json"]
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil, let data {
                    do {
                        let json = try JSONDecoder().decode(T.self, from: data)
                        completion?(.success(json))
                    } catch let error {
                        print(error.localizedDescription)
                        completion?(.failure(.decodingError))
                    }
                } else {
                    print(error?.localizedDescription ?? "")
                    completion?(.failure(.networkError))
                }
            }.resume()
        } else {
            completion?(.failure(.networkError))
        }
    }
}
