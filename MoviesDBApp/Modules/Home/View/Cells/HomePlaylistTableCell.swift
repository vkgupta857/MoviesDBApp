//
//  HomePlaylistTableCell.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit

protocol HomePlaylistTableCellDelegate: AnyObject {
    func didSelectItem(at: IndexPath, playlist: Playlist)
}

class HomePlaylistTableCell: UITableViewCell, Reusable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var playlists: [Playlist]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate: HomePlaylistTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = .cyan.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        containerView.layer.borderWidth = 1
        
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionCell.nib, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
    }
}

extension HomePlaylistTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell, indexPath.item < playlists?.count ?? 0, let playlist = playlists?[indexPath.item] else { return UICollectionViewCell() }
        cell.configureCell(playlist: playlist)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) / 3
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let playlist = playlists?[indexPath.item] {
            delegate?.didSelectItem(at: indexPath, playlist: playlist)
        }
    }
}
