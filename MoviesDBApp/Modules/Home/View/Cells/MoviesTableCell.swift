//
//  MoviesTableCell.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit

protocol MoviesTableCellDelegate: AnyObject {
    func didTapAllBtn(cell: MoviesTableCell)
    func didSelectToggleBtn()
    func didSelectOption(movie: Movie)
}

class MoviesTableCell: UITableViewCell, Reusable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var toggleBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate: MoviesTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = .cyan.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        containerView.layer.borderWidth = 1
        
        allBtn.layer.cornerRadius = 8
        
        selectionStyle = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionCell.nib, forCellWithReuseIdentifier: MovieCollectionCell.reuseIdentifier)
    }
    
    @IBAction func toggleBtnAction(_ sender: Any) {
        self.collectionView.isHidden = !self.collectionView.isHidden
        self.toggleBtn.transform = CGAffineTransformRotate(self.toggleBtn.transform, .pi)
        delegate?.didSelectToggleBtn()
    }
    
    @IBAction func allBtnAction(_ sender: Any) {
        delegate?.didTapAllBtn(cell: self)
    }
}

extension MoviesTableCell: MovieCellDelegate {
    func didSelectPlaylistOptions(cell: MovieCollectionCell) {
        if let indexPath = collectionView.indexPath(for: cell), indexPath.item < movies?.count ?? 0, let movie = movies?[indexPath.item] {
            delegate?.didSelectOption(movie: movie)
        }
    }
}

extension MoviesTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.reuseIdentifier, for: indexPath) as? MovieCollectionCell, indexPath.item < movies?.count ?? 0, let movie = movies?[indexPath.item] else { return UICollectionViewCell() }
        cell.configureCell(movie: movie)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 32) / 3
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}
