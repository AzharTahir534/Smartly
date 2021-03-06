//
//  ResultVC.swift
//  SmartlyApp
//
//  Created by Azhar on 06/03/2021.
//

import UIKit

class ResultVC: UIViewController {
    
    @IBOutlet var resultTableView: UITableView!
    @IBOutlet weak var yourScoreLabel: UILabel!
    
    var questionsCategories = [String: Int]()
    var result = [String: Int]()
    
    var categoriesArray = [String]()
    
    var total = 0
    var scored = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categoriesArray = Array(questionsCategories.keys)
        resultTableView.reloadData()
        
        yourScoreLabel.text = String(format: "Your Score\n %d / %d", scored, total)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func playAgainBtnAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ResultVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ResultCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ResultCell
        
        cell.selectionStyle = .none
        
        let score = "\(result[categoriesArray[indexPath.row]] ?? 0) / \(questionsCategories[categoriesArray[indexPath.row]] ?? 0)"
        
        cell.updateCell(title: categoriesArray[indexPath.row], score: score)
        
        return cell
        
    }
}
