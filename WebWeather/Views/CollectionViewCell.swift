//
//  CollectionViewCell.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 12.09.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var selectedStack: UIStackView!

    @IBOutlet private var dateLabel: UILabel!
    
    @IBOutlet private var shortImage: UIImageView!
    @IBOutlet private var shortTemp: UILabel!
    @IBOutlet private var shortCondition: UILabel!
    @IBOutlet private var shortView: UIView!

    @IBOutlet private var nightImage: UIImageView!
    @IBOutlet private var nightTemp: UILabel!
    @IBOutlet private var nightCondition: UILabel!
    
    @IBOutlet private var morningImage: UIImageView!
    @IBOutlet private var morningTemp: UILabel!
    @IBOutlet private var morningCondition: UILabel!
    
    @IBOutlet private var dayImage: UIImageView!
    @IBOutlet private var dayTemp: UILabel!
    @IBOutlet private var dayCondition: UILabel!
    
    @IBOutlet private var eveningImage: UIImageView!
    @IBOutlet private var eveningTemp: UILabel!
    @IBOutlet private var eveningCondition: UILabel!
    
    func configureCell(at index: Int, with forecast: DayForecastWeather, tempUnit temp: String) {
        setupTitleTabel()
        setupShortenedCell()
        setupExpandedCell()
        
        func setupTitleTabel() {
            switch index {
            case 0:
                dateLabel.text = "Сегодня".uppercased()
            case 1:
                dateLabel.text = "Завтра".uppercased()
            default:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateToConvert = dateFormatter.date(from: forecast.date)
                dateFormatter.dateFormat = "d MMMM"
                dateFormatter.locale = .current
                dateLabel.text = dateFormatter.string(from: dateToConvert ?? Date.now).uppercased()
            }
        }
        
        func setupShortenedCell() {
            let tempMin = [
                forecast.parts.night.tempAvg,
                forecast.parts.morning.tempAvg,
                forecast.parts.day.tempAvg,
                forecast.parts.evening.tempAvg
            ].min() ?? 0
            let tempMax = [
                forecast.parts.night.tempAvg,
                forecast.parts.morning.tempAvg,
                forecast.parts.day.tempAvg,
                forecast.parts.evening.tempAvg
            ].max() ?? 0
            
            let min = temp == "ºF" ? tempMin.tempF() : tempMin.tempC()
            let max = temp == "ºF" ? tempMax.tempF() : tempMax.tempC()
            
            //shortView.backgroundColor =
            shortImage.image = UIImage(systemName: forecast.parts.day.condition.image)?
                .withRenderingMode(.alwaysOriginal)
            shortTemp.text = min + "..." + max
            shortCondition.text = forecast.parts.day.condition.formatted
        }
        
        func setupExpandedCell() {
            nightImage.image = UIImage(
                systemName: forecast.parts.night.condition.nightImage
            )?.withRenderingMode(.alwaysOriginal)
            nightTemp.text = temp == "ºF"
            ? forecast.parts.night.tempAvg.tempF()
            : forecast.parts.night.tempAvg.tempC()
            nightCondition.text = forecast.parts.night.condition.formatted

            morningImage.image = UIImage(
                systemName: forecast.parts.morning.condition.image
            )?.withRenderingMode(.alwaysOriginal)
            morningTemp.text = temp == "ºF"
            ? forecast.parts.morning.tempAvg.tempF()
            : forecast.parts.morning.tempAvg.tempC()
            morningCondition.text = forecast.parts.morning.condition.formatted
            
            dayImage.image = UIImage(
                systemName: forecast.parts.day.condition.image
            )?.withRenderingMode(.alwaysOriginal)
            dayTemp.text = temp == "ºF"
            ? forecast.parts.day.tempAvg.tempF()
            : forecast.parts.day.tempAvg.tempC()
            dayCondition.text = forecast.parts.day.condition.formatted

            eveningImage.image = UIImage(
                systemName: forecast.parts.evening.condition.image
            )?.withRenderingMode(.alwaysOriginal)
            eveningTemp.text = temp == "ºF"
            ? forecast.parts.evening.tempAvg.tempF()
            : forecast.parts.evening.tempAvg.tempC()
            eveningCondition.text = forecast.parts.evening.condition.formatted
        }
    }
}
