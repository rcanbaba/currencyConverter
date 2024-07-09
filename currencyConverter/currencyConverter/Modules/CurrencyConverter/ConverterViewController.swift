//
//  ConverterViewController.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

class ConverterViewController: UIViewController {
    
    private var viewModel: CurrencyViewModelProtocol
    
    private lazy var currencyConvertView: CurrencyConvertView = {
        var view = CurrencyConvertView()
        view.delegate = self
        return view
    }()
    
    private lazy var errorView = BottomErrorView()
    
    init(viewModel: CurrencyViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureUI()
        bindViewModel()
        
        viewModel.setDefaultValues()

    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(currencyConvertView)
        currencyConvertView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.top.equalTo(currencyConvertView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
    }
    
    private func configureUI() {
        // TODO: all this data must be taken from view model
        currencyConvertView.setSender(borderColor: UIColor.clear, borderWidth: 0.0)
        currencyConvertView.setSender(inputColor: .Custom.Converter.Amount.blackText)
        currencyConvertView.setSender(titleText: "Sending from")
        currencyConvertView.setSender(backgroundColor: .Custom.Converter.Sender.backgroundColor)
        
        currencyConvertView.setReceiver(borderColor: UIColor.clear, borderWidth: 0.0)
        currencyConvertView.setReceiver(inputColor: .Custom.Converter.Amount.blackText)
        currencyConvertView.setReceiver(titleText: "Receiver gets")
        currencyConvertView.setReceiver(backgroundColor: .Custom.Converter.Receiver.backgroundColor)
        
        errorView.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.updateRateText = { text in
            DispatchQueue.main.async {
                Logger.info("Rate text update")
                self.currencyConvertView.setRate(text: text)
            }
        }
        
        viewModel.onError = { errorText in
            Logger.warning("-----BURDA  aaaa  VM onError \(errorText)")
        }
        
        viewModel.onError2 = { [weak self] errorMessage in
            Logger.warning("VM onError2")
            DispatchQueue.main.async {
                self?.errorView.set(errorText: errorMessage)
            }
        }
        
        viewModel.onReceiverAmountError = { [weak self] errorText in
            Logger.warning("Validaton Error errorText")
            DispatchQueue.main.async {
                self?.errorView.isHidden = false
                self?.errorView.set(errorText: errorText)
                self?.currencyConvertView.setSender(borderColor: .Custom.Converter.Error.borderColor, borderWidth: 2.0)
                self?.currencyConvertView.setSender(inputColor: .Custom.Converter.Amount.redText)
            }
        }
        
        viewModel.onFetchRequest = { [weak self] in
            Logger.warning("VM fetch request start")
            DispatchQueue.main.async {
                self?.errorView.isHidden = true
                self?.errorView.set(errorText: "")
                self?.currencyConvertView.setSender(borderColor: UIColor.clear, borderWidth: 0.0)
                self?.currencyConvertView.setSender(inputColor: .Custom.Converter.Amount.blueText)
            }
        }
        
        viewModel.updateReceiverAmount = { [weak self] amountText in
            Logger.info("update RECEIVER textfield \(amountText)")
            DispatchQueue.main.async {
                self?.currencyConvertView.setReceiver(text: amountText)
            }
        }
        
        viewModel.updateSenderAmount = { [weak self] amountText in
            Logger.info("update SENDER textfield \(amountText)")
            DispatchQueue.main.async {
                self?.currencyConvertView.setSender(text: amountText)
            }
        }
        
        viewModel.updateSenderCurrencyText = { [weak self] text in
            DispatchQueue.main.async {
                self?.currencyConvertView.setSender(currencyCode: text)
            }
        }
        
        viewModel.updateSenderCurrencyImage = { [weak self] currency in
            DispatchQueue.main.async {
                self?.currencyConvertView.setSender(flagImage: currency.currencyFlagImage)
            }
        }
        
        viewModel.updateReceiverCurrencyText = { [weak self] text in
            DispatchQueue.main.async {
                self?.currencyConvertView.setReceiver(currencyCode: text)
            }
        }
        
        viewModel.updateReceiverCurrencyImage = { [weak self] currency in
            DispatchQueue.main.async {
                self?.currencyConvertView.setReceiver(flagImage: currency.currencyFlagImage)
            }
        }
    }

    public func newCurrencySelected(currency: Currency, fromSender: Bool) {
        Logger.info("in Coverter VC newCurrencySelected \(currency.rawValue) fromSender: \(fromSender)")
        fromSender ? viewModel.changeSenderCurrency(currency) : viewModel.changeReceiverCurrency(currency)
    }

}

extension ConverterViewController: CurrencyConvertViewDelegate {
    func senderTextfieldValueChanged(_ textField: UITextField) {
        Logger.info("SENDER \(textField.text ?? "null")")
        viewModel.senderAmountUpdated(textField.text)
    }
    
    func receiverTextfieldValueChanged(_ textField: UITextField) {
        Logger.info("RECEIVER \(textField.text ?? "null")")
        viewModel.receiverAmountUpdated(textField.text)
    }
    
    func senderCurrencySelectionTapped() {
        Logger.info("SENDER CHANGE TAPPED")
        viewModel.changeSenderCurrencyTapped()
    }
    
    func receiverCurrencySelectionTapped() {
        Logger.info("RECEIVER CHANGE TAPPED")
        viewModel.changeReceiverCurrencyTapped()
    }
    
    func swapButtonTapped() {
        Logger.info("SWAP TAPPED")
        viewModel.swapCurrency()
    }
}
