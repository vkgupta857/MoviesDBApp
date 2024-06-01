//
//  BaseViewController.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import UIKit

class BaseViewController<T: BaseViewModel>: UIViewController {

    var viewModel: T!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
