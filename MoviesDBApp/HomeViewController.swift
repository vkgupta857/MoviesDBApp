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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableCell.reuseIdentifier) as? TrendingTableCell else { return UITableViewCell() }
        cell.movies = self.viewModel.movies
        return cell
    }
}
