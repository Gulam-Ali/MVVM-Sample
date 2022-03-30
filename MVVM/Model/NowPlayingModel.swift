//
//  NowPlayingModel.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import Foundation

struct NowplayingModel : Decodable {
    var results : [resultsModel]?
}

struct resultsModel : Decodable {
    var adult : Bool?
    var backdrop_path : String?
    var id : Int?
    var overview : String?
    var poster_path : String?
    var title : String?
    var vote_average : Double?
    var vote_count : Int?
}


