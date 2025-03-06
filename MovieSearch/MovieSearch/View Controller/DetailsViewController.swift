//
//  DetailsViewController.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-05.
//

import UIKit

class DetailsViewController: UIViewController {
    
    /* =================================================================
     *                   MARK: - Local Initialization
     * ================================================================= */
    var passedMovieList = MovieList()
    
    /* =================================================================
     *                   MARK: - Outlet Initialization
     * ================================================================= */
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    /* =================================================================
     *                   MARK: - Class Function
     * ================================================================= */
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = self.passedMovieList.poster {
            AppHelper.setImage(fromURL: image, toImageView: self.backgroundImageView)
        }
    }
}
