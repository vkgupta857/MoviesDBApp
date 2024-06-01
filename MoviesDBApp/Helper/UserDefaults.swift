//
//  UserDefaults.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import Foundation

enum UserDefaultKeys: String {
    case playlists
}

extension UserDefaults {
    static var playlists: [Playlist] {
        get {
            if let data = UserDefaults.standard.object(forKey: UserDefaultKeys.playlists.rawValue) as? Data,
               let playlists = try? JSONDecoder().decode([Playlist].self, from: data) {
                 return playlists
            }
            return []
        }
        
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: UserDefaultKeys.playlists.rawValue)
            }
        }
    }
}
