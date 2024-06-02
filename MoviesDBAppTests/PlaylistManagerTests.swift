//
//  PlaylistManagerTests.swift
//  MoviesDBAppTests
//
//  Created by Vinod Gupta on 02/06/24.
//

import XCTest
@testable import MoviesDBApp

final class PlaylistManagerTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserDefaults.playlists = []
    }

    func testNewPlaylistCreation() throws {
        let playlistName = "Playlist1"
        let movieName = "Sample movie"
        let movie = Movie(title: movieName)
        PlaylistManager.shared.createPlaylistAndAdd(with: playlistName, movie: movie)
        
        let playlists = PlaylistManager.shared.getPlaylists()
        XCTAssertTrue(playlists.count == 1)
        
        guard let playlist = playlists.first else {
            XCTExpectFailure("Playlist not created")
            return
        }
        XCTAssertTrue(playlist.name == playlistName)
        
        if let testMovie = playlist.movies.first {
            XCTAssertTrue(testMovie.title == movieName)
        } else {
            XCTFail("Playlist not created")
        }
    }
    
    func testAdditionInExistingPlaylist() throws {
        let playlistName = "Playlist1"
        let movieName = "Sample movie"
        let movie = Movie(title: movieName)
        PlaylistManager.shared.createPlaylistAndAdd(with: playlistName, movie: movie)
        
        let playlists = PlaylistManager.shared.getPlaylists()
        
        XCTAssertTrue(playlists.count == 1)
        
        guard let playlist = playlists.first(where: { $0.name == playlistName }) else {
            XCTExpectFailure("Playlist not created")
            return
        }
        XCTAssertTrue(playlist.name == playlistName)
        
        PlaylistManager.shared.addMovie(movie: movie, in: playlist)
        
        if let testMovie = playlist.movies.first(where: { $0.title == movie.title }) {
            XCTAssertTrue(testMovie.title == movieName)
        } else {
            XCTFail("Playlist not created")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
