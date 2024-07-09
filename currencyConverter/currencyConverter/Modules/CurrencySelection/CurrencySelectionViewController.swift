//
//  CurrencySelectionViewController.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit

final class CurrencySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var viewModel: CurrencySelectionViewModelProtocol
    
    public lazy var tableView: UITableView = {
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
    
    private lazy var handleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "handle-icon")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.interBold, size: 24)
        label.textColor = UIColor.Custom.Picker.titleTextColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.interBold, size: 16)
        label.textColor = UIColor.Custom.Picker.titleTextColor
        label.textAlignment = .left
        label.text = "All countries"
        return label
    }()
    
    private lazy var searchBaseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.Custom.Picker.SearchBar.borderColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.interRegular, size: 12)
        label.textColor = UIColor.Custom.Picker.SearchBar.textColor
        label.textAlignment = .left
        label.backgroundColor = .white
        // TODO: this is hacky add back view :)
        label.text = " Search "
        return label
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "search-icon")
        return imageView
    }()
    
    public var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .prominent
        searchBar.backgroundColor = .white
        searchBar.barTintColor = .white
        searchBar.layer.cornerRadius = 9.0
        
        // Access the UITextField inside UISearchBar
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            // Add padding to the left of the text field for magnifier icon
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            searchTextField.leftView = paddingView
            searchTextField.leftViewMode = .always
            searchTextField.backgroundColor = UIColor.Custom.Picker.SearchBar.backgroundColor
            searchTextField.textColor = UIColor.Custom.Picker.SearchBar.textColor
        }
        
        return searchBar
    }()
    
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
        
        view.addSubview(handleImageView)
        view.addSubview(titleLabel)
        
        view.addSubview(searchBaseView)
        searchBaseView.addSubview(searchBar)
        searchBar.addSubview(searchImageView)
        view.addSubview(searchLabel)
        view.addSubview(tableViewTitleLabel)
        view.addSubview(tableView)
        
        handleImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
            make.width.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(handleImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchBaseView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchBaseView.snp.leading).offset(12)
            make.centerY.equalTo(searchBaseView.snp.top)
        }
        
        searchImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        tableViewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableViewTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
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
        viewModel.currencySelected(with: Currency(rawValue: selectedCountry.code)!)
        self.dismiss(animated: true)
    }
}


