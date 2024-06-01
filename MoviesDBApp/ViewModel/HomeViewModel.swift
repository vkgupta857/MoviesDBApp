//
//  HomeViewModel.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 31/05/24.
//

import Foundation

enum ViewModelState {
    case loading
    case loaded
}

enum CategoryType {
    case trending
    case nowPlaying
    case popular
    case topRated
    
    var title: String {
        switch self {
        case .trending:
            return "Trending"
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        }
    }
}

class HomeViewModel {
    var categories: [CategoryType] = [.trending, .nowPlaying, .popular, .topRated]
    var state: ViewModelState = .loading {
        didSet {
            apiStateUpdated?()
        }
    }
    
    var trendingWeekMovies: [Movie] = []
    var trendingTodayMovies: [Movie] = []
    var nowPlayingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    
    var errorMessage: String?
    var apiError: APIError?
    
    var apiStateUpdated: (() -> Void)?
    var updatedErrorMessage: (() -> Void)?
    
    var dispatchGroup = DispatchGroup()
    
    func setupData() {
        self.state = .loading
        getTrendingWeekMovies()
        getTrendingTodayMovies()
        getNowPlayingMovies()
        getPopularMovies()
        getTopRatedMovies()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if self?.apiError == .networkError {
                self?.errorMessage = APIError.networkError.description
            } else {
                self?.errorMessage = nil
            }
            self?.state = .loaded
        }
    }
    
    private func getTrendingTodayMovies() {
        dispatchGroup.enter()
        NetworkManager.shared.getRequest(endpoint: .trendingTodayMovies, responseModel: MoviesListModel.self) { [weak self] status in
            switch status {
            case .success(let response):
                self?.trendingTodayMovies = response.results ?? []
            case .failure(let error):
                self?.apiError = error
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func getTrendingWeekMovies() {
        dispatchGroup.enter()
        NetworkManager.shared.getRequest(endpoint: .trendingWeekMovies, responseModel: MoviesListModel.self) { [weak self] status in
            switch status {
            case .success(let response):
                self?.trendingWeekMovies = response.results ?? []
            case .failure(let error):
                self?.apiError = error
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func getTopRatedMovies() {
        dispatchGroup.enter()
        NetworkManager.shared.getRequest(endpoint: .topRatedMovies, responseModel: MoviesListModel.self) { [weak self] status in
            switch status {
            case .success(let response):
                self?.topRatedMovies = response.results ?? []
            case .failure(let error):
                self?.apiError = error
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func getPopularMovies() {
        dispatchGroup.enter()
        NetworkManager.shared.getRequest(endpoint: .popularMovies, responseModel: MoviesListModel.self) { [weak self] status in
            switch status {
            case .success(let response):
                self?.popularMovies = response.results ?? []
            case .failure(let error):
                self?.apiError = error
            }
            self?.dispatchGroup.leave()
        }
    }
    
    private func getNowPlayingMovies() {
        dispatchGroup.enter()
        NetworkManager.shared.getRequest(endpoint: .nowPlayingMovies, responseModel: MoviesListModel.self) { [weak self] status in
            switch status {
            case .success(let response):
                self?.nowPlayingMovies = response.results ?? []
            case .failure(let error):
                self?.apiError = error
            }
            self?.dispatchGroup.leave()
        }
    }
}
