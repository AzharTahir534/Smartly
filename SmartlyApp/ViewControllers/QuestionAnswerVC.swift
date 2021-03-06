//
//  QuestionAnswerVC.swift
//  SmartlyApp
//
//  Created by Azhar on 05/03/2021.
//

import UIKit

class QuestionAnswerVC: UIViewController {
    
    @IBOutlet var questionAnswerCollectionView: UICollectionView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!
    
    var isQuickMode = false
    
    var questionsArray = [Question]()
    
    var currentIndex = 0
    
    var counter = 5
    
    var lives = 3
    
    var score = 0
    var total = 0
    
    var questionsCategories = [String: Int]()
    var result = [String: Int]()
    
    var collectionViewScrollTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isQuickMode {
            self.counterLabel.isHidden = false
            self.lifeLabel.isHidden = false
            self.lifeLabel.text = "Life: 3/3"
            self.startTimer()
            
        } else {
            self.counterLabel.isHidden = true
            self.lifeLabel.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timerInvalidate()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func skipBtnAction(_ sender: Any) {
        counterLabel.text = "Time: 5s"
        self.selectOptionAction(option: "")
    }
    
    func startTimer() {
        counter = 5
        self.collectionViewScrollTimer?.invalidate()
        self.collectionViewScrollTimer = nil
        self.collectionViewScrollTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    
    func timerInvalidate() {
         collectionViewScrollTimer?.invalidate()
    }
    
    func showResults() {
        
        self.collectionViewScrollTimer?.invalidate()
        self.collectionViewScrollTimer = nil
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultVC") as! ResultVC
        
        pushVC.questionsCategories = self.questionsCategories
        pushVC.result = self.result
        pushVC.total = self.total
        pushVC.scored = self.score
        
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    @objc func updateCounter() {
        
        if counter > 0 {
            counter -= 1
            counterLabel.text = "Time: \(counter)s"
            
        } else {
            counterLabel.text = "Time: 5s"
            self.selectOptionAction(option: "")
        }
    }
}

extension QuestionAnswerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCollectionCell", for: indexPath) as! QuestionCollectionCell
        
        cell.selectOptionDelegate = self
        
        cell.updateCell(data: questionsArray[indexPath.row])
        
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
        
        return CGSize(width: screenSize.width , height: screenSize.height - 174)
    }
}

extension QuestionAnswerVC: SelectOptionDelegate {
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    func saveData(question: Question, answer: String) {
        
        let dataToWrite = question.question + "\n" + answer + "\n\n"
        
        let url = self.getDocumentsDirectory().appendingPathComponent("History.txt")
        
        do {
            
            guard let writingData = dataToWrite.data(using: String.Encoding.utf8) else { return }
            
            if FileManager.default.fileExists(atPath: url.path) {
                
                if let fileHandle = try? FileHandle(forWritingTo: url) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(writingData)
                    fileHandle.closeFile()
                }
                
            } else {
                try? dataToWrite.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }
    
     func selectOptionAction(option: String) {
        
        let currentQuestion = questionsArray[currentIndex]
        
        self.saveData(question: currentQuestion, answer: option)
        
        var count = 0
        
        switch currentQuestion.difficulty.lowercased() {
        case "easy":
            count = 1
        case "medium":
            count = 2
        default:
            count = 3
        }
        total += count
        
        if let _ = questionsCategories[currentQuestion.category] {
            questionsCategories[currentQuestion.category]! += count
        } else {
            questionsCategories[currentQuestion.category] = count
        }
        
        if currentQuestion.correctAnswer == option {
            
            var count = 0
            
            switch currentQuestion.difficulty.lowercased() {
            case "easy":
                count = 1
            case "medium":
                count = 2
            default:
                count = 3
            }
            score += count
            
            if let _ = result[currentQuestion.category] {
                result[currentQuestion.category]! += count
            } else {
                result[currentQuestion.category] = count
            }
        } else {
            if isQuickMode {
                lives -= 1
                
                lifeLabel.text = "Life: \(lives)/3"
            }
        }
        
        if isQuickMode && lives == 0 {
            self.showResults()
            
        } else if currentIndex < questionsArray.count - 1 {
            // show next question
            
            if isQuickMode {
                startTimer()
            }
            currentIndex += 1
            questionAnswerCollectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: true)
            
        } else {
            // show result screen
            self.showResults()
        }
    }
}
