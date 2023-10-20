//
//  ViewModel.swift
//  DotsPrototypeRX
//
//  Created by cheshire on 10/20/23.
//

import Foundation

class FruitsViewModel {
    private let fruits: [Fruit]

    var fruitNames: [String] {
        return fruits.map { $0.name }
    }

    init(fruits: [Fruit]) {
        self.fruits = fruits
    }

}
