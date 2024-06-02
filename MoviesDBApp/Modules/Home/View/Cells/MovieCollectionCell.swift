//
//  MovieCollectionCell.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit
import SDWebImage

protocol MovieCellDelegate: AnyObject {
    func didSelectPlaylistOptions(cell: MovieCollectionCell)
}

class MovieCollectionCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingContainerView: UIView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingBar: CircularProgressView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    
    weak var delegate: MovieCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 8
        ratingContainerView.layer.cornerRadius = ratingContainerView.frame.height / 2
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        self.contentView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func longPressed(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.didSelectPlaylistOptions(cell: self)
        }
    }
    
    func configureCell(movie: Movie) {
        if let posterPath = movie.posterPath, let urlString = (NetworkManager.shared.imageBaseUrl + posterPath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        }
        if let voteAverage = movie.voteAverage {
            var ratingTintColor = UIColor.systemGreen
            if voteAverage < 7 {
                ratingTintColor = .systemYellow
            }
            ratingBar.trackColor = ratingTintColor.withAlphaComponent(0.2)
            ratingBar.progressColor = ratingTintColor
            ratingBar.setProgressWithAnimation(duration: 0, value: voteAverage / 10)
            ratingLbl.text = String(format: "%.2f", voteAverage)
        } else {
            ratingContainerView.isHidden = true
        }
        
        titleLbl.text = movie.title
        yearLbl.text = "\(movie.releaseDate?.getDate()?.getYear() ?? 0)"
    }
    
    func configureCell(playlist: Playlist) {
        imageView.image = UIImage(systemName: "play.square.stack")
        ratingContainerView.isHidden = true
        titleLbl.text = playlist.name
        titleLbl.textAlignment = .center
        yearLbl.isHidden = true
    }
}
