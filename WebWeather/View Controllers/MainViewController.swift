//
//  ViewController.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 10.09.2023.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - IB Outlets
    @IBOutlet private var loadingAIV: UIActivityIndicatorView!
    @IBOutlet private var loadingLabel: UILabel!
    
    @IBOutlet private var factView: UIView!
    @IBOutlet private var forecastView: UIView!
    
    @IBOutlet private var openMenuButton: UIButton!
    @IBOutlet private var infoButton: UIButton!
    @IBOutlet private var updateWeatherButton: UIButton!
    
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var factIV: UIImageView!
    @IBOutlet private var factTempLabel: UILabel!
    @IBOutlet private var feelsLikeTempLabel: UILabel!
    @IBOutlet private var conditionLabel: UILabel!
    @IBOutlet private var detailsLabel: UILabel!
    
    // MARK: - Private Properties
    private var weather: Weather!
    
    // MARK: - Delegate Properties
    unowned var delegate: MainViewControllerDelegate!
    
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeather()
    }
    
    // MARK: - Segue Metods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let collectionVC = segue.destination as? CollectionViewController else { return }
        delegate = collectionVC
    }
    
    // MARK: - IB Actions
    @IBAction private func openMenuButtonTapped() {
        changeMenuAppearance()
    }
    @IBAction private func infoButtonTapped() {
        changeMenuAppearance()
    }
    @IBAction private func updateWeatherButtonTapped() {
        changeMenuAppearance()
        updateWeather()
    }   
}

// MARK: - Private Methods
private extension MainViewController {
    func updateWeather() {
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
            infoButton.alpha = opened ? 0 : 1
            infoButton.frame.origin.y += opened ? -32 : 32
            
            updateWeatherButton.alpha = opened ? 0 : 1
            updateWeatherButton.frame.origin.y += opened ? -64 : 64
        }
    }
    
    // MARK: -  Alert Methods
    func showFailAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так...",
            message: "Не удалось загрузить данные о погоде",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}
