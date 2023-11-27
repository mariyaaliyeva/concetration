//
//  ViewController.swift
//  concenration
//
//  Created by Rustam Aliyev on 02.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var flipCountLabel: UILabel!
    
    @IBOutlet private var cardsButton: [UIButton]!
    
//    var flipCount = 0 {
//        didSet {
//            flipCountLabel.text = "Flips: \(flipCount)"
//        }
//    }
    private lazy var game: Concentration = {
        let game = Concentration(numberOfPairsOfCards: (cardsButton.count + 1) / 2)
        game.delegate = self
        return game
    }()
        
    
    private var emojiChoices = ["👻", "🙉", "🐬", "🎃", "💙", "🦋", "🦖", "🦄"]
    private var emojiDictionary = Dictionary<Card, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }

    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let index = cardsButton.firstIndex(of: sender) else {return}
        //flipCard(emojiChoices[index], sender: sender)
        game.chooseCard(at: index)
        updateView()
        //flipCount += 1
    }
    
    
    @IBAction func restartButton(_ sender: UIButton) {
        game.newGame()
        for i in cardsButton {
            i.setTitle("", for: .normal)
            i.backgroundColor = .yellow
        }
        flipCountLabel.text = "Flips: 0"
       
    }
    
    
    private func updateView() {
        for i in cardsButton.indices {
            let button = cardsButton[i]
            let card = game.cards[i]
            if card.isFaceUp {
                button.setTitle(getEmoji(for: card), for: .normal)
                button.backgroundColor = .white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : .yellow
            }
        }
    }
    
    private func getEmoji(for card: Card) -> String {
        //5. И когда в словаре есть emoji мы его возвращаем
        if let emoji = emojiDictionary[card] {
            return emoji
            
            //1. в начале игры эта функция будет выполняться с условия else
            //т к emojiDictionary изначально пустой
        } else {
            //2. чтобы emoji всегда были разные, мы берем любой emoji из массива
            guard let randomIndex = emojiChoices.indices.randomElement() else {return "?"}
            //3.удаляем емодзи которое мы уже использовали в пределах одной игры и возвращаем удаленный
            let emoji = emojiChoices.remove(at: randomIndex)
            //4.и добавляем в словарь emoji
            emojiDictionary[card] = emoji
            return emoji
        }
        
    }

//    func flipCard(_ emoji: String, sender: UIButton) {
//        if sender.currentTitle == emoji {
//            sender.setTitle("", for: .normal)
//            sender.backgroundColor = .yellow
//        } else {
//            sender.setTitle(emoji, for: .normal)
//            sender.backgroundColor = .white
//        }
//    }
    
}

extension ViewController: ConcentrationDelegate {
    func didUpdateCount(with count: Int) {
        flipCountLabel.text = "Flips: \(count)"
    }
}
