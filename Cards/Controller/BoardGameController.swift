import UIKit

class BoardGameController: UIViewController {
    let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    var cardsPairsCounts = SettingsViewController().difficulties["Default"]
    var counterReturnCards = 0
    var cardViews = [UIView]()
    lazy var game: Game = getNewGame()
    lazy var startButtonView = getStartButtonView()
    lazy var turnCardsOnView = getTurnCardsOnView()
    lazy var settingsButtonView = getSettingsButtonView()
    lazy var resultLabel = getResultLabel()
    lazy var countLabel = getCountView()
    lazy var boardGameView = getBoardGameView()
    private var settings = SettingsViewController()
    private var flippedCards = [UIView]()
    var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }

    private func getNewGame() -> Game {
        let game = Game()
        flippedCards = []
        counterReturnCards = 0
        zeroCounterLabel()
        resultLabel.backgroundColor = .white
        countLabel.backgroundColor = .black
        changeDifficulty()
        game.cardsCount = cardsPairsCounts ?? 8
        game.generateCards()
        return game
    }
    
    private func getStartButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        button.center.x = view.center.x
        
        let window = UIApplication.shared.windows[0]
        let topPadding  = window.safeAreaInsets.top
        button.frame.origin.y = topPadding
        
        button.setTitle("Начать игру", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }
    
    private func getSettingsButtonView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        button.center.x = view.center.x - 125
        
        let window = UIApplication.shared.windows[0]
        let topPadding  = window.safeAreaInsets.top
        button.frame.origin.y = topPadding
        
        button.setTitle("Настройки", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 10
        
        button.addTarget(nil, action: #selector(toSettingsScene), for: .touchUpInside)
        
        return button
    }
    
    private func getTurnCardsOnView() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        button.center.x = view.center.x + 125
        
        let window = UIApplication.shared.windows[0]
        let topPadding  = window.safeAreaInsets.top
        button.frame.origin.y = topPadding

        button.setTitle("Перевернуть (бета)", for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10

        button.addTarget(nil, action: #selector(turnCards), for: .touchUpInside)

        return button
    }
    
    private func getResultLabel() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
        view.center.x = self.view.center.x
        view.frame.origin.y = self.view.center.y
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        
        label.textAlignment = .center
        label.text = "Win"
        label.textColor = .white
        label.font = label.font.withSize(35)
        view.addSubview(label)
        
        return view
    }

    func getCountView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        view.center.x = self.view.center.x + 150
        
        let window = UIApplication.shared.windows[0]
        let topPadding  = window.safeAreaInsets.top + 65
        view.frame.origin.y = topPadding
        view.backgroundColor = .black
        view.layer.cornerRadius = 7
        
        view.addSubview(getCountLabel())
        
        return view
    }

    func getCountLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        
        label.textAlignment = .center
        if counterReturnCards > 999 {
            label.text = String(counterReturnCards / 1000) + "k"
        } else {
            label.text = String(counterReturnCards)
        }
        label.textColor = .white
        label.font = label.font.withSize(30)
        
        return label
    }

    private func getBoardGameView() -> UIView {
        let margin: CGFloat = 10
        let boardView = UIView()
        boardView.frame.origin.x = margin
        let window = UIApplication.shared.windows[0]

        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2

        let bottomPading = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPading

        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = settings.colorBoard
        return boardView
    }

    private func getCardsBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)

            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                flippedCard.superview?.bringSubviewToFront(flippedCard)

                if flippedCard.isFlipped {
                    self.flippedCards.append(flippedCard)
                    counterReturnCards += 1
                    zeroCounterLabel()
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                if self.flippedCards.count == 2 {
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]

                    if game.checkCards(firstCard, secondCard) {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        }, completion: { _ in
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                        })
                        game.cardsCount -= 1
                    } else {
                        for card in self.flippedCards {
                            (card as! FlippableView).flip()
                        }
                    }
                    if game.gameEnd() {
                        resultLabel.backgroundColor = .black
                    }
                }
            }
        }
        return cardViews
    }

    private func placeCardsOnBoard(_ cards: [UIView]) {
        for card in cardViews {
            card.removeFromSuperview()
        }
        cardViews = cards
        for card in cardViews {
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            boardGameView.addSubview(card)
        }
    }
    
    private func zeroCounterLabel() {
        countLabel.subviews.first?.removeFromSuperview()
        countLabel.addSubview(getCountLabel())
    }
    
    private func changeDifficulty() {
        if let value = UserDefaults.standard.value(forKey: "chosenOption") {
            let index = value as! Int
            switch index {
            case 0:
                cardsPairsCounts = settings.difficulties["Easy"]
            case 1:
                cardsPairsCounts = settings.difficulties["Default"]
            case 2:
                cardsPairsCounts = settings.difficulties["Hard"]
            case 3:
                cardsPairsCounts = settings.difficulties["Hardcore"]
            case 4:
                cardsPairsCounts = settings.difficulties["Extreme"]
            default:
                cardsPairsCounts = 8
            }
        }
    }

    @objc func startGame(_ sender: UIButton) {
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
    }

    @objc func turnCards(_ sender: UIButton) -> [UIView] {
        var counter = 0
        for card in cardViews {
            if !(card as! FlippableView).isFlipped {
                counter += 1
            }
        }
        for card in cardViews {
            if counter > 0 {
                if counter > 0 && !(card as! FlippableView).isFlipped {
                    (card as! FlippableView).flip()
                }
            } else {
                (card as! FlippableView).flip()
            }
        }
        return cardViews
    }
    
    @objc func toSettingsScene(_ sender: UIButton) {
        let nextViewController = storyboardInstance.instantiateViewController(withIdentifier: "settingsViewController")
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        resultLabel.backgroundColor = .white
        countLabel.backgroundColor = .white

        view.addSubview(startButtonView)
        view.addSubview(turnCardsOnView)
        view.addSubview(settingsButtonView)
        view.addSubview(resultLabel)
        view.addSubview(countLabel)
        view.addSubview(boardGameView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
