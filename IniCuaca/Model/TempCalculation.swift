
//
//  TemperatureCalculation.swift
//  IniCuaca
//
//  Created by IndratS on 13/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation

struct TempCalculation {
    
    func fahrenheitToCelcius(fahrenheit: Double) -> Double{
        var celsius: Double
        
        celsius = (fahrenheit - 32) * 5 / 9
        return celsius
    }
    
    func kelvinToCelcius(kelvin: Double) -> Double {
        var celcius: Double
        
        celcius = (kelvin - 273.15)
        return celcius
    }
    
    
}
