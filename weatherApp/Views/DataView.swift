//
//  DataView.swift
//  weatherApp
//
//  Created by Bhavik Goyal on 12/12/23.
//

import UIKit

class DataView: UIView {
    public let imageWeather: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .black
        return image
    }()

    public let temperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temperature"
        label.font = .systemFont(ofSize: 60, weight: .bold)
        return label
    }()

    public let location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search a Location"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        return label
    }()

    public func configure(with model: WeatherData) {
        var value: Double = model.main.temp
        if value > 200 {
            value -= 273.15
        }
        let rounded = round(value * 10) / 10
        let temperatureVal = String(format: "%.1f", rounded) + "°C"
        temperature.text = temperatureVal
        location.text = model.name
        imageWeather.image = UIImage(systemName: model.getImage)

        temperature.accessibilityLabel = temperatureVal
        location.accessibilityLabel = model.name
        imageWeather.accessibilityLabel = model.getImage.components(separatedBy: ".").joined(separator: " ")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageWeather)
        addSubview(temperature)
        addSubview(location)
        applyConstraints()

        temperature.accessibilityTraits = .header
        location.accessibilityTraits = .header
        imageWeather.accessibilityTraits = .image
        imageWeather.isAccessibilityElement = true
        location.isAccessibilityElement = true
        temperature.isAccessibilityElement = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}

extension DataView {
    private func applyConstraints() {
        let imageConstraints = [
            imageWeather.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageWeather.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            imageWeather.widthAnchor.constraint(equalToConstant: 100),
            imageWeather.heightAnchor.constraint(equalToConstant: 100),
        ]
        let temperatureConstraints = [
            temperature.centerXAnchor.constraint(equalTo: centerXAnchor),
            temperature.topAnchor.constraint(equalTo: imageWeather.bottomAnchor, constant: 20),
        ]
        let locationConstraints = [
            location.centerXAnchor.constraint(equalTo: centerXAnchor),
            location.topAnchor.constraint(equalTo: temperature.bottomAnchor, constant: 30),
        ]
        NSLayoutConstraint.activate(imageConstraints + temperatureConstraints + locationConstraints)
    }
}
