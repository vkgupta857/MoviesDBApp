//
//  ViewController.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 31/05/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVM()
        setupUI()
    }
    
    func setupUI() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
//        moviesTableView.register(TrendingTableCell.nib, forCellWithReuseIdentifier: TrendingTableCell.reuseIdentifier)
        moviesTableView.register(TrendingTableCell.nib, forCellReuseIdentifier: TrendingTableCell.reuseIdentifier)
    }
    
    func setupVM() {
        self.viewModel.moviesListUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesTableView.reloadData()
            }
        }
        self.viewModel.getMovies()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableCell.reuseIdentifier) as? TrendingTableCell else { return UITableViewCell() }
        return cell
    }
}

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel.movies?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionCell.identifier, for: indexPath) as? MoviesCollectionCell, let model = self.viewModel.movies?[indexPath.item] else { return UICollectionViewCell() }
//        cell.backgroundColor = .red
//        cell.layer.cornerRadius = 8
//        cell.posterImageView.loadMoviePoster(imagePath: model.posterPath)
//        cell.titleLbl.text = model.title
//        //        print(indexPath.row, indexPath.item, self.viewModel.movies?.count)
//        if self.viewModel.page <= self.viewModel.totalPages && indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
//            self.viewModel.page += 1
//            self.viewModel.getTopRatedMovies(page: self.viewModel.page)
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.bounds.width - 16) / 2
//        return CGSize(width: width, height: 240)
//    }
//}
