//
//  UITableViewCell+Reuse.swift
//  OpenWeatherApp
//
//  Created by Raymond Hong on 2020-03-11.
//  Copyright © 2020 RH. All rights reserved.
//

import UIKit

// An extension to implement a uniform way of generating ReuseIdentifiers and intializing cells
// The class becomes increasingly useful as ViewController classes grow in size and are heavily UI dependant
//
extension UITableViewCell {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    static var nibName: String {
        
        return String(describing: self)
    }
    
    class func register(with tableView: UITableView) {
        
        tableView.register(
            UINib(nibName: nibName, bundle: nil),
            forCellReuseIdentifier: identifier)
    }
}
