//
//  TextFieldView.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

protocol TextFieldViewDelegate: AnyObject {
    func textfieldValueChanged(_ textField: UITextField)
    func currencySelectionTapped(_ sender: TextFieldView)
}

class TextFieldView: UIView {
    
    weak var delegate: TextFieldViewDelegate?
    
    public let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        textField.font = UIFont.systemFont(ofSize: 32)
        textField.placeholder = "enter amount              "
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.backgroundColor = .clear
        textField.textColor = UIColor.black
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 16
        textField.textAlignment = .right
        return textField
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.Custom.Converter.Receiver.titleTextColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "Sending from"
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, currencySelectionStackView])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        return stackView
    }()
    
    private lazy var currencySelectionStackView: CurrencySelectionStackView = {
        let stackView = CurrencySelectionStackView()
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.setContentHuggingPriority(.required, for: .horizontal)
        stackView.delegate = self
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureUI()
        
        textField.addTarget(self, action: #selector(textfieldValueChanged(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        accessibilityIdentifier = "ChatTextFieldView"
        backgroundColor = UIColor.yellow.withAlphaComponent(0.4)
        layer.masksToBounds = false
        layer.zPosition = 1
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.16 // 16% opacity
        layer.shadowRadius = 16 // Blur radius
        layer.shadowOffset = CGSize(width: 0, height: 0) // No offset
        
        layer.cornerRadius = 16
        
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.red.cgColor
        
        
        addSubview(leftStackView)
        addSubview(textField)
        
        leftStackView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(leftStackView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.top.bottom.equalToSuperview().inset(26)
        }
    }
    
}

// MARK: Actions
extension TextFieldView {
    
    @objc private func textfieldValueChanged(_ textField: UITextField) {
        delegate?.textfieldValueChanged(textField)
    }
}

// MARK: Public methods
extension TextFieldView {
    
    public func set(titleText: String) {
        titleLabel.text = titleText
    }
    
    public func set(currencyFlagImage: UIImage?) {
        currencySelectionStackView.set(flagImage: currencyFlagImage)
    }
    
    public func set(currencyCodeText: String) {
        currencySelectionStackView.set(currencyCode: currencyCodeText)
    }
    
    public func set(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    public func set(borderColor: UIColor, borderWidth: CGFloat) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    public func set(textFieldTextColor: UIColor) {
        textField.textColor = textFieldTextColor
    }
    
    public func set(textFieldText: String) {
        textField.text = textFieldText
    }
    
}

extension TextFieldView: CurrencySelectionStackViewDelegate {
    func currencySelectionTapped(_ sender: UIControl) {
        delegate?.currencySelectionTapped(self)
    }
    
}
