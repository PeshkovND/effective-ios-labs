//
//  DetailsViewController.swift
//  ios-effective-labs
//
//  Created by test on 26.02.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    struct Model {
        let name: String
        let imageUrl: URL?
        let description: String
    }

    private enum Layout {
        static let detailsLabelLeftConstraintValue = CGFloat(32)
        static let detailsLabelRightConstraintValue = CGFloat(-32)
        static let detailsDescriptionTextViewLeftConstraintValue = CGFloat(32)
        static let detailsDescriptionTextViewRightConstraintValue = CGFloat(-32)
        static let detailsDescriptionTextViewBottomConstraintValue = CGFloat(-16)
        static let detailsDescriptionTextViewHeightConstraintMultiplier = CGFloat(0.4)
    }
    
    private let detailsImageView: UIImageView = {
        let detailsImageView = UIImageView()
        detailsImageView.translatesAutoresizingMaskIntoConstraints = false
        detailsImageView.contentMode = .scaleAspectFill
        detailsImageView.isUserInteractionEnabled = true
        detailsImageView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        return detailsImageView
    }()
    
    private let backBarButtonItem: UIBarButtonItem = {
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.title = ""
        return backBarButtonItem
    }()
    
    private let detailsLabel: UILabel = {
        let detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.textColor = .white
        detailsLabel.font = UIFont.boldSystemFont(ofSize: 32)
        detailsLabel.numberOfLines = 0
        return detailsLabel
    }()
    
    private let detailsDescriptionTextView: UITextView = {
        let detailsDescription = UITextView()
        detailsDescription.translatesAutoresizingMaskIntoConstraints = false
        detailsDescription.textColor = .white
        detailsDescription.font = UIFont.systemFont(ofSize: 24)
        detailsDescription.backgroundColor = .none
        detailsDescription.isScrollEnabled = true
        detailsDescription.isUserInteractionEnabled = true
        detailsDescription.isEditable = false
        
        return detailsDescription
    }()
    
    private func setupLayout() {
        
        view.addSubview(detailsImageView)
        view.clipsToBounds = true
        detailsImageView.addSubview(detailsLabel)
        detailsImageView.addSubview(detailsDescriptionTextView)
        
        detailsImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        detailsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailsImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailsImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        detailsDescriptionTextView.bottomAnchor.constraint(equalTo: detailsImageView.bottomAnchor, constant: Layout.detailsDescriptionTextViewBottomConstraintValue).isActive = true
        detailsDescriptionTextView.leftAnchor.constraint(equalTo: detailsImageView.leftAnchor, constant: Layout.detailsDescriptionTextViewLeftConstraintValue).isActive = true
        detailsDescriptionTextView.rightAnchor.constraint(equalTo: detailsImageView.rightAnchor, constant: Layout.detailsDescriptionTextViewRightConstraintValue).isActive = true
        detailsDescriptionTextView.heightAnchor.constraint(equalTo: detailsImageView.heightAnchor, multiplier: Layout.detailsDescriptionTextViewHeightConstraintMultiplier).isActive = true
        
        detailsLabel.leftAnchor.constraint(equalTo: detailsImageView.leftAnchor, constant: Layout.detailsLabelLeftConstraintValue).isActive = true
        detailsLabel.rightAnchor.constraint(equalTo: detailsImageView.rightAnchor, constant: Layout.detailsLabelRightConstraintValue).isActive = true
        detailsLabel.bottomAnchor.constraint(equalTo: detailsDescriptionTextView.topAnchor).isActive = true
        
    }

    func setupData(_ model: Model) {
        detailsImageView.setImageUrl(url: model.imageUrl)
        detailsLabel.text = model.name
        detailsDescriptionTextView.text = model.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        setupLayout()
    }
}
