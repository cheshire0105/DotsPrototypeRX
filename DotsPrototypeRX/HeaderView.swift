//
//  HeaderView.swift
//  DotsPrototypeRX
//
//  Created by cheshire on 10/20/23.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16) 
            make.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        label.textAlignment = .left
    }

}
