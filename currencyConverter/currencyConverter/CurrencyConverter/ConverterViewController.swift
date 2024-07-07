//
//  ConverterViewController.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

protocol ConverterViewControllerDelegate: AnyObject {
    func currencySelectTapped(currencyList: [Currency], isSender: Bool)
}

class ConverterViewController: UIViewController {
    
    weak var delegate: ConverterViewControllerDelegate?
    
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
        
        viewModel = CurrencyViewModel(currencyService: CurrencyService())
        bindViewModel()

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
        
        currencyConvertView.setSender(currencyCode: "PLN")
        currencyConvertView.setSender(borderColor: .Custom.Converter.Error.borderColor, borderWidth: 2.0)
        currencyConvertView.setSender(inputColor: .Custom.Converter.Amount.redText)
        currencyConvertView.setSender(titleText: "Sending from")
        currencyConvertView.setSender(backgroundColor: .Custom.Converter.Sender.backgroundColor)
        currencyConvertView.setSender(flagImage: UIImage(named: "pln-flag-icon"))
        
        currencyConvertView.setReceiver(currencyCode: "UAH")
        currencyConvertView.setReceiver(borderColor: UIColor.clear, borderWidth: 0.0)
        currencyConvertView.setReceiver(inputColor: .Custom.Converter.Amount.blackText)
        currencyConvertView.setReceiver(titleText: "Receiver gets")
        currencyConvertView.setReceiver(backgroundColor: .Custom.Converter.Receiver.backgroundColor)
        currencyConvertView.setReceiver(flagImage: UIImage(named: "uah-flag-icon"))
        
        currencyConvertView.setRate(text: "1 PLN = 7.2323 UAH")
        
        errorView.isHidden = true
        
    }
    
    private func bindViewModel() {
        viewModel.updateRateText = { text in
            DispatchQueue.main.async {
                Logger.info("Rate text update")
                self.currencyConvertView.setRate(text: text)
            }
        }
        
        viewModel.onError = { error in
            Logger.warning("VM onError")
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
            }
        }
        
        viewModel.onFetchRequest = { [weak self] in
            Logger.warning("VM fetch request start")
            DispatchQueue.main.async {
                self?.errorView.isHidden = true
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
        
        viewModel.showSenderCurrencySelectionFor = { [weak self] list in
            DispatchQueue.main.async {
                self?.delegate?.currencySelectTapped(currencyList: list, isSender: true)
            }
        }
        
        
        viewModel.showReceiverCurrencySelectionFor = { [weak self] list in
            DispatchQueue.main.async {
                self?.delegate?.currencySelectTapped(currencyList: list, isSender: false)
            }
        }
    }

    public func newCurrencySelected(currency: Currency, fromSender: Bool) {
        DispatchQueue.main.async {
            //TODO: forward it to ViewModel -> work true logic
            if fromSender {
                self.currencyConvertView.setSender(currencyCode: currency.rawValue)
                self.currencyConvertView.setSender(flagImage: UIImage(named: currency.currencyFlagImageName))
            } else {
                self.currencyConvertView.setReceiver(currencyCode: currency.rawValue)
                self.currencyConvertView.setReceiver(flagImage: UIImage(named: currency.currencyFlagImageName))
            }
        }
        
        Logger.info("in Coverter VC newCurrencySelected")
    }

}

extension ConverterViewController: CurrencyConvertViewDelegate {
    func senderTextfieldValueChanged(_ textField: UITextField) {
        Logger.info("SENDER \(textField.text)")
        viewModel.senderAmountUpdated(textField.text)
    }
    
    func receiverTextfieldValueChanged(_ textField: UITextField) {
        Logger.info("RECEIVER \(textField.text)")
        viewModel.receiverAmountUpdated(textField.text)
    }
    
    func senderCurrencySelectionTapped() {
        Logger.info("SENDER CHANGE TAPPED")
        viewModel.changeSenderCurrencyTapped()
    }
    
    func receiverCurrencySelectionTapped() {
        //TODO: forward them to viewmodel check sender or receiver whatever pass
        Logger.info("RECEIVER CHANGE TAPPED")
        viewModel.changeReceiverCurrencyTapped()
        
    }
    
    func swapButtonTapped() {
        Logger.info("SWAP TAPPED")
    }
}
