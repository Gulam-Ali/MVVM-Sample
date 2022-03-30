//
//  NowPlayingCell.swift
//  MVVM
//
//  Created by Gulam Ali on 30/03/22.
//

import UIKit

class NowPlayingCell: UITableViewCell {

    
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var movietitle: UILabel!
    @IBOutlet weak var MovieImage: UIImageView!
    
    var movie : resultsModel!{
        didSet{
            movietitle.text = movie.title ?? ""
            movieDesc.text = movie.overview ?? ""
            let posterendpoint =  movie.poster_path ?? ""
            let posterpath = "\(Endpoints.imageURL)\(posterendpoint)"
            guard let posterUrl = URL(string: posterpath) else {return}
            MovieImage.loadImageWithUrl(posterUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
