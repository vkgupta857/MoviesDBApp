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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension TrendingTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
