//
//  CLPlacemark+Continental.swift
//  Continental
//
//  Created by Bruno Scheele on 29/10/15.
//  Copyright © 2015 Noodlewerk Apps. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    var continentCode: String? {
        get {
            guard let countryCode = ISOcountryCode else {
                return nil
            }
            return continentCodeForCountryCode(countryCode)
        }
    }
}
