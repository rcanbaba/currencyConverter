//
//  RateView.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit
import SnapKit

class RateView: UIStackView {
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.interBold, size: 10)
        label.textColor = UIColor.Custom.Converter.Rate.textColor
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // TODO: we can take them from a fileprivate uiconstant struct
        backgroundColor = UIColor.Custom.Converter.Rate.backgroundColor
        layer.cornerRadius = 9.0
        
        snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: Public methods
extension RateView {
    
    public func set(text: String) {
        textLabel.text = text
    }
}
