//
//  Continental.swift
//  Continental
//
//  Created by Bruno Scheele on 29/10/15.
//  Copyright © 2015 Noodlewerk Apps. All rights reserved.
//

import Foundation

enum CountryToContinentError: ErrorType {
    case CouldNotFindSourcePlist
    case CouldNotDecodePlist
    case PlistMalformed
    
    var message: String {
        switch self {
        case .CouldNotFindSourcePlist: return "Could not find countries_by_contintent.plist in main bundle."
        case .CouldNotDecodePlist: return "Failed to decode countries_by_continent.plist to NSDictionary"
        case .PlistMalformed: return "Plist is malformed."
        }
    }
}

private func countriesByContinentDictionary() throws -> NSDictionary {
    guard let plistURL = NSBundle.mainBundle().URLForResource("countries_by_continent", withExtension: "plist")
        else {
            throw CountryToContinentError.CouldNotFindSourcePlist
    }
    guard let result = NSDictionary(contentsOfURL: plistURL)
        else {
            throw CountryToContinentError.CouldNotDecodePlist
    }
    return result
}

func continentCodeForCountryCode(code: String) -> String? {
    do {
        let continentList = try countriesByContinentDictionary()
        for continentCode in continentList.allKeys as! [String] {
            guard let countryList = continentList.objectForKey(continentCode) as? [String: String] else {
                throw CountryToContinentError.PlistMalformed
            }
            for countryCode in countryList.keys {
                if countryCode == code {
                    return continentCode
                }
            }
        }
        return nil
    }
    catch let error as CountryToContinentError {
        print("Error: \(error.message)")
        return nil
    }
    catch {
        print("Error: an unknown error occured.")
        return nil
    }
}
