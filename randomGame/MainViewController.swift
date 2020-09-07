//
//  MainViewController.swift
//  randomGame
//
//  Created by Nikolay Kurchatov on 18.08.2020.
//  Copyright © 2020 hkdDev. All rights reserved.
//

import UIKit

enum AlertType: String {
    case lost, wrongSum
}


class MainViewController: UIViewController {
    
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var maxBetLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var betSlider: UISlider!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var betButton: UIButton!
    
    var bankSum = 10
    var isBetSideReshka: Bool?
    var coin = Coin(isReshka: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackground()
        
        createButtons()
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func createBackground(){
        let background = UIImage(named: "background")
        let backgroundImageView = UIImageView(image: background)
        backgroundImageView.frame = self.view.frame
        self.view.insertSubview(backgroundImageView, at: 0)

    }
    
    func updateWalletLabel() {
        walletLabel.text = "\(bankSum)"
    }
    
    func refreshBetSlider() {
        betSlider.minimumValue = 0
        betSlider.maximumValue = Float(bankSum)
        betSlider.value = 0
    }
    
    func createButtons() {
        betButton.layer.cornerRadius = betButton.frame.height / 2
        segment.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal)
    }
    
    func updateBetLabel(currentSliderValue: Float) {
        let currentIntValue = Int(currentSliderValue)
        betLabel.text = "\(currentIntValue)"
    }
    
    func updateCoinView() {
        if self.coin.isReshka {
            self.coinImageView.image = UIImage(named: "reshka")
        } else {
            self.coinImageView.image = UIImage(named: "orel")
        }
    }
    
    func refresh() {
        updateWalletLabel()
        refreshBetSlider()
        updateMaxSliderValue()
        updateCoinView()
        updateBetLabel(currentSliderValue: 0.0)
        maxBetLabel.text = String(bankSum)
        resultLabel.fadeTransition(0.4)
        resultLabel.text = coin.coinText
        
        if bankSum == 0 {
            showAlert(type: .lost)
        }
        
    }
    
    func showAlert(type: AlertType) {
        switch type {
        case .lost:
            let alert = UIAlertController(title: "Получается", message: "проиграл", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ёбаный рот", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        case .wrongSum:
            let alert = UIAlertController(title: "Пидор", message: "Баги ищешь?)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Больше не буду", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func showAddFundsView(_ sender: UIButton) {
        guard let popUpVc = UIStoryboard(
            name: "Main",
            bundle: nil).instantiateViewController(
                withIdentifier: "popUpVCid") as? PopUpViewController else { return }
        self.addChild(popUpVc)
        popUpVc.delegate = self
        popUpVc.view.frame = self.view.frame
        self.view.addSubview(popUpVc.view)
        popUpVc.didMove(toParent: self)
    }
    
    @IBAction func betSliderValueChanged(_ sender: Any) {
        betLabel.text = "\(betSlider.value)"
        updateBetLabel(currentSliderValue: betSlider.value)
    }
    
    @IBAction func betButtonPressed(_ sender: Any) {
        self.resultLabel.fadeTransition(0.4)
        self.resultLabel.text = "Результат..."
        self.coinImageView.image = UIImage(named: "spinning")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.coin.flip()
            if self.coin.isReshka == self.isBetSideReshka {
                //выигрыш
                self.bankSum = self.bankSum + Int(self.betSlider.value)
            } else {
                //проигрыш
                self.bankSum = self.bankSum - Int(self.betSlider.value)
                if self.bankSum < 0 {
                    self.bankSum = 0
                }
            }
            self.refresh()
        })
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        switch segment.selectedSegmentIndex {
        case 0:
            // Орел
            self.isBetSideReshka = false
        case 1:
            // Решка
            self.isBetSideReshka = true
        default:
            break
        }
    }
    
}

extension MainViewController: MainViewControllerDelegate {
    func updateWallet(_ text: String) {
        guard let addedFunds = Int(text) else { return }
        if addedFunds > 0 {
            self.bankSum += addedFunds
            let bankString = String(self.bankSum)
            walletLabel.text = bankString
            refresh()
        } else {
            showAlert(type: .wrongSum)
        }
    }
    
    func updateMaxSliderValue() {
        betSlider.maximumValue = Float(bankSum)
    }
}

