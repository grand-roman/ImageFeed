//
//  ViewController.swift
//  ImageFeed
//
//  Created by Pavel Razumov on 17.11.2022.
//

import UIKit

class ImagesListViewController: UIViewController {
    //MARK: IBOutlet
    @IBOutlet private var tableView: UITableView!
    //MARK: Private
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photosName = [String]()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosName = Array(0..<20).map{ "\($0)"}
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK: Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: "\(photosName[indexPath.row])_full_size") ?? UIImage(named: photosName[indexPath.row])

            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        cell.prepareForReuse()
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.setImage(UIImage(named: "Pressed"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "NotPressed"), for: .normal)
        }
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.gradientView.bounds
        gradientLayer.colors = [UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0).cgColor, UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0.2).cgColor]
        cell.gradientView.layer.addSublayer(gradientLayer)
    }
}
//MARK: Extensions
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}
