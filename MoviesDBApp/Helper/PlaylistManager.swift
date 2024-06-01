//
//  PlaylistManager.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import Foundation

struct PlaylistManager {
    static let shared = PlaylistManager()
    
    private init() { }
    
    func getPlaylists() -> [Playlist] {
        return UserDefaults.playlists
    }
    
    func addMovie(movie: Movie, in playlist: Playlist) {
        var playlists = UserDefaults.playlists
        
        (0..<playlists.count).forEach { idx in
            if playlists[idx].id == playlist.id {
                playlists[idx].movies.append(movie)
            }
        }
        
        UserDefaults.playlists = playlists
    }
    
    func createPlaylistAndAdd(with name: String, movie: Movie) {
        var playlists = UserDefaults.playlists
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty, playlists.filter({ $0.name == trimmedName }).isEmpty else { return }
        var newPlaylist = Playlist(name: trimmedName)
        newPlaylist.movies = [movie]
        
        playlists.append(newPlaylist)
        UserDefaults.playlists = playlists
    }
}
