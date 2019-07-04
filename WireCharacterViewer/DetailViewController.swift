//
//  DetailViewController.swift
//  WireCharacterViewer
//
//  Created by Gregory Jones on 7/4/19.
//  Copyright © 2019 Gregory Jones. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
   @IBOutlet var titleLabel: UILabel!
   @IBOutlet var descriptionView: UITextView!
    @IBOutlet var characterImage: UIImageView!
    
    var detailCharacter: CharacterDetails? {
        didSet {
            configureView()
            
        }
    }
    
    /**
     Displays the Character's title, image, and description
 
    */
    func configureView() {
        if let detailCharacter = detailCharacter {
            if let descriptionView = descriptionView, let titleLabel = titleLabel  {
                descriptionView.text = detailCharacter.Text
                titleLabel.text = detailCharacter.Text
                
               let imageUrl = detailCharacter.Icon.URL
                characterImage.sd_setImage(with: URL(string: imageUrl!), placeholderImage: UIImage(named: "placeholder.png"))
             }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
