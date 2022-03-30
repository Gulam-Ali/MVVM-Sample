//
//  EndPoints.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import Foundation

// MARK: -  TMDB API Key
struct Api_Key {
    static let key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
}

// MARK: -  APIs
struct Endpoints {

    static let baseurl = "https://api.themoviedb.org/3/"
    
    static let getnowPlayingMovie = "movie/now_playing?api_key=\(Api_Key.key)"
    static let imageURL = "https://image.tmdb.org/t/p/w400"
    
    
}
