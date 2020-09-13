//
//  Utilities.swift
//  IniCuaca
//
//  Created by IndratS on 13/09/20.
//  Copyright © 2020 IndratSaputra. All rights reserved.
//

import Foundation

struct Utilities {
    
    func convertDate(dateUnix: Int) -> String{
            let timeResult = dateUnix
        let date = Date(timeIntervalSince1970: TimeInterval(timeResult))
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        return localDate
        }
    
    
    
}
