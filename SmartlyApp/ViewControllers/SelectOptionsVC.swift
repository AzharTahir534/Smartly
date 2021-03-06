//
//  SelectOptionsVC.swift
//  SmartlyApp
//
//  Created by Azhar on 03/03/2021.
//

import UIKit

class SelectOptionsVC: UIViewController {

    var selectedCategory: Int?
    var selectedLevel: String?
    var selectedType: String?
    
    @IBOutlet weak var anyCategoryLabel: UILabel!
    @IBOutlet weak var anyLevelLabel: UILabel!
    @IBOutlet weak var anyTypeLabel: UILabel!
    
    var categories = ["Any Category",
                      "General Knowledge",
                      "Entertainment: Books",
                      "Entertainment: Film",
                      "Entertainment: Music",
                      "Entertainment: Musicals & Theatres",
                      "Entertainment: Video Games",
                      "Entertainment: Board Games",
                      "Science & Nature",
                      "Science: Computers",
                      "Science: Mathematics"]
    
    var levels = ["Any Difficulty", "Easy", "Medium", "Hard"]
    var types = ["Any Type", "Multiple", "Boolean"]
    
    var questionsArray = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func categoryBtnAction(_ sender: Any) {
        selectOptionFromList(title: "Select Category", sheetData: categories, option: 1)
    }
    
    @IBAction func levelBtnAction(_ sender: Any) {
        selectOptionFromList(title: "Select Difficulty", sheetData: levels, option: 2)
    }
    
    @IBAction func typeBtnAction(_ sender: Any) {
        selectOptionFromList(title: "Select Type", sheetData: types, option: 3)
    }
    
    @IBAction func StartBtnAction(_ sender: Any) {
        self.fetchData()
    }
    
    @IBAction func quickModeBtnAction(_ sender: Any) {
        
        self.selectedCategory = nil
        self.selectedLevel = nil
        self.selectedType = nil
        
        self.fetchData(true)
    }
    
    func selectOptionFromList(title: String, sheetData: [String], option: Int) {
        
        
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        actionSheetController.addAction(cancelActionButton)
        
        weak var weakSelf = self
        
        let completionHandler = { (index: Int) in
            { (action: UIAlertAction!) -> Void in
                
                switch option {
                
                    case 1:
                        weakSelf?.selectedCategory = index == 0 ? nil : index + 8
                        weakSelf?.anyCategoryLabel.text = weakSelf?.categories[index]
                    
                    case 2:
                        weakSelf?.selectedLevel = index == 0 ? nil : weakSelf?.levels[index].lowercased()
                        weakSelf?.anyLevelLabel.text = weakSelf?.levels[index]
                    
                    default:
                        weakSelf?.selectedType = index == 0 ? nil : weakSelf?.types[index].lowercased()
                        weakSelf?.anyTypeLabel.text = weakSelf?.types[index]
                }
            }
        }
        
        for (index, item) in sheetData.enumerated() {
            
            actionSheetController.addAction(UIAlertAction(title: item,
                                                          style: .default,
                                                          handler: completionHandler(index)))
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func fetchData(_ isQuickMode: Bool = false) {
        
        var queryItems = [URLQueryItem(name: "amount", value: "10")]
        
        if let _category = selectedCategory {
            queryItems.append(URLQueryItem(name: "category", value: "\(_category)"))
        }
        if let _level = selectedLevel {
            queryItems.append(URLQueryItem(name: "difficulty", value: _level))
        }
        if let _type = selectedType {
            queryItems.append(URLQueryItem(name: "type", value: _type))
        }
        
        var urlComps = URLComponents(string: "https://opentdb.com/api.php")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        print(url)
        
        weak var weakSelf = self
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil || data == nil {
                print("Error!")
                return
            }
            
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
                
                weakSelf?.questionsArray.removeAll()
                
                if let dict = json as? Dictionary<String, AnyObject>, let values = dict["results"] as? Array<Dictionary<String, AnyObject>> {
                    
                    for valueDict in values {
                        
                        let jsonData =  try JSONSerialization.data(withJSONObject: valueDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                        
                        var questionObj = try JSONDecoder().decode(Question.self, from: jsonData)
                        
                        questionObj.incorrectAnswers.append(questionObj.correctAnswer)
                        
                        for answer in questionObj.incorrectAnswers {
                            print(answer)
                        }
                        
                        questionObj.incorrectAnswers.shuffle()
                        
                        for answer in questionObj.incorrectAnswers {
                            print(answer)
                        }
                        weakSelf?.questionsArray.append(questionObj)
                    }
                }
                
                DispatchQueue.main.async {
                    
                    if weakSelf?.questionsArray.count == 0 {
                        
                        let actionsheet = UIAlertController(title: "Error", message: "No data found", preferredStyle: UIAlertController.Style.alert)
                        
                        actionsheet.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
                            
                        }))
                        
                        weakSelf?.present(actionsheet, animated: true, completion: nil)
                        
                    } else {
                        weakSelf?.pushScreen(isQuickMode)
                    }
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func pushScreen(_ isQuickMode: Bool = false) {
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "QuestionAnswerVC") as! QuestionAnswerVC
        
        pushVC.questionsArray = self.questionsArray
        pushVC.isQuickMode = isQuickMode
        
        if isQuickMode {
            pushVC.isQuickMode = true
        }
        
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
}
