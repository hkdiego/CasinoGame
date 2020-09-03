//
//  MainViewController.swift
//  randomGame
//
//  Created by Nikolay Kurchatov on 18.08.2020.
//  Copyright © 2020 hkdDev. All rights reserved.
//

import UIKit

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
    var betSide = 0
    var coin = Coin(isReshka: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackground()
        
        createButtons()
        
        refresh()
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
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
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
        self.resultLabel.text = "Результат..."
        
        self.coinImageView.image = UIImage(named: "spinning")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            let randomResult = Int.random(in: 0...1)
            switch randomResult {
            case 0:
                self.resultLabel.text = "Орёл!"
                self.coin.isReshka = false
            case 1:
                self.resultLabel.text = "Решка!"
                self.coin.isReshka = true
            default:
                 break
            }
            if randomResult == self.betSide {
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
            self.betSide = 0
            self.coin.isReshka = false
        case 1:
            // Решка
            self.betSide = 1
            self.coin.isReshka = true
        default:
            break
        }
    }
    
}

extension MainViewController: MainViewControllerDelegate {
    func updateWallet(_ text: String) {
        guard let addedFunds = Int(text) else { return }
        self.bankSum += addedFunds
        let bankString = String(self.bankSum)
        walletLabel.text = bankString
        refresh()
    }
    
    func updateMaxSliderValue() {
        betSlider.maximumValue = Float(bankSum)
    }
}

