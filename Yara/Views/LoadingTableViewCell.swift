//
//  LoadingTableViewCell.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/29/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "LoadingTableViewCell"
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    func configure() {
        activityIndicatorView.startAnimating()
        backgroundView = nil
        backgroundColor = UIColor.clear
    }
}
