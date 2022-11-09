import UIKit

class BoardGameController: UIViewController {
    var cardsPairsCounts = 8
    lazy var game: Game = getNewGame()

    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCounts
        game.generateCards()
        return game
    }
}
