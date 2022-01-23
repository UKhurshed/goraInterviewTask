//
//  PhotoTableViewCell.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 23.01.2022.
//

import UIKit

/// TableView cell for Photo and Label
class PhotoTableViewCell: UITableViewCell {
    
    /// Title label
    @IBOutlet weak var titleLabel: UILabel!
    /// ImageView
    @IBOutlet weak var photoView: UIImageView!
    /// Main view
    @IBOutlet weak var cellView: UIView!
    
    var cornerRadius: CGFloat = 10.0{
        didSet{
            cellView.layer.cornerRadius = cornerRadius
        }
    }
    
    var shadowColor: UIColor = .black{
        didSet{
            cellView.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    var shadowOpacity: Float = 0.7{
        didSet{
            cellView.layer.shadowOpacity = shadowOpacity
        }
    }
    
    var shadowOffset = CGSize(width: 2.5, height: 2.5){
        didSet{
            cellView.layer.shadowOffset = shadowOffset
        }
    }
    
    var shadowRadius: CGFloat = 7.0 {
        didSet{
            cellView.layer.shadowRadius = shadowRadius
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        // Initialization code
        
    }
    
    /// Setup shadows to View
    private func setup(){
        self.cellView.layer.cornerRadius = cornerRadius
        self.cellView.clipsToBounds = true
        
        self.cellView.layer.shadowColor = shadowColor.cgColor
        self.cellView.layer.shadowRadius = shadowRadius
        self.cellView.layer.shadowOpacity = shadowOpacity
        self.cellView.layer.shadowOffset = shadowOffset
        
        let cgPath = UIBezierPath(roundedRect: self.cellView.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        self.cellView.layer.shadowPath = cgPath
    }

}
