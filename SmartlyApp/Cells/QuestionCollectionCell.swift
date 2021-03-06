//
//  QuestionCollectionCell.swift
//  SmartlyApp
//
//  Created by Azhar on 05/03/2021.
//

import UIKit

protocol SelectOptionDelegate: class {
    func selectOptionAction(option: String)
}

class QuestionCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstOptionBtn: UIButton!
    @IBOutlet weak var secondOptionBtn: UIButton!
    @IBOutlet weak var thirdOptionBtn: UIButton!
    @IBOutlet weak var forthOptionBtn: UIButton!
    
    weak var selectOptionDelegate: SelectOptionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateCell(data: Question) {
        
        categoryNameLabel.text = data.category
        questionLabel.text = data.question
        
        firstOptionBtn.setTitle(data.incorrectAnswers[0], for: .normal)
        secondOptionBtn.setTitle(data.incorrectAnswers[1], for: .normal)
        
        if data.type == .multiple {
            
            thirdOptionBtn.isHidden = false
            forthOptionBtn.isHidden = false
            
            thirdOptionBtn.setTitle(data.incorrectAnswers[2], for: .normal)
            forthOptionBtn.setTitle(data.incorrectAnswers[3], for: .normal)
            
        } else {
            thirdOptionBtn.isHidden = true
            forthOptionBtn.isHidden = true
        }
    }
    
    @IBAction func answerBtnAction(_ sender: UIButton) {
        
        debugPrint(sender.titleLabel?.text)
        
        guard let title = sender.titleLabel?.text else {
            return
        }
        self.selectOptionDelegate?.selectOptionAction(option: title)
    }
}
