//
//  SectionOfFruits.swift
//  DotsPrototypeRX
//
//  Created by cheshire on 10/20/23.
//

import Foundation
import RxDataSources

struct SectionOfFruits {
    var header: String
    var items: [String]
}
extension SectionOfFruits: SectionModelType {
    typealias Item = String

    init(original: SectionOfFruits, items: [Item]) {
        self = original
        self.items = items
    }
}
