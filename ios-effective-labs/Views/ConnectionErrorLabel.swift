//
//  ConnectionErrorLabel.swift
//  ios-effective-labs
//
//  Created by test on 11.04.2023.
//

import UIKit

class ConnectionErrorLabel: UILabel {
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let connectionErrorLabel: UILabel = {
        let connectionErrorMessage = UILabel()
        connectionErrorMessage.text = "Offline Mode! Showing cached data"
        connectionErrorMessage.textColor = .red
        connectionErrorMessage.translatesAutoresizingMaskIntoConstraints = false
        connectionErrorMessage.textAlignment = .center
        connectionErrorMessage.alpha = 0
        return connectionErrorMessage
    }()
    
    func show() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.connectionErrorLabel.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5) { [self] in
            self.connectionErrorLabel.alpha = 0
        }
    }
    
    private func setupLayout() {
        addSubview(connectionErrorLabel)
        
        connectionErrorLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        connectionErrorLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        connectionErrorLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        connectionErrorLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
