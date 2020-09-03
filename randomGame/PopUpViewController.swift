//
//  PopUpViewController.swift
//  randomGame
//
//  Created by Nikolay Kurchatov on 18.08.2020.
//  Copyright © 2020 hkdDev. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    weak var delegate: MainViewControllerDelegate?
    var addedFunds: Int = 0
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopView()
        sumTextField.placeholder = "сумма"
        moveIn()
    }
    func setupPopView() {
        popUpView.layer.cornerRadius = 25
        addButton.layer.cornerRadius = 15
        sumTextField.attributedPlaceholder = NSAttributedString(string: "Сумма пополнения")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        
    }
    
    func moveIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.24) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }
    }
    
    func moveOut() {
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    @IBAction func closePopUp(_ sender: UIButton) {
        if sumTextField.hasText {
            guard let sum = sumTextField.text else { return }
            delegate?.updateWallet(sum)
            delegate?.updateMaxSliderValue()
            moveOut()
        }
    }
}
