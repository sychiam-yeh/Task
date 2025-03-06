//
//  DetailsViewController.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-05.
//

import UIKit

class DetailsViewController: UIViewController {

    var passedMovieList = MovieList()
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = self.passedMovieList.poster {
            AppHelper.setImage(fromURL: image, toImageView: self.backgroundImageView)
        }
    }
}
