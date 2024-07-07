//
//  CurrencyConvertView.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

protocol CurrencyConvertViewDelegate: AnyObject {
    func senderTextfieldValueChanged(_ textField: UITextField)
    func receiverTextfieldValueChanged(_ textField: UITextField)
    func senderCurrencySelectionTapped()
    func receiverCurrencySelectionTapped()
    func swapButtonTapped()
}

class CurrencyConvertView: UIView, UITextFieldDelegate{
    
    weak var delegate: CurrencyConvertViewDelegate?

    private lazy var senderTextFieldView: TextFieldView = {
        let view = TextFieldView()
        view.tag = 1
        view.delegate = self
        view.set(backgroundColor: .white)
        view.textField.delegate = self
        return view
    }()
    
    private lazy var receiverTextFieldView: TextFieldView = {
        let view = TextFieldView()
        view.tag = 2
        view.delegate = self
        view.set(backgroundColor: .clear)
        view.textField.delegate = self
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [senderTextFieldView, receiverTextFieldView])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var swapButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(swapButtonTapped(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "swap-icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var rateView = RateView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = UIColor.Custom.Converter.backgroundColor
        layer.cornerRadius = 16
        
        addSubview(mainStackView)
        addSubview(swapButton)
        addSubview(rateView)
        
        
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        swapButton.snp.makeConstraints { (make) in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(44)
        }
        
        rateView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

    }
    
    // TODO: move this logic to viewModel
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        // Check if the input is a comma
        if string == "," {
            // Allow only one comma
            if currentText.contains(",") {
                return false
            }
        }
        
        // Check if the input is valid
        let allowedCharacters = CharacterSet(charactersIn: "0123456789,")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}

// MARK: Actions
extension CurrencyConvertView {
    @objc private func swapButtonTapped(_ sender: UIButton) {
        delegate?.swapButtonTapped()
    }
}

// MARK: Public methods
extension CurrencyConvertView {
    
    public func setRate(text: String){
        rateView.set(text: text)
    }
    
    //MARK: Sender
    public func setSender(titleText: String){
        senderTextFieldView.set(titleText: titleText)
    }
    
    public func setSender(flagImage: UIImage?){
        senderTextFieldView.set(currencyFlagImage: flagImage)
    }
    
    public func setSender(currencyCode: String){
        senderTextFieldView.set(currencyCodeText: currencyCode)
    }

    public func setSender(backgroundColor: UIColor){
        senderTextFieldView.set(backgroundColor: backgroundColor)
    }
    
    public func setSender(borderColor: UIColor, borderWidth: CGFloat){
        senderTextFieldView.set(borderColor: borderColor, borderWidth: borderWidth)
    }
    
    public func setSender(inputColor: UIColor){
        senderTextFieldView.set(textFieldTextColor: inputColor)
    }
    
    public func setSender(text: String){
        senderTextFieldView.set(textFieldText: text)
    }
    
    //MARK: Receiver
    public func setReceiver(titleText: String){
        receiverTextFieldView.set(titleText: titleText)
    }
    
    public func setReceiver(flagImage: UIImage?){
        receiverTextFieldView.set(currencyFlagImage: flagImage)
    }
    
    public func setReceiver(currencyCode: String){
        receiverTextFieldView.set(currencyCodeText: currencyCode)
    }

    public func setReceiver(backgroundColor: UIColor){
        receiverTextFieldView.set(backgroundColor: backgroundColor)
    }
    
    public func setReceiver(borderColor: UIColor, borderWidth: CGFloat){
        receiverTextFieldView.set(borderColor: borderColor, borderWidth: borderWidth)
    }
    
    public func setReceiver(inputColor: UIColor){
        receiverTextFieldView.set(textFieldTextColor: inputColor)
    }
    
    public func setReceiver(text: String){
        receiverTextFieldView.set(textFieldText: text)
    }
    
}

extension CurrencyConvertView: TextFieldViewDelegate {
    
    func textfieldValueChanged(_ textField: UITextField) {
        if textField.superview?.tag == senderTextFieldView.tag {
            delegate?.senderTextfieldValueChanged(textField)
        } else if textField.superview?.tag == receiverTextFieldView.tag {
            delegate?.receiverTextfieldValueChanged(textField)
        }
    }
    
    func currencySelectionTapped(_ sender: TextFieldView) {
        if sender.tag == senderTextFieldView.tag {
            delegate?.senderCurrencySelectionTapped()
        } else if sender.tag == receiverTextFieldView.tag {
            delegate?.receiverCurrencySelectionTapped()
        }
        
    }
    
}
