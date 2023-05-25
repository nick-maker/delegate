//
//  SelectionView.swift
//  Delegate
//
//  Created by Nick Liu on 2023/5/24.
//

import UIKit

class SelectionView: UIView {
    
    weak var delegate: SelectionViewDelegate?
    weak var dataSource: SelectionViewDataSource? {
        didSet {
            configureStackViews(buttonModels: [])
            configureColorView()
        }
    }
    
    var indicatorView = UIView()
    var colorView = UIView()
    var stackView: UIStackView
    var buttons: [UIButton] = []
    var constraintsArray: [NSLayoutConstraint] = [] {
        didSet {
            UIKit.NSLayoutConstraint.deactivate(oldValue)
            UIKit.NSLayoutConstraint.activate(constraintsArray)
        }
    }
    
    override init(frame: CGRect) {
        stackView = UIStackView() //has to be before super.init
        super.init(frame: frame)
        [ stackView, indicatorView, colorView ].forEach{ addSubview($0) }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStackViews(buttonModels: [ButtonModel]) {
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        let numberOfButtons = buttonModels.count
        
        for index in 0..<numberOfButtons {
            let button = UIButton()
            button.setTitle(buttonModels[index].title, for: .normal)
            button.setTitleColor(dataSource?.titleColorForButton(at: index), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: dataSource?.buttonFontSize() ?? 18)
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
            configureIndicatorView()
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.bottomAnchor.constraint(equalTo: colorView.topAnchor, constant: 2),
        ])
        
    }
    
    func configureIndicatorView() {
        indicatorView.backgroundColor = dataSource?.indicatorViewColor() ?? .white
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        constraintsArray = [
            indicatorView.centerXAnchor.constraint(equalTo: buttons[0].centerXAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: colorView.topAnchor),
            indicatorView.widthAnchor.constraint(equalTo: buttons[0].widthAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 3)
        ]
        NSLayoutConstraint.activate(constraintsArray)
    }

    func configureColorView() {
        guard let buttonModel = dataSource?.topButtons.first else {
            return
        }
        
        colorView.backgroundColor = buttonModel.color
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else {
            return
        }
        
        var buttonModels: [ButtonModel]
        if index < dataSource?.topButtons.count ?? 0 {
            buttonModels = dataSource?.topButtons ?? []
        } else {
            buttonModels = dataSource?.bottomButtons ?? []
        }
        
        let buttonModel = buttonModels[index]
        colorView.backgroundColor = buttonModel.color
        
        constraintsArray = [
            indicatorView.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: colorView.topAnchor),
            indicatorView.widthAnchor.constraint(equalTo: sender.widthAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 3)
        ]
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.layoutIfNeeded()
        }
        animator.startAnimation()
        
        // Call the delegate method
        delegate?.didSelectedButton?(self, at: index)
        
        
    }
    
    
}

@objc protocol SelectionViewDelegate: AnyObject {
    
    @objc optional func didSelectedButton(_ selectionView: SelectionView, at index: Int)
    
    @objc optional func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool
    
}

protocol SelectionViewDataSource: AnyObject {
    var topButtons: [ButtonModel] { get }
    var bottomButtons: [ButtonModel] { get }
    func numberOfButtons(for selectionView: SelectionView) -> Int
    func titleColorForButton(at index: Int) -> UIColor
    func buttonFontSize() -> CGFloat
    func indicatorViewColor() -> UIColor
    
}
