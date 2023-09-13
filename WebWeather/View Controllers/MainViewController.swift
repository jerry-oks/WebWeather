//
//  ViewController.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 10.09.2023.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet var loadingAIV: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!
    
    @IBOutlet var factView: UIView!
    @IBOutlet var forecastView: UIView!
    
    @IBOutlet var openMenuButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var updateWeatherButton: UIButton!
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var factIV: UIImageView!
    @IBOutlet var factTempLabel: UILabel!
    @IBOutlet var feelsLikeTempLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    
    private var weather: Weather!
    
    unowned var delegate: MainViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWeather()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let collectionVC = segue.destination as? CollectionViewController else { return }
        
        delegate = collectionVC
    }
    
    private func showFailAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так...",
            message: "Не удалось загрузить данные о погоде",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func openMenuButtonTapped() {
        changeMenuAppearance()
    }
    @IBAction func infoButtonTapped() {
        changeMenuAppearance()
    }
    @IBAction func updateWeatherButtonTapped() {
        changeMenuAppearance()
        updateWeather()
    }
    
    
    private func changeMenuAppearance() {
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
            infoButton.alpha = opened ? 0 : 1
            infoButton.frame.origin.y += opened ? -32 : 32
            
            updateWeatherButton.alpha = opened ? 0 : 1
            updateWeatherButton.frame.origin.y += opened ? -64 : 64
        }
    }
    
    private func updateWeather() {
        showLoading()
        
        NetworkManager.shared.fetchWeather(from: RequestURL.getURL()) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.setupInterface()
                    self?.delegate.updateForecast(with: weather.forecasts)
                    self?.showInterface()
                    print(weather)
                case .failure(let error):
                    self?.showFailAlert()
                    print(error)
                }
            }
        }
    }
    
    private func showInterface() {
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
    
    private func showLoading() {
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
    
    private func setupInterface() {
        cityLabel.text = "Сейчас в городе \(weather.geoObject.province.name)".uppercased()
        factIV.image = UIImage(systemName: weather.fact.condition.image)?.withRenderingMode(.alwaysOriginal)
        factTempLabel.text = weather.fact.temp.temp()
        feelsLikeTempLabel.text = "ощущается как " + weather.fact.feelsLike.temp()
        conditionLabel.text = weather.fact.condition.formatted
        
        detailsLabel.text =
            """
            \(weather.fact.windSpeed) м/с
            до \(weather.fact.windGust) м/с
            \(weather.fact.windDir)
            \(weather.fact.pressureMm) мм рт. ст.
            \(weather.fact.humidity)%
            """
    }
}


extension Int {
    func temp() -> String {
        var temp = ""
        
        switch self {
        case 1...: temp = "+\(self)º"
        case ..<0: temp = "-\(self)º"
        default: temp = "0º"
        }
        
        return temp
    }
}
