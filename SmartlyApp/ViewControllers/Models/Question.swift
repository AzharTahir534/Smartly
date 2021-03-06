//
//  Question.swift
//  SmartlyApp
//
//  Created by Azhar on 05/03/2021.
//

import Foundation

enum QuestionType: String {
    case multiple = "multiple"
    case boolean = "boolean"
}

enum CodingKeys: String, CodingKey {
    case category
    case type
    case difficulty
    case question
    case correctAnswer = "correct_answer"
    case incorrectAnswers = "incorrect_answers"
}

struct Question: Codable {
    
    var category: String
    var type: QuestionType
    var difficulty: String
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        type = QuestionType(rawValue: try container.decode(String.self, forKey: .type)) ?? .multiple
        difficulty = try container.decode(String.self, forKey: .difficulty)
        question = try container.decode(String.self, forKey: .question)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
