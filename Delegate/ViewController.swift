//
//  ViewController.swift
//  Delegate
//
//  Created by Nick Liu on 2023/5/24.
//

import UIKit

class ViewController: UIViewController, SelectionViewDelegate, SelectionViewDataSource {
    
    let topSelectionView = SelectionView()
    
    let bttmSelectionView = SelectionView()
    
    var isSelectable = true
    var isTopLastButtonSelected = false
    
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
        
    }
    
    
    func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
        if selectionView == topSelectionView {
            selectionView.colorView.backgroundColor = topSource[index].color
            isTopLastButtonSelected = (index == topSelectionView.buttons.count - 1)
        } else {
            selectionView.colorView.backgroundColor = bottomSource[index].color
        }
    }
    
    func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool {
        if selectionView == topSelectionView {
            return true
        } else if selectionView == bttmSelectionView {
            if isTopLastButtonSelected {
                return false
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
    
    func setButtons(at index: Int) -> ButtonModel {
        if index < topSource.count {
            return topSource[index]
        } else {
            return bottomSource[index]
        }
    }
//
//    func setButtons(at index: Int) -> [ButtonModel] {
//        if index < topSource.count {
//            return topSource
//        } else {
//            return bottomSource
//        }
//    }
    
    func numberOfButtons(for selectionView: SelectionView) -> Int {
        if selectionView == topSelectionView {
            return topSource.count
        } else if selectionView == bttmSelectionView {
            return bottomSource.count
        } else {
            return 0
        }
    }
}

