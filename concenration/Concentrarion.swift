//
//  Concentrarion.swift
//  concenration
//
//  Created by Rustam Aliyev on 22.11.2023.
//

import Foundation

protocol ConcentrationDelegate: AnyObject {
    func didUpdateCount(with count: Int)
}

class Concentration {
    //private только для set 
    private (set) var cards: [Card] = []
    private(set) var gameOver = false
    
    weak var delegate: ConcentrationDelegate?
    
    //willSet срабатывает перед тем как будет установлено новое значение, и ты даже можешь знать какое по переменной newValue didSet срабатывает тогда. когда новое значение уже установлено!тут ты можешь получить доступ и к уже установленному значению, так и к старому по переменной oldValue например если в твоем коде где

    private var flipCount = 0 {
        didSet {
            delegate?.didUpdateCount(with: flipCount)
        }
    }
    
    private var indexOneAndOnlyFaceUPCard: Int? {
        get {
            let faceUpCardsIndices = cards.indices.filter { cards[$0].isFaceUp}
            return faceUpCardsIndices.count == 1 ? faceUpCardsIndices.first : nil
        } set {
            for index in cards.indices {
                cards[index].isFaceUp = (newValue == index)
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
            cards = cards.shuffled()
        }
        //cards.shuffled()
    }
    
    func chooseCard(at index: Int) {
        //guard !cards[index].isMatched else {return}
        //1. Если 2 карты совпали, то заходим в блок return и больше ничего не делаем
        if !cards[index].isMatched {
            flipCount += 1
            //2. а если нет то выполняем следующий код
            //3. matchingIndex != index Если уже одна кнопка перевернута и вторая эта же, то
            //мы ничего не делаем (т е нажатие не происходит)
            if let matchingIndex = indexOneAndOnlyFaceUPCard, matchingIndex != index {
                //4. Если встретились 2 одинаковые карты то мы(это блок match)
                if cards[matchingIndex] == cards[index] {
                    //говорим что они встретились
                    cards[matchingIndex].isMatched = true
                    cards[index].isMatched = true
                }
                
                
                //5.когда одна карта выбрана мы говорим true
                cards[index].isFaceUp = true
                //indexOneAndOnlyFaceUPCard = nil
            } else {
//
//                //0 or 2 card
//                for i in cards.indices {
//                    cards[i].isFaceUp = false
//                }
//                cards[index].isFaceUp = true
                indexOneAndOnlyFaceUPCard = index
            }
        }
    }
    
    func newGame() {
        
        flipCount = 0
        gameOver = false
        
        for index in cards.indices {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
            //cards[index]. = 0
        }
        cards.shuffle()
    }
    
}
