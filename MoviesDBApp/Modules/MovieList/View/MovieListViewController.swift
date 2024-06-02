//
//  MovieListViewController.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 02/06/24.
//

import UIKit

class MovieListViewController: BaseViewController<MovieListViewModel> {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setupUI() {
        self.navigationItem.title = self.viewModel.title
        self.navigationItem.backButtonTitle = "Home"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionCell.nib, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
    }
    
    func saveMovie(movie: Movie) {
        if viewModel.detailType == .movie {
            let vm = AddToPlaylistViewModel(newMovie: movie)
            let vc = AddToPlaylistViewController.getInstance(vm)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell, indexPath.item < viewModel.movies.count else { return UICollectionViewCell() }
        let movie = viewModel.movies[indexPath.item]
        cell.configureCell(movie: movie)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpace = 16.0
        let width = (UIScreen.main.bounds.width - (32 + itemSpace)) / 3
        return CGSize(width: width, height: 272)
    }
}

extension MovieListViewController: MovieCellDelegate {
    func didSelectPlaylistOptions(cell: MovieCollectionCell) {
        if let indexPath = collectionView.indexPath(for: cell), indexPath.item < viewModel.movies.count {
            let movie = viewModel.movies[indexPath.item]
            saveMovie(movie: movie)
        }
    }
}

extension MovieListViewController {
    static func getInstance(_ viewModel: MovieListViewModel) -> MovieListViewController {
        let vc: MovieListViewController = .load()
        vc.viewModel = viewModel
        return vc
    }
}
