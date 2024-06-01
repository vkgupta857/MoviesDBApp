//
//  HomeViewModel.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 31/05/24.
//

import Foundation

class HomeViewModel {
    var selectedEndPoint: EndPoint = .topRatedMovies {
        didSet {
            self.page = 1
            self.movies = []
            getMovies(page: page)
        }
    }
    
    var movies: [Movie]? {
        didSet {
            moviesListUpdated?()
        }
    }
    
    var moviesListUpdated: (()->())?
    
    var page: Int = 1
    var numberOfResults = 20
    var totalResults: Int = 0
    var totalPages: Int = 0
    
    init() {
        self.movies = []
        self.page = 1
    }
    
    func getMovies(page: Int = 1) {
        switch self.selectedEndPoint {
        case .topRatedMovies:
            getTopRatedMovies(page: page)
        case .popularMovies:
            getPopular(page: page)
        default:
            break
        }
    }
    
    func getTopRatedMovies(page: Int) {
        NetworkManager.shared.getRequest(endpoint: .topRatedMovies, queryParams: ["page": page], responseModel: MoviesListModel.self) { status in
            switch status {
            case .success(let response):
//                print(response)
                self.movies?.append(contentsOf: response.results ?? [])
                self.totalResults = response.totalResults ?? 0
                self.totalPages = response.totalPages ?? 0
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPopular(page: Int) {
        NetworkManager.shared.getRequest(endpoint: .popularMovies, queryParams: ["page": page], responseModel: MoviesListModel.self) { status in
            switch status {
            case .success(let response):
                print(response)
                self.movies?.append(contentsOf: response.results ?? [])
                self.totalResults = response.totalResults ?? 0
                self.totalPages = response.totalPages ?? 0
            case .failure(let error):
                print(error)
            }
        }
    }
}
