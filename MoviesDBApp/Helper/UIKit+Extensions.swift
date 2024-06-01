//
//  UIKit+Extensions.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit

extension UIViewController {
    static func load<T: UIViewController>() -> T {
        T(nibName: String(describing: T.self), bundle: nil)
    }
}
