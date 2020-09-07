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
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopView()
        moveIn()
    }
    func setupPopView() {
        sumTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите сумму",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(moveOut))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        let img = UIImage(named: "background2")
        popUpView.backgroundColor = UIColor(patternImage: img!)
        
        popUpView.layer.cornerRadius = 25
        addButton.layer.cornerRadius = 15
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
    
    @objc func moveOut() {
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

extension PopUpViewController: UIGestureRecognizerDelegate {

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
  }
}
