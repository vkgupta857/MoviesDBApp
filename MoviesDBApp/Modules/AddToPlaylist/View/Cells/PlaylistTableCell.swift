//
//  PlaylistTableCell.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit

class PlaylistTableCell: UITableViewCell, Reusable {

    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func configureCell(playlist: Playlist) {
        nameLbl.text = playlist.name
    }
}
