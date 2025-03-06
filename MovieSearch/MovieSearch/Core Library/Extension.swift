//
//  Extension.swift
//  MovieSearch
//
//  Created by chiam shwuyeh on 2025-03-06.
//

import UIKit
import Foundation
import NVActivityIndicatorView

extension UIViewController {
    func showLoadingScreen() {
        let animationType = NVActivityIndicatorType.ballRotateChase
        let animationColor = UIColor.red
        let animationFontSize = UIFont.systemFont(ofSize: 13.0)
        let backgroundColor = UIColor.clear
        let activityData = ActivityData(message: "Loading...", messageFont: animationFontSize, type: animationType, color: animationColor, padding: 50.0, backgroundColor: backgroundColor)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    /// Function used to hide the loading screen
    func hideLoadingScreen() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}
