//
//  File.swift
//  randomGame
//
//  Created by Nikolay Kurchatov on 03.09.2020.
//  Copyright © 2020 hkdDev. All rights reserved.
//

import UIKit

struct Coin {
    //    let imageNames = ["orel","reshka", "spinning"]
    var isReshka: Bool = false
    var coinText = "Орёл"
    
    mutating func flip() {
        let randomResult = Int.random(in: 0...1)
        switch randomResult {
        case 0:
            self.isReshka = false
            self.coinText = "Орёл"
        case 1:
            self.isReshka = true
            self.coinText = "Решка"
        default:
            break
        }
    }
    
}

