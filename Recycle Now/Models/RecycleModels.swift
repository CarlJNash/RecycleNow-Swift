//
//  RecycleModels.swift
//  Recycle Now
//
//  Created by Carl on 25/02/2018.
//  Copyright © 2018 CarlJNash. All rights reserved.
//

import Foundation

struct RecycleItems: Decodable {
    var items: [RecyclePoint]
    var latitide: Double?
    var longitude: Double?
}

struct RecyclePoint: Decodable {
    var id: Int
    var distance: Double
    var name: String
    var address: String
    var latitude: Double?
    var longitude: Double?
    var materials: [RecycleMaterials]
    var data_source: String
}

struct RecycleMaterials: Decodable {
    var category: String
    var code: String
    var name: String
}
