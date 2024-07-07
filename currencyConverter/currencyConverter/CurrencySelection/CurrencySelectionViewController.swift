//
//  CurrencySelectionViewController.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

protocol CurrencySelectionViewControllerDelegate: AnyObject {
    func currencySelected(currency: Currency, isSender: Bool)
}

class CurrencySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    weak var delegate: CurrencySelectionViewControllerDelegate?
    
    private var viewModel: CurrencySelectionViewModelProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "CurrencyCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 72
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero

        return tableView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor.Custom.Picker.titleTextColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor.Custom.Picker.titleTextColor
        label.textAlignment = .left
        label.text = "All countries"
        return label
    }()
    
    private var searchBar = UISearchBar()
    
    init(viewModel: CurrencySelectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        titleLabel.text = viewModel.titleText
        view.backgroundColor = UIColor.Custom.Picker.backgroundColor
        
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableViewTitleLabel)
        view.addSubview(tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableViewTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func bindViewModel() {
        viewModel.onCountriesFiltered = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }
        let item = viewModel.filteredCountries[indexPath.row]
        cell.set(flagImage: UIImage(named: item.flag))
        cell.set(countryText: item.country)
        cell.set(detailText: "\(item.name) • \(item.code)")
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCountries(with: searchText)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = viewModel.filteredCountries[indexPath.row]
        self.dismiss(animated: true)
        delegate?.currencySelected(currency: Currency(rawValue: selectedCountry.code)!, isSender: viewModel.isSender)
    }
}


