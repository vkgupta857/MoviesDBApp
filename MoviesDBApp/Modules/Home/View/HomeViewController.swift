//
//  ViewController.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 31/05/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVM()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupUI() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.estimatedRowHeight = UITableView.automaticDimension
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.register(TrendingTableCell.nib, forCellReuseIdentifier: TrendingTableCell.reuseIdentifier)
        moviesTableView.register(MoviesTableCell.nib, forCellReuseIdentifier: MoviesTableCell.reuseIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        moviesTableView.addSubview(refreshControl)
    }
    
    func setupVM() {
        viewModel.apiStateUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.activityIndicator.isHidden = self?.viewModel.state == .loaded
                self?.errorView.isHidden = self?.viewModel.errorMessage == nil
                self?.updateError()
                self?.moviesTableView.isHidden = self?.viewModel.errorMessage != nil
                self?.moviesTableView.reloadData()
            }
        }
        
        self.viewModel.setupData()
    }
    
    func updateError() {
        for view in errorView.subviews where type(of: view) == UILabel.self {
            if let label = view as? UILabel {
                label.text = self.viewModel.errorMessage
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.setupData()
    }
    
    func saveMovie(movie: Movie) {
        let vm = AddToPlaylistViewModel(newMovie: movie)
        let vc = AddToPlaylistViewController.getInstance(vm)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.categories.count else { return UITableViewCell() }
        
        let category = viewModel.categories[indexPath.row]
        switch category {
        case .trending:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableCell.reuseIdentifier) as? TrendingTableCell else { return UITableViewCell() }
            cell.configureCell(todayMovies: self.viewModel.trendingTodayMovies, weekMovies: self.viewModel.trendingWeekMovies)
            cell.titleLbl.text = category.title
            cell.delegate = self
            return cell
        case .nowPlaying:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableCell.reuseIdentifier) as? MoviesTableCell else { return UITableViewCell() }
            cell.movies = self.viewModel.nowPlayingMovies
            cell.titleLbl.text = category.title
            cell.delegate = self
            return cell
        case .popular:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableCell.reuseIdentifier) as? MoviesTableCell else { return UITableViewCell() }
            cell.titleLbl.text = category.title
            cell.movies = self.viewModel.popularMovies
            cell.delegate = self
            return cell
        case .topRated:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableCell.reuseIdentifier) as? MoviesTableCell else { return UITableViewCell() }
            cell.titleLbl.text = category.title
            cell.movies = self.viewModel.topRatedMovies
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = viewModel.categories[indexPath.row]
        switch category {
        case .trending:
            return viewModel.trendingTodayMovies.isEmpty ? 0 : UITableView.automaticDimension
        case .nowPlaying:
            return viewModel.nowPlayingMovies.isEmpty ? 0 : UITableView.automaticDimension
        case .popular:
            return viewModel.popularMovies.isEmpty ? 0 : UITableView.automaticDimension
        case .topRated:
            return viewModel.topRatedMovies.isEmpty ? 0 : UITableView.automaticDimension
        }
    }
}

extension HomeViewController: TrendingTableCellDelegate {
    func didSelectOptions(movie: Movie) {
        saveMovie(movie: movie)
    }
}

extension HomeViewController: MoviesTableCellDelegate {
    func didSelectOption(movie: Movie) {
        saveMovie(movie: movie)
    }
    
    func didTapAllBtn(cell: MoviesTableCell) {
        if let indexPath = moviesTableView.indexPath(for: cell) {
            var movies: [Movie]
            let category = self.viewModel.categories[indexPath.row]
            switch category {
            case .nowPlaying:
                movies = viewModel.nowPlayingMovies
            case .topRated:
                movies = viewModel.topRatedMovies
            case .popular:
                movies = viewModel.popularMovies
            case .trending:
                movies = viewModel.trendingTodayMovies
            }
            let vc = MovieListViewController.getInstance(MovieListViewModel(title: category.title, detailType: .playlist, movies: movies))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didSelectToggleBtn() {
        self.moviesTableView.beginUpdates()
        self.moviesTableView.setNeedsDisplay()
        self.moviesTableView.endUpdates()
    }
}
