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
    
    var movies: [Movie]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionCell.nib, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
    }
}

extension TrendingTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell, indexPath.item < movies?.count ?? 0, let movie = movies?[indexPath.item] else { return UICollectionViewCell() }
        cell.configureCell(movie: movie)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 32) / 3
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
