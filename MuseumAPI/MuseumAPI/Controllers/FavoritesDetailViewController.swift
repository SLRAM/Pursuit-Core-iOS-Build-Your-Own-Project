//
//  FavoritesDetailViewController.swift
//  MuseumAPI
//
//  Created by Stephanie Ramirez on 1/6/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

class FavoritesDetailViewController: UIViewController {
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var favoriteName: UILabel!
    @IBOutlet weak var favoriteDepartment: UILabel!
    @IBOutlet weak var favoriteArtist: UILabel!
    
    public var favorite: Favorite!
    private var object: ObjectData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateObject()
    }
    private func updateObject() {
        print(favorite)
        MuseumAPIClient.searchEvents(keyword: favorite.objectID) { (appError, object) in
            if let appError = appError {
                print(appError.errorMessage())
            } else if let object = object {
                self.object = object
                print(object)
                DispatchQueue.main.async {
                    self.favoriteName.text = object.title
                    self.favoriteDepartment.text = object.department
                    self.favoriteArtist.text = object.artistDisplayName
                    if let imageUrl = object.primaryImage {
                        if let image = ImageClient.getImage(StringURL: imageUrl) {
                            self.favoriteImage.image = image
                        }
                    }
                }
            }
        }
    }

}
