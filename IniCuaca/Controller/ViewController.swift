//
//  ViewController.swift
//  IniCuaca
//
//  Created by IndratS on 12/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var visibiltyView: UIView!
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var locationManager: CLLocationManager?
    var weatherManager = WeatherManager()
    
    var listOfWeather: WeatherModel?
    {
        didSet{
            DispatchQueue.main.async {
                self.launchUI()
                self.customLayout()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        //request auth
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = 200
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        
        
    }
    
    // MARK: CUSTOM LAYOUT
    func customLayout(){
        pressureView.layer.cornerRadius = 10
        pressureView.backgroundColor = .white
        
        humidityView.layer.cornerRadius = 10
        humidityView.backgroundColor = .white
        
        visibiltyView.layer.cornerRadius = 10
        visibiltyView.backgroundColor = .white
        
        windView.layer.cornerRadius = 10
        windView.backgroundColor = .white
    }
    
    // MARK: prepare data from struct
    func prepareData() -> [String: String]{
        var data: [ String : String] = [:]
        
        if let pressure = listOfWeather?.main?.pressure
            , let humidity = listOfWeather?.main?.humidity
            , let visibility = listOfWeather?.visibility
            , let wind = listOfWeather?.wind?.speed
            , let minTemp = listOfWeather?.main?.temp_min
            , let maxTemp = listOfWeather?.main?.temp_max
            , let temp = listOfWeather?.main?.temp
            , let code = listOfWeather?.weather[0].icon
            , let city = listOfWeather?.name
        {
            
            let urlImage = "http://openweathermap.org/img/wn/\(code)@2x.png"
            
            data["pressure"] = String(pressure)
            data["humidity"] = String(humidity)
            data["visibility"] = String(visibility)
            data["wind"] = String(wind)
            data["minTemp"] = String(minTemp)
            data["maxTemp"] = String(maxTemp)
            data["temp"] = String(temp)
            data["urlImage"] = urlImage
            data["city"] = city
        }
        
        return data
    }
    
    
    func launchUI(){
        
        var data = prepareData()
        
        
        pressureLabel.text = data["pressure"]
        humidityLabel.text = data["humidity"]
        visibilityLabel.text = data["visibility"]
        windLabel.text = data["wind"]
        tempMinLabel.text = data["min_temp"]
        tempMaxLabel.text = data["max_temp"]
        tempLabel.text = data["temp"]
        cityLabel.text = data["city"]
        
        //        let code = listOfWeather?.weather[0].icon
        //        guard let url = URL(string: "http://openweathermap.org/img/wn/\(code ?? "01d")@2x.png") else {return}
        //        print(url)
        //        weatherImage.downloaded(from: url, contentMode: .scaleAspectFill)
        //
        //        descriptionLabel.text = "\(listOfWeather?.weather[0].description!)"
        
        
    }
    
    // MARK: getlocation
    func getLocation(coordinate: [String: String]){
        weatherManager.getURL(coordinate: coordinate) { [weak self] result in
            switch result {
            case .success(let data):
                self?.listOfWeather = data
                
            case .failure(let err):
                let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self!.present(alert, animated: true)
            }
            
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // handle call back from cllocationmanager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            print("LocationManager didchangeAuth Denied !")
        case .notDetermined:
            print("locationManager didchangeAuth not Determined")
        case .authorizedWhenInUse:
            print("LocationManager Authorized")
            
        // request one time location information
        case .authorizedAlways:
            print("locationManager Authorized Always")
            locationManager?.requestLocation()
            
        case .restricted:
            print("locationManager restristed")
        default:
            print("locationManager didChangeAuthorized")
        }
    }
    
    // MARK: handle location information
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print(locations)
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            self.locationManager?.stopUpdatingLocation()
            
            let lat = String(location.coordinate.latitude)
            let long = String(location.coordinate.longitude)
            
            var coord: [String : String] = [:]
            coord["lat"] = lat
            coord["lon"] = long
            
            getLocation(coordinate: coord)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error \(error.localizedDescription)")
        
        if let error = error as? CLError, error.code == .denied {
            locationManager?.stopMonitoringSignificantLocationChanges()
            return
        }
    }
    
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
