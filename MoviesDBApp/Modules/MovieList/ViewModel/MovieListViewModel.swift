//
//  MovieListViewModel.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 02/06/24.
//

import Foundation

enum DetailType {
    case movie
    case playlist
}

class MovieListViewModel: BaseViewModel {
    var title: String
    var detailType: DetailType
    var movies: [Movie]
    
    init(title: String, detailType: DetailType, movies: [Movie]) {
        self.title = title
        self.detailType = detailType
        self.movies = movies
    }
}
