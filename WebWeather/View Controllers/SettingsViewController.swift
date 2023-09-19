//
//  SettingsViewController.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 17.09.2023.
//

import UIKit
import MapKit
import CoreLocation


final class SettingsViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var tempSC: UISegmentedControl!
    @IBOutlet private var windSpeedSC: UISegmentedControl!
    @IBOutlet private var pressureSC: UISegmentedControl!
    
    // MARK: - Public Properties
    var location: CLLocation!
    var settings: [String: String]!
    var delegate: SettingsViewControllerDelegate!

    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSCSelections()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
    }
    
    // MARK: - IB Actions
    @IBAction private func buttonTapped(_ sender: UIButton) {
        settings["temp"] = tempSC.titleForSegment(at: tempSC.selectedSegmentIndex)
        settings["windSpeed"] = windSpeedSC.titleForSegment(at: windSpeedSC.selectedSegmentIndex)
        settings["pressure"] = pressureSC.titleForSegment(at: pressureSC.selectedSegmentIndex)
        
        switch sender.titleLabel?.text {
        case "Сохранить":
            delegate.saveSettings(settings)
            fallthrough
        default:
            dismiss(animated: true)
        }
    }

    // MARK: - Private Methods
    private func setSCSelections() {
        switch settings["temp"] {
        case "ºF":
            tempSC.selectedSegmentIndex = 1
        default:
            tempSC.selectedSegmentIndex = 0
        }
        
        switch settings["windSpeed"] {
        case "ми/ч":
            windSpeedSC.selectedSegmentIndex = 0
        case "км/ч":
            windSpeedSC.selectedSegmentIndex = 1
        case "Бфт":
            windSpeedSC.selectedSegmentIndex = 3
        case "уз":
            windSpeedSC.selectedSegmentIndex = 4
        default:
            windSpeedSC.selectedSegmentIndex = 2
        }
        
        switch settings["pressure"] {
        case "мбар":
            pressureSC.selectedSegmentIndex = 0
        case "д. рт. ст.":
            pressureSC.selectedSegmentIndex = 1
        case "гПа":
            pressureSC.selectedSegmentIndex = 3
        case "кПа":
            pressureSC.selectedSegmentIndex = 4
        default:
            pressureSC.selectedSegmentIndex = 2
        }
    }
}
