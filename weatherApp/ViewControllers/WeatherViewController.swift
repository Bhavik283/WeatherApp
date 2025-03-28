//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Bhavik Goyal on 12/12/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    public var searchData: String = ""
    
    let locationManager = CLLocationManager()
    
    let apiCaller = APICaller()
    
    private var searchView: SearchView = {
        let vc = SearchView()
        vc.locationLabel = "get location"
        vc.searchLabel = "get weather"
        vc.locationTraits = [.button, .allowsDirectInteraction]
        vc.searchTraits = [.button, .allowsDirectInteraction]
        vc.searchTextTraits = [.searchField]
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private let dataView: DataView = {
        let vc = DataView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    private var languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private var pButton: CustomButton = {
        let button = CustomButton()
        button.setTextValue("My Button")
        button.setKindValue(.primary)
        button.setSizeValue(.large)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgorundImage1")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        view.addSubview(searchView)
        view.addSubview(dataView)
//        view.addSubview(pButton)
        setupLocationManager()
        searchView.delegate = self
        apiCaller.delegate = self
        applyConstraints()
        fomatterString()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    func fomatterString() {
        languageLabel.text = NSLocalizedString("hello", comment: "")
    }
}


extension WeatherViewController: SearchDelegate{
    func LabelDataDelegate(label: String) {
        self.searchData = label
        searchView.searchTextLabel = label
    }
    
    func LocationDelegate() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func pressSearchDelegate() {
        print(self.searchData)
        apiCaller.getWeather(with: self.searchData)
    }
}

extension WeatherViewController{
    private func applyConstraints(){
        let searchViewConstraints = [
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 50)
        ]
        let dataViewConstraints = [
            dataView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 20),
            dataView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dataView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dataView.heightAnchor.constraint(equalToConstant: 250)
        ]
//        let labelViewConstraints = [
//            pButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            pButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
//        ]
//        pButton.setRadiusValue(50)
//        pButton.addTarget(self, action: #selector(button1), for: .touchUpInside)
        NSLayoutConstraint.activate(searchViewConstraints)
        NSLayoutConstraint.activate(dataViewConstraints)
//        NSLayoutConstraint.activate(labelViewConstraints)
    }
    
    @objc private func button1() {
        if pButton.pButtonKind == .primary {
            pButton.setKindValue(.secondary)
        } else {
            pButton.setKindValue(.primary)
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        apiCaller.getWeatherCoord(with: longitude, lat: latitude)
        print("Latitude: \(latitude), Longitude: \(longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension WeatherViewController: APIDelegate{
    func getSuccess(weatherData: WeatherData) {
        DispatchQueue.main.async {
            self.dataView.configure(with: weatherData)
        }
    }
    
    func getFailure(error: Error) {
        print(error.localizedDescription)
    }
}
