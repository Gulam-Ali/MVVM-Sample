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
    
    
    //MARK: Diffable snapshots
    
    private func CreateSnapshot(from list:[resultsModel]){
        var snap = SnapShot()
        snap.appendSections([.first])
        snap.appendItems(list)
        datasourcee.apply(snap, animatingDifferences: true, completion: nil)
    }
    
    private func deleteMovie(from list:resultsModel,index:IndexPath){
        guard let objectIClickedOnto = datasourcee.itemIdentifier(for: index) else { return }
        var snapshot = datasourcee.snapshot()
        snapshot.deleteItems([objectIClickedOnto])
        datasourcee.apply(snapshot, animatingDifferences: true)
        nowPlayingViewModel.Movies.remove(at: index.row)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")
            deleteMovie(from: nowPlayingViewModel.Movies[indexPath.row], index: indexPath)
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}

// MARK: -  NowPlayingVM protocols
extension NowPlayingVC : NowPlayingProtocol{
    
    

    
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
