//
//  AddToPlaylistViewController.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit

protocol AddToPlaylistDelegate: AnyObject {
    func didDismissController()
}

class AddToPlaylistViewController: BaseViewController<AddToPlaylistViewModel> {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var grabberView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    weak var delegate: AddToPlaylistDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeight.constant = tableView.contentSize.height
        tableView.layoutIfNeeded()
    }
    
    func setupUI() {
        self.backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backdropAction)))
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        grabberView.layer.cornerRadius = grabberView.frame.height / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.register(PlaylistTableCell.nib, forCellReuseIdentifier: PlaylistTableCell.reuseIdentifier)
        tableView.register(PlaylistTableFooter.nib, forHeaderFooterViewReuseIdentifier: PlaylistTableFooter.reuseIdentifier)
        tableView.reloadData()
        tableViewHeight.constant = tableView.contentSize.height
        tableView.layoutIfNeeded()
    }
    
    @objc func backdropAction() {
        delegate?.didDismissController()
        self.dismiss(animated: true)
    }
    
    @objc func addNewPlaylist() {
        if let movie = viewModel.newMovie {
            let alert = UIAlertController(title: "Add new playlist", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = ""
                textField.placeholder = "Enter playlist name"
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            }))
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert, weak self] (_) in
                if let textField = alert?.textFields?.first, let text = textField.text {
                    PlaylistManager.shared.createPlaylistAndAdd(with: text, movie: movie)
                    
                    self?.updatePlaylists()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updatePlaylists() {
        viewModel.loadPlaylists()
        tableView.reloadData()
        view.setNeedsLayout()
    }
}

extension AddToPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableCell.reuseIdentifier) as? PlaylistTableCell, indexPath.row < viewModel.playlists.count else { return UITableViewCell() }
        let playlist = viewModel.playlists[indexPath.row]
        cell.configureCell(playlist: playlist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = viewModel.newMovie, indexPath.row < viewModel.playlists.count {
            let playlist = viewModel.playlists[indexPath.row]
            PlaylistManager.shared.addMovie(movie: movie, in: playlist)
        }
        self.backdropAction()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PlaylistTableFooter.reuseIdentifier) as? PlaylistTableFooter
        view?.addBtn.addTarget(self, action: #selector(addNewPlaylist), for: .touchUpInside)
        return view
    }
}

extension AddToPlaylistViewController {
    static func getInstance(_ viewModel: AddToPlaylistViewModel) -> AddToPlaylistViewController {
        let vc: AddToPlaylistViewController = .load()
        vc.viewModel = viewModel
        return vc
    }
}
