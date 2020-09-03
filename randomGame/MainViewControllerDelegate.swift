//
//  MainViewControllerDelegate.swift
//  randomGame
//
//  Created by Nikolay Kurchatov on 19.08.2020.
//  Copyright © 2020 hkdDev. All rights reserved.
//

import Foundation

protocol MainViewControllerDelegate: AnyObject {
    func updateWallet(_ text: String)
    func updateMaxSliderValue()
}
