//
//  AddToPlaylistViewModel.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import Foundation

class AddToPlaylistViewModel: BaseViewModel {
    var newMovie: Movie?
    var playlists: [Playlist] = []
    
    init(newMovie: Movie? = nil) {
        self.newMovie = newMovie
        super.init()
        loadPlaylists()
    }
    
    func loadPlaylists() {
        playlists = PlaylistManager.shared.getPlaylists()
    }
}
