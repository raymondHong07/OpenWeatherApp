//
//  SettingsViewController.swift
//  OpenWeatherApp
//
//  Created by Raymond Hong on 2020-03-11.
//  Copyright © 2020 RH. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    
    func didTapClose()
}

class SettingsViewController: UIViewController {

    @IBOutlet private weak var changeCityButton: UIButton!
    @IBOutlet private weak var unitSegementedControl: UISegmentedControl!
    @IBOutlet private weak var currentCityLabel: UILabel!
    
    private let openWeatherManager = OpenWeatherManager.sharedInstance
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpCurrentValues()
    }
    
    private func setUpCurrentValues() {
        
        currentCityLabel.text = openWeatherManager.city
        
        if openWeatherManager.units == "Imperial" {
            unitSegementedControl.selectedSegmentIndex = 1
        }
    }
    
    @IBAction private func didTapChangeButton(_ sender: Any) {
        
        presentCityChangeAlert()
    }
    
    @IBAction private func unitDidChange(_ sender: Any) {
        
        openWeatherManager.units = unitSegementedControl.selectedSegmentIndex == 0 ? "Metric" : "Imperial"
    }
    
    @IBAction private func didTapCloseButton(_ sender: Any) {
        
        dismiss(animated: true) {
            
            self.delegate?.didTapClose()
        }
    }
    
    private func presentCityChangeAlert() {
        
        let alert = UIAlertController(title: "City",
                                      message: "Change city below",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (textField) in
            textField.text = self.openWeatherManager.city
        }
        
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (action: UIAlertAction!) in
            
            if let textField = alert.textFields?.first,
               let city = textField.text {
                
                self.openWeatherManager.city = city
                self.currentCityLabel.text = city
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: { (action: UIAlertAction!) in }))
        
        present(alert, animated: true, completion: nil)
    }
    
}
