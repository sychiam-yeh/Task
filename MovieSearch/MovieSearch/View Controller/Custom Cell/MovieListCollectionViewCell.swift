//
//  MovieListCollectionViewCell.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-05.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "movieListCell"
    
    /* =================================================================
     *                   MARK: - Local Initialization
     * ================================================================= */
    var movieList = MovieList()
    var onViewActionHandler: ((MovieList) -> Void)?
    
    /* =================================================================
     *                   MARK: - Outlet Initialization
     * ================================================================= */
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBAction func onViewTapped(_ sender: Any) {
        self.onViewActionHandler?(self.movieList)
    }
    
    /* =================================================================
     *                   MARK: - Class Function
     * ================================================================= */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(movie: MovieList) {
        self.movieList = movie
        AppHelper.setImage(fromURL: movie.poster, toImageView: self.backgroundImageView)
        self.titleLabel.text = movie.title
        self.yearLabel.text = movie.year
    }
}
