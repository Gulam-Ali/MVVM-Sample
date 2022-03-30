//
//  NowPlayingVM.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import Foundation

protocol NowPlayingProtocol : AnyObject {
    func didgetMovies(Movies:[resultsModel])
    func didgetApiFailure(error:String)
}

class NowPlayingVM{
    
    var Movies:[resultsModel] = [resultsModel]()
    weak var delegate : NowPlayingProtocol!
    
    //MARK: Get Now playing movies
    func getNowPlayingMovies(){
        let serverURL = Endpoints.baseurl + Endpoints.getnowPlayingMovie
        Networking.shared.MakeGetRequest(Url: serverURL) { [self] (result : Result<NowplayingModel,CustomError>) in
        
            switch result {
            case .success(let response):
                guard let hasMovies = response.results else {return}
                FilterMoviesByRating(movies: hasMovies)
                break
                
            case .failure(let failedcase):
                HandleAPIfailureCases(cases: failedcase)
                break
            
            }
            
        }
    }
    
    //MARK: Handle API errors
    private func HandleAPIfailureCases(cases:CustomError){
        switch cases {
        case .noInternet:
            print("No internet connection")
            self.delegate.didgetApiFailure(error: "No internet connection")
        case .badStatusCode:
            print("status code is not 200")
            self.delegate.didgetApiFailure(error: "status code is not 200")
        case.errorfetchingData:
            print("error fetching data")
            self.delegate.didgetApiFailure(error: "error fetching data")
        default:
            print("Got error case")
            self.delegate.didgetApiFailure(error: "Something went wrong,Try again later")
        }
    }
    
    
    //MARK: Filtering movies by highest rating
     func FilterMoviesByRating(movies:[resultsModel]){
        let ratingDescending = movies.sorted { (a,b) in
            return a.vote_average ?? 0.0 > b.vote_average ?? 0.0
        }
        print("count ->",ratingDescending.count)
        Movies = ratingDescending
        delegate.didgetMovies(Movies: Movies)
    }
    
    //MARK: Get vote count of highest rating movie
     func getHighestRatingMovieVotes() -> Int{
        return Movies.first?.vote_count ?? 0
    }
    
}
