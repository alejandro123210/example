//
//  Building.swift
//  example
//
//  Created by Alejandro Gonzalez on 4/12/18.
//  Copyright © 2018 dostuff. All rights reserved.
//

import Foundation
class Building: NSObject {
    var buildingDescription: String?
    var buildingName: String?
    
    init(descriptio: String, name: String) {
        buildingName = name
        buildingDescription = descriptio
    }
}
