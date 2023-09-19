//
//  ViewController.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 10.09.2023.
//

import UIKit
import CoreLocation

protocol SettingsViewControllerDelegate: AnyObject {
    func saveSettings(_ settings: [String: String])
}

final class MainViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private var loadingAIV: UIActivityIndicatorView!
    @IBOutlet private var loadingLabel: UILabel!
    
    @IBOutlet private var factView: UIView!
    @IBOutlet private var forecastView: UIView!
    
    @IBOutlet private var openMenuButton: UIButton!
    @IBOutlet private var settingsButton: UIButton!
    @IBOutlet private var updateWeatherButton: UIButton!
    
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var factIV: UIImageView!
    @IBOutlet private var factTempLabel: UILabel!
    @IBOutlet private var feelsLikeTempLabel: UILabel!
    @IBOutlet private var conditionLabel: UILabel!
    @IBOutlet private var detailsLabel: UILabel!
    
    // MARK: - Private Properties
    private var location: CLLocation!
    
    private var weather: Weather!
    
    private var settings: [String: String] = [
        "temp": "default",
        "windSpeed": "default",
        "pressure": "default"
    ]
    
    
    // MARK: - Delegate Properties
    unowned var delegate: MainViewControllerDelegate!
    
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        factView.alpha = 0
        forecastView.alpha = 0
        
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // MARK: - Segue Metods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let collectionVC = segue.destination as? CollectionViewController else {
            guard let settingsVC = segue.destination as? SettingsViewController else { return }
            settingsVC.settings = settings
            settingsVC.location = location
            settingsVC.delegate = self
            return
        }
        delegate = collectionVC
    }
    
    // MARK: - IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
        case updateWeatherButton:
            updateWeather()
            fallthrough
        case settingsButton:
            fallthrough
        default:
            changeMenuAppearance()
        }
    }
}

// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func saveSettings(_ settings: [String : String]) {
        self.settings = settings
        setupInterface()
        delegate.updateInterface(withTempUnit: settings["temp"] ?? "default")
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func updateWeather() {
        showLoading()
        
        NetworkManager.shared.fetchWeather(
            from: RequestURL.getURL(
                lat: String(location.coordinate.latitude),
                lon: String(location.coordinate.longitude)
            )
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.setupInterface()
                    self?.delegate.updateForecast(with: weather.forecasts)
                    self?.showInterface()
                    print(weather)
                case .failure(let error):
                    self?.showFailAlert(withTitle: "Что-то пошло не так", andMessage: "Не удалось загрузить данные о погоде.")
                    print(error)
                }
            }
        }
    }
    
    // MARK: - UI Methods
    func showLoading() {
        loadingLabel.isHidden = false
        loadingAIV.startAnimating()
        
        UIView.transition(
            with: view,
            duration: 0.15,
            options: .transitionCrossDissolve) { [unowned self] in
                factView.alpha = 0
                forecastView.alpha = 0
            }
    }
    
    func setupInterface() {
        //        factView.backgroundColor =
        cityLabel.text = "\(weather.geoObject.locality.name), погода сейчас".uppercased()
        factIV.image = UIImage(
            systemName: weather.fact.daytime == "n"
            ? weather.fact.condition.nightImage
            : weather.fact.condition.image
        )?.withRenderingMode(.alwaysOriginal)
        factTempLabel.text = settings["temp"] == "ºF"
        ? weather.fact.temp.tempF() + "F"
        : weather.fact.temp.tempC() + "C"
        feelsLikeTempLabel.text = "ощущается как " + (settings["temp"] == "ºF"
                                                      ? weather.fact.feelsLike.tempF()
                                                      : weather.fact.feelsLike.tempC())
        conditionLabel.text = weather.fact.condition.formatted
        
        detailsLabel.text =
            """
            \(correctFormatFor(windSpeed: weather.fact.windSpeed))
            до \(correctFormatFor(windSpeed: weather.fact.windGust, gustCorrectionEnabled: true))
            \(weather.fact.windDir.formatted)
            \(correctFormatFor(pressure: weather.fact.pressureMm))
            \(weather.fact.humidity)%
            """
    }
    
    func showInterface() {
        UIView.transition(
            with: view,
            duration: 0.15,
            options: .transitionCrossDissolve) { [unowned self] in
                factView.alpha = 1
                forecastView.alpha = 1
            } completion: { [unowned self] _ in
                loadingLabel.isHidden = true
                loadingAIV.stopAnimating()
            }
    }
    
    func changeMenuAppearance() {
        let opened = openMenuButton.imageView?.image == UIImage(systemName: "chevron.up")
        
        UIView.transition(
            with: openMenuButton,
            duration: 0.2,
            options: opened ? .transitionFlipFromTop : .transitionFlipFromBottom
        ) { [unowned self] in
            openMenuButton.setImage(
                UIImage(systemName: opened ? "chevron.down" : "chevron.up"),
                for: .normal
            )
        }
        
        UIView.animate(withDuration: 0.25) { [unowned self] in
            settingsButton.alpha = opened ? 0 : 1
            settingsButton.frame.origin.y += opened ? -32 : 32
            
            updateWeatherButton.alpha = opened ? 0 : 1
            updateWeatherButton.frame.origin.y += opened ? -64 : 64
        }
    }
    
    // MARK: -  Alert Methods
    func showFailAlert(withTitle title: String, andMessage message: String, completion: @escaping (UIAlertAction) -> Void = { _ in }) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Correct Format Methods
    func correctFormatFor(windSpeed: Double, gustCorrectionEnabled: Bool = false) -> String {
        var correctWindSpeed = ""
        
        switch settings["windSpeed"] {
        case "ми/ч":
            correctWindSpeed = windSpeed.mph()
        case "км/ч":
            correctWindSpeed = windSpeed.kmh()
        case "Бфт":
            correctWindSpeed = gustCorrectionEnabled ? windSpeed.ms() : windSpeed.bft()
        case "уз":
            correctWindSpeed = gustCorrectionEnabled ? windSpeed.ms() : windSpeed.kn()
        default:
            correctWindSpeed = windSpeed.ms()
        }
        
        return correctWindSpeed
    }
    
    func correctFormatFor(pressure: Double) -> String {
        var correctPressure = ""
        
        switch settings["pressure"] {
        case "мбар":
            correctPressure = pressure.mbar()
        case "д. рт. ст.":
            correctPressure = pressure.inHg()
        case "гПа":
            correctPressure = pressure.hPa()
        case "кПа":
            correctPressure = pressure.kPa()
        default:
            correctPressure = pressure.mmHg()
        }
        
        return correctPressure
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            updateWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showFailAlert(
            withTitle: "Нет доступа к данным о местоположении",
            andMessage: "Загружаем погоду для города Москва."
        ) { [weak self] _ in
            self?.location = CLLocation(latitude: 55.7522, longitude: 37.6156)
            self?.updateWeather()
        }
    }
}
