//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Pavel Razumov on 19.11.2022.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!

    //Функция для обнуления gradientView
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.gradientView.layer.sublayers = nil
    }
}
