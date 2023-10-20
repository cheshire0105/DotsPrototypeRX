//
//  Cell.swift
//  DotsPrototypeRX
//
//  Created by cheshire on 10/19/23.
//

import Foundation
import UIKit

class CustomCell: UICollectionViewCell {
    var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
