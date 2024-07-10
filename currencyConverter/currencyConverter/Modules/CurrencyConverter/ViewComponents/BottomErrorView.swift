//
//  BottomErrorView.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit
import SnapKit

class BottomErrorView: UIView {
    
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "red-info-icon")
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.interRegular, size: 12)
        label.textColor = UIColor.Custom.Converter.Error.maxErrorTextColor
        label.numberOfLines = 0
        label.textAlignment = .left
        label.accessibilityIdentifier = "BottomErrorView_textLabel"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoImageView, textLabel])
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.accessibilityIdentifier = "BottomErrorView_view"
        layer.cornerRadius = 8.0
        backgroundColor = UIColor.Custom.Converter.Error.maxErrorBackgroundColor
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }

    }
    
}

// MARK: Public Methods
extension BottomErrorView {
    
    public func set(errorText: String) {
        textLabel.text = errorText
    }
    
}
