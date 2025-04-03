//
//  SearchView.swift
//  weatherApp
//
//  Created by Bhavik Goyal on 12/12/23.
//

import UIKit

protocol SearchDelegate: AnyObject {
    func LabelDataDelegate(label: String)
    func LocationDelegate()
    func pressSearchDelegate()
}

class SearchView: UIView {
    weak var delegate: SearchDelegate?

    public var locationLabel: String? {
        didSet {
            updateAccessibility()
        }
    }

    public var searchTextLabel: String? {
        didSet {
            updateAccessibility()
        }
    }

    public var searchLabel: String? {
        didSet {
            updateAccessibility()
        }
    }

    public var locationTraits: UIAccessibilityTraits = [] {
        didSet {
            updateAccessibilityIdentifier()
        }
    }

    public var searchTextTraits: UIAccessibilityTraits = [] {
        didSet {
            updateAccessibilityIdentifier()
        }
    }

    public var searchTraits: UIAccessibilityTraits = [] {
        didSet {
            updateAccessibilityIdentifier()
        }
    }

    private let locationButton: UIButton = {
        let button = UIButton()
        // button.setImage(UIImage(systemName: "location.square.fill"), for: .normal)
        // button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "location.square.fill"), for: .normal)
        button.tintColor = .systemGray2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityHint = "Tap to get current Location"
        button.accessibilityValue = "Location"
        return button
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 1.0
        textField.accessibilityHint = "Enter Location Name for Search"
        return textField
    }()

    private let searchButton: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        button.tintColor = .systemGray2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityHint = "Tap to search for Entered Location"
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(locationButton)
        addSubview(searchTextField)
        addSubview(searchButton)
        locationButton.addTarget(self, action: #selector(locationBn), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(locationTouchBn), for: .touchDown)
        searchTextField.addTarget(self, action: #selector(searchTextValue), for: .editingChanged)
        searchButton.addTarget(self, action: #selector(searchBn), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchTouchBn), for: .touchDown)
        searchTextField.delegate = self
        applyConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}

extension SearchView {
    @objc private func searchTextValue() {
        delegate?.LabelDataDelegate(label: searchTextField.text ?? "")
        updateAccessibilityIdentifier()
    }

    @objc private func searchBn() {
        searchButton.accessibilityTraits.remove(.selected)
        delegate?.pressSearchDelegate()
        updateAccessibilityIdentifier()
        searchTextField.resignFirstResponder()
    }

    @objc private func locationBn() {
        locationButton.accessibilityTraits.remove(.selected)
        delegate?.LocationDelegate()
        updateAccessibilityIdentifier()
    }

    @objc private func locationTouchBn() {
        locationButton.accessibilityTraits.insert(.selected)
        locationButton.accessibilityIdentifier = "location_location.square.fill_pressed"
    }

    @objc private func searchTouchBn() {
        searchButton.accessibilityTraits.insert(.selected)
        searchButton.accessibilityIdentifier = "search_magnifyingglass.circle_pressed"
    }
}

extension SearchView: UITextFieldDelegate {
    private func applyConstraints() {
        let buttonConstraints = [
            locationButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            locationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            locationButton.widthAnchor.constraint(equalToConstant: 50),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        let textConstraints = [
            searchTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
        ]
        let sbuttonConstraints = [
            searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(buttonConstraints + textConstraints + sbuttonConstraints)
    }

    func updateAccessibility() {
        locationButton.accessibilityLabel = locationLabel
        searchButton.accessibilityLabel = searchLabel
        searchTextField.accessibilityLabel = searchTextLabel
    }

    func updateAccessibilityIdentifier() {
        locationButton.accessibilityTraits = locationTraits
        searchButton.accessibilityTraits = searchTraits
        searchTextField.accessibilityTraits = searchTextTraits

        locationButton.accessibilityIdentifier = "location_location.square.fill"
        searchTextField.accessibilityIdentifier = "searchText_\(String(describing: searchTextField.text))"
        searchButton.accessibilityIdentifier = "search_magnifyingglass.circle"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButton.accessibilityTraits.remove(.selected)
        delegate?.pressSearchDelegate()
        updateAccessibilityIdentifier()
        textField.resignFirstResponder()
        return true
    }
}
