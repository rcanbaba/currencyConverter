//
//  NetworkErrorView.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 9.07.2024.
//

import UIKit
import SnapKit

protocol NetworkErrorViewDelegate: AnyObject {
    func networkErrorViewClose(view: NetworkErrorView)
}

class NetworkErrorView: UIStackView {
    
    public weak var delegate: NetworkErrorViewDelegate?
    
    private lazy var errorCrossImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "red-filled-x-icon")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.interBold, size: 16)
        label.textColor = UIColor.Custom.Converter.Error.networkErrorTitleColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.interRegular, size: 14)
        label.textColor = UIColor.Custom.Converter.Error.networkErrorDescriptionColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "gray-small-x-icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        return button
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
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: 0)
        
        backgroundColor = UIColor.Custom.Converter.Error.networkErrorBackgroundColor
        
        addSubview(errorCrossImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(closeButton)
        
        errorCrossImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(64)
            make.trailing.equalToSuperview().inset(56)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalToSuperview().inset(64)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview().inset(13)
            make.trailing.equalToSuperview().inset(13)
        }

    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped (_ sender: UIButton) {
        delegate?.networkErrorViewClose(view: self)
    }
    
    // MARK: - Public Methods
    public func set(errorTitleText: String) {
        titleLabel.text = errorTitleText
    }
    
    public func set(errorDescriptionText: String) {
        descriptionLabel.text = errorDescriptionText
    }
    
}

