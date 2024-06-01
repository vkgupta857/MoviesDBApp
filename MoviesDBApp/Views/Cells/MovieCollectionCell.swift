//
//  MovieCollectionCell.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit
import SDWebImage

class MovieCollectionCell: UICollectionViewCell, Reusable {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.layer.cornerRadius = 8
    }
    
    func configureCell(movie: Movie) {
        if let posterPath = movie.posterPath, let urlString = (NetworkManager.shared.imageBaseUrl + posterPath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        }
        
        titleLbl.text = movie.title
        yearLbl.text = "\(movie.releaseDate?.getDate()?.getYear() ?? 0)"
    }
}
