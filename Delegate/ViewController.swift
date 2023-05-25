//
//  ViewController.swift
//  Delegate
//
//  Created by Nick Liu on 2023/5/24.
//

import UIKit

class ViewController: UIViewController, SelectionViewDelegate, SelectionViewDataSource {
    
    var topButtons = topSource
    
    var bottomButtons = bottomSource
    
    let topSelectionView = SelectionView()
    
    let bttmSelectionView = SelectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupSelectionViews()
    }
    
    func setupSelectionViews() {

        topSelectionView.delegate = self
        topSelectionView.dataSource = self
        bttmSelectionView.delegate = self
        bttmSelectionView.dataSource = self
        
        [topSelectionView, bttmSelectionView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false}
        
        [topSelectionView, bttmSelectionView ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
        
            topSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topSelectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            topSelectionView.heightAnchor.constraint(equalToConstant: 160),
            
            bttmSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bttmSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bttmSelectionView.topAnchor.constraint(equalTo: topSelectionView.bottomAnchor, constant: 100),
            bttmSelectionView.heightAnchor.constraint(equalToConstant: 160),
            
        ])
        
        topSelectionView.configureStackViews(buttonModels: topButtons)
        bttmSelectionView.configureStackViews(buttonModels: bottomButtons)
    }
    
    
    func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool {
        if selectionView === topSelectionView {
            if index == (topSelectionView.buttons.count - 1) {
                bttmSelectionView.isUserInteractionEnabled = false
            } else {
                bttmSelectionView.isUserInteractionEnabled = true
            }
        }
        return true
    }

    
    func titleColorForButton(at index: Int) -> UIColor {
        .white
    }
    
    func buttonFontSize() -> CGFloat {
        18
    }
    
    func indicatorViewColor() -> UIColor {
        .white
    }

    func numberOfButtons(for selectionView: SelectionView) -> Int {
        if selectionView == topSelectionView {
            return topButtons.count
        } else if selectionView == bttmSelectionView {
            return bottomButtons.count
        } else {
            return 0 // Return the appropriate number of buttons for upcoming views
        }
    }
}

