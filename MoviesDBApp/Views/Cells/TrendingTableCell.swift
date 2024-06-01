//
//  TrendingTableCell.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 31/05/24.
//

import UIKit

class TrendingTableCell: UITableViewCell, Reusable {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var trendingSegment: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndexMovies: [Movie]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var trendingTodayMovies: [Movie] = []
    private var trendingWeekMovies: [Movie] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionCell.nib, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
        trendingSegment.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
    }
    
    @objc func didChangeSegment(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            self.selectedIndexMovies = trendingTodayMovies
        case 1:
            self.selectedIndexMovies = trendingWeekMovies
        default:
            break
        }
    }
    
    func configureCell(todayMovies: [Movie], weekMovies: [Movie]) {
        trendingWeekMovies = weekMovies
        trendingTodayMovies = todayMovies
        
        switch trendingSegment.selectedSegmentIndex {
        case 0:
            self.selectedIndexMovies = trendingTodayMovies
        case 1:
            self.selectedIndexMovies = trendingWeekMovies
        default:
            break
        }
        
        if self.selectedIndexMovies?.isEmpty == false {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
        }
    }
}

extension TrendingTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedIndexMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell, indexPath.item < selectedIndexMovies?.count ?? 0, let movie = selectedIndexMovies?[indexPath.item] else { return UICollectionViewCell() }
        cell.configureCell(movie: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 32) / 3
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
