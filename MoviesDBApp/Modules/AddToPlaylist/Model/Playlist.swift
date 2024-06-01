//
//  Playlist.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import Foundation

struct Playlist: Codable {
    var id = UUID()
    var name: String
    var movies: [Movie] = []
}
