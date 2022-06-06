//
//  NowPlayingVC.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import UIKit

fileprivate typealias UserdataSource = UITableViewDiffableDataSource<NowPlayingVC.Tablesection,resultsModel>

fileprivate typealias SnapShot = NSDiffableDataSourceSnapshot<NowPlayingVC.Tablesection,resultsModel>

class NowPlayingVC: UIViewController {

    
    @IBOutlet weak var tblview: UITableView!
    
   fileprivate let nowPlayingViewModel = NowPlayingVM()
    
    fileprivate enum Tablesection{
            case first
        }
    
    private var datasourcee : UserdataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowPlayingViewModel.delegate = self
        nowPlayingViewModel.getNowPlayingMovies()
        SetupTableView()
    }
    
    private func SetupTableView(){
        tblview.delegate = self
        ConfigureDataSource()
        tblview.tableFooterView = UIView()
    }
    
    //MARK: Tableview diffable data source
    private func ConfigureDataSource(){
        datasourcee = UITableViewDiffableDataSource<Tablesection,resultsModel>(tableView: tblview, cellProvider: { [self] tableView, indexPath, modelObj in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NowPlayingCell") as? NowPlayingCell else {return UITableViewCell()}
            cell.movie = nowPlayingViewModel.Movies[indexPath.row]
            return cell
        })
    }
    
    @IBAction func votesOfHighestRatemovie(_ sender: Any) {
        let votes = nowPlayingViewModel.getHighestRatingMovieVotes()
        CommonFuncs.AlertWithOK(msg: "\(votes)", vc: self)
    }
    

}

// MARK: -  Tableview protocols
extension NowPlayingVC : UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hasMovieData = datasourcee.itemIdentifier(for: indexPath) else {return}
        print("Selected movie is -> ",hasMovieData.title ?? "")
    }
    
}

// MARK: -  NowPlayingVM protocols
extension NowPlayingVC : NowPlayingProtocol{
    
    
    private func CreateSnapshot(from list:[resultsModel]){
        var snap = SnapShot()
        snap.appendSections([.first])
        snap.appendItems(list)
        datasourcee.apply(snap, animatingDifferences: true, completion: nil)
    }
    
    func didgetMovies(Movies: [resultsModel]) {
        if Movies.count != 0{
            CreateSnapshot(from: Movies)
        }else{
            print("No movies in array")
        }
    }
    
    func didgetApiFailure(error: String) {
        CommonFuncs.AlertWithOK(msg: error, vc: self)
    }
    
    
}
