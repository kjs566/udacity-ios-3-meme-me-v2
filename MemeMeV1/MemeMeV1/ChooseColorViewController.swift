//
//  ChooseColorViewController.swift
//  MemeMeV1
//
//  Created by Jan Skála on 26/03/2020.
//  Copyright © 2020 Jan Skála. All rights reserved.
//

import UIKit

class ChooseColorViewController: UIViewController {
    var screenTitle: String = ""
    var selectedValue: MemeColor.ColorIdentifier = .white
    var colorFor: MemeColor.ColorFor = .background
    
    weak var delegate: ChooseColorDelegate?
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var colorsStackView1: UIStackView!
    @IBOutlet weak var colorsStackView2: UIStackView!
    @IBOutlet weak var colorsStackView3: UIStackView!
    
    func setArguments(colorFor: MemeColor.ColorFor, currentColor: MemeColor.ColorIdentifier){
        self.selectedValue = currentColor
        self.colorFor = colorFor
        switch(colorFor){
        case .fontBorder(texts: _):
            screenTitle = "Choose text border color"
        case .fontColor(texts: _):
            screenTitle = "Choose text color"
        case .background:
            screenTitle = "Choose background colors"
        }
    }
    
    lazy var colorStacks = [
        colorsStackView1,
        colorsStackView2,
        colorsStackView3
    ]
    
    var colors = [
        MemeColor.availableColors[.black],
        MemeColor.availableColors[.blue],
        MemeColor.availableColors[.green],
        MemeColor.availableColors[.pink],
        MemeColor.availableColors[.yellow],
        MemeColor.availableColors[.white]
    ]
    var colorViews : [MemeColor.ColorIdentifier : UIButton]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createColorViews()
        titleView.text = screenTitle
        
    }
    
    func createColorViews(){
        let groupSize = colors.count / colorStacks.count
        var groupIndex = -1
        var groupStackView : UIStackView? = nil
        
        for (index, color) in colors.enumerated(){
            if(index % groupSize == 0){
                groupIndex += 1
                groupStackView = colorStacks[groupIndex]
            }
            let button = UIButton(type: .system)
            button.backgroundColor = color?.color
            button.setTitle(color?.identifier.rawValue, for: .normal)
            
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.accessibilityIdentifier = color?.identifier.rawValue
            
            button.addTarget(self, action: #selector(ChooseColorViewController.colorClicked(_:)), for: .touchUpInside)
            
            groupStackView?.addArrangedSubview(button)
        }
    }
    
    @objc
    func colorClicked(_ button: UIButton!){
        let color = MemeColor.ColorIdentifier.init(rawValue: button.accessibilityIdentifier!)!
        delegate?.colorChosen(colorFor: self.colorFor, newColor: MemeColor.availableColors[color]!)
        dismiss(animated: true, completion: nil)
    }
}

protocol ChooseColorDelegate: class{
    func colorChosen(colorFor: MemeColor.ColorFor, newColor: MemeColor)
}
