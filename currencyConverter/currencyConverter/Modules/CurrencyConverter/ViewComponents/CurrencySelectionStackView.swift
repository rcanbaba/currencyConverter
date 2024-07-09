//
//  CurrencySelectionStackView.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit
import SnapKit

protocol CurrencySelectionStackViewDelegate: AnyObject {
    func currencySelectionTapped(_ sender: UIControl)
}

class CurrencySelectionStackView: UIStackView {
    
    weak var delegate: CurrencySelectionStackViewDelegate?
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.Custom.Converter.Receiver.currencyCodeColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var downArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "chevron-down")
        return imageView
    }()
    
    private lazy var retryView: UIControl = {
        let control = UIControl()
        control.addTarget(self, action: #selector(currencySelectionTapped(_:)), for: .touchUpInside)
        return control
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
        alignment = .center
        axis = .horizontal
        
        addArrangedSubview(flagImageView)
        addArrangedSubview(currencyCodeLabel)
        addArrangedSubview(downArrowImageView)
        
        setCustomSpacing(8, after: flagImageView)
        setCustomSpacing(4, after: currencyCodeLabel)
        
        addSubview(retryView)
        retryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        flagImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        downArrowImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
}


// MARK: Actions
extension CurrencySelectionStackView {
    @objc private func currencySelectionTapped(_ sender: UIControl) {
        delegate?.currencySelectionTapped(sender)
    }
}

// MARK: Public methods
extension CurrencySelectionStackView {
    
    public func set(flagImage: UIImage?) {
        flagImageView.image = flagImage
    }
    
    public func set(currencyCode: String) {
        currencyCodeLabel.text = currencyCode
    }
}
