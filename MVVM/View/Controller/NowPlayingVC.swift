//
//  NowPlayingVC.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import UIKit

class NowPlayingVC: UIViewController {

    
    @IBOutlet weak var tblview: UITableView!
    
    private let nowPlayingViewModel = NowPlayingVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingViewModel.delegate = self
        nowPlayingViewModel.getNowPlayingMovies()
        SetupTableView()
    }
    
    private func SetupTableView(){
        tblview.delegate = self
        tblview.dataSource = self
        tblview.tableFooterView = UIView()
    }
    
    
    @IBAction func votesOfHighestRatemovie(_ sender: Any) {
        let votes = nowPlayingViewModel.getHighestRatingMovieVotes()
        CommonFuncs.AlertWithOK(msg: "\(votes)", vc: self)
    }
    

}

// MARK: -  Tableview protocols
extension NowPlayingVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowPlayingViewModel.Movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NowPlayingCell") as? NowPlayingCell else {return UITableViewCell()}
        cell.movie = nowPlayingViewModel.Movies[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
}

// MARK: -  NowPlayingVM protocols
extension NowPlayingVC : NowPlayingProtocol{
    
    func didgetMovies(Movies: [resultsModel]) {
        if Movies.count != 0{
            DispatchQueue.main.async {
                self.tblview.reloadData()
            }
        }else{
            print("No movies in array")
        }
    }
    
    func didgetApiFailure(error: String) {
        CommonFuncs.AlertWithOK(msg: error, vc: self)
    }
    
    
}
