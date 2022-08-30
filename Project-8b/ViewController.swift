//
//  ViewController.swift
//  Project-8b
//
//  Created by Edgar Arlindo on 12/07/22.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.text = "CLUES"
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.text = "ANSWER"
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.textAlignment = .right
        answerLabel.numberOfLines = 0
        answerLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .vertical)
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.textAlignment = .center
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderColor = UIColor.gray.cgColor
        buttonsView.layer.borderWidth = 2
        buttonsView.layer.cornerRadius = 12
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterButtonTapped(_:)), for: .touchUpInside)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    var activatedButtons = [UIButton]()
    var solutionWords = [String]()
    var level = 1
    
    func loadLevel() {
        var cluesLabelString = ""
        var answerLabelString = ""
        var letterBits = [String]()
        
        if let fileLevelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let fileLevelContent = try? String(contentsOf: fileLevelURL) {
                let lines = fileLevelContent.components(separatedBy: "\n")
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let bit = parts[0].components(separatedBy: "|")
                    
                    let solutionWord = (parts[0].replacingOccurrences(of: "|", with: ""))
                    let answer = "\(solutionWord.count) letters\n"
                    
                    
                    solutionWords.append(solutionWord)
                    
                    letterBits += bit
                    answerLabelString += answer
                    cluesLabelString += "\(index + 1). \(parts[1])\n"
                }
            }
        }
        
        print(solutionWords)
        
        answerLabel.text = answerLabelString.trimmingCharacters(in: .whitespacesAndNewlines)
        cluesLabel.text = cluesLabelString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        if let titleButton = sender.currentTitle {
            currentAnswer.text = currentAnswer.text?.appending(titleButton)
            activatedButtons.append(sender)
            sender.isHidden = true
        }
    }
    
    @objc func clearButtonTapped() {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    var rightAnswer = 0
    
    @objc func submitTapped() {
        //verificar a palavra estiver dentro do meu array de respostas, tal palavra vai para posicao da resposta na label
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutionWords.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            var splitanswer = answerLabel.text?.components(separatedBy: "\n")
            splitanswer?[solutionPosition] = answerText
            answerLabel.text = splitanswer?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            rightAnswer += 1
        } else {
            score -= 1
            let alert = UIAlertController(title: "Misspelled word", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again!", style: .default, handler: { _ in
                for button in self.activatedButtons {
                    button.isHidden = false
                }
                self.activatedButtons.removeAll()
                self.currentAnswer.text = ""
            }))
            
            present(alert, animated: true)
        }
        
        //se o numeros de respostas corretas forem um multiplo de 7 e diferente de zero
        if rightAnswer % 7 == 0 && rightAnswer != 0 {
            let alert = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
            present(alert, animated: true)
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutionWords.removeAll(keepingCapacity: true)
        loadLevel()
        
        letterButtons.forEach { button in
            button.isHidden = false
        }
    }
}

