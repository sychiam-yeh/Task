//
//  AppHelper.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-05.
//

import Foundation
import Kingfisher

class AppHelper {
    
    static func setImage(fromURL: String?, toImageView: UIImageView, placeholder: String = "ic_landing_logo") {
        var url: URL?
        if let imageURL = fromURL {
            let synthesizedURL = imageURL.replacingOccurrences(of: " ", with: "%20")
            url = URL(string: synthesizedURL)
        }
        toImageView.kf.setImage(with: url, placeholder: UIImage(named: placeholder), options: [.transition(.fade(0.3))])
    }
    
}
