//
//  CurrencyTableViewCell.swift
//  currencyConverter
//
//  Created by Can Babaoğlu on 7.07.2024.
//

import UIKit
import SnapKit

class CurrencyTableViewCell: UITableViewCell {
    
    private lazy var flagBaseView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.backgroundColor = .Custom.Picker.itemFlagBackgroundColor
        return view
    }()

    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.black
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.Custom.Picker.itemDetailTextColor
        return label
    }()
    // •
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countryLabel, detailLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        
        contentView.addSubview(flagBaseView)
        flagBaseView.addSubview(flagImageView)
        contentView.addSubview(stackView)

        flagBaseView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        flagImageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.center.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.leading.equalTo(flagBaseView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    
    func set(flagImage: UIImage?) {
        flagImageView.image = flagImage
    }
    
    func set(countryText: String) {
        countryLabel.text = countryText
    }
    
    func set(detailText: String) {
        detailLabel.text = detailText
    }
    
}
