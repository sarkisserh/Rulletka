//
//  GameVC.swift
//  rulletka
//

import UIKit
import Firebase


enum Rate {
    case bet1_18
    case bet19_36
    case bet1rd12
    case bet2rd12
    case bet3rd12
    case even
    case odd
    case red
    case black
    case zero
    case digit(Int)
    case empty
}

class GameVC: UIViewController {
    
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var numberCollectionView: UICollectionView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var rulletkaImage: UIImageView!
    @IBOutlet weak var randomNumberLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var bet1rd12Button: UIButton!
    @IBOutlet weak var bet2rd12Button: UIButton!
    @IBOutlet weak var bet3rd12Button: UIButton!
    @IBOutlet weak var bet1for18Button: UIButton!
    @IBOutlet weak var betEvenButton: UIButton!
    @IBOutlet weak var betRedButton: UIButton!
    @IBOutlet weak var betBlackButton: UIButton!
    @IBOutlet weak var betOddButton: UIButton!
    @IBOutlet weak var bet19for36Button: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    private var selectedButton: UIButton? = nil
    
    var bet = 0 {
        didSet {
            betLabel.text = String(bet)
        }
    }
    
    var winNumber = 0
    
    var itemsNumbers = [NumbersModel]()
    
    var currentRate = Rate.empty
    var balance = 0 {
        didSet {
            balanceLabel.text = String(balance)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = UIColor(red: 51/255, green: 113/255, blue: 35/255, alpha: 1)
        
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        ref.child("users/\(userID)/balance").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            self.balance = snapshot?.value as? Int ?? 2000
        });
        
        ref.child("users/\(userID)/name").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            self.nameLabel.text = snapshot?.value as? String ?? "Name"
        });
        
        bet = 10
    }
    
    private func setup() {
        configureUI()
        configureButton()
        configureCollectionView()
        createNumbersItems()
        numberCollectionView.reloadData()
    }
    
    private func configureButton() {
        zeroButton.backgroundColor = .clear
        zeroButton.setTitleColor(.white, for: .normal)
        zeroButton.setTitle("0", for: .normal)
        zeroButton.layer.borderColor = UIColor.white.cgColor
        zeroButton.layer.borderWidth = 1
        zeroButton.layer.cornerRadius = 10
        zeroButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bet1rd12Button.backgroundColor = .clear
        bet1rd12Button.setTitleColor(.white, for: .normal)
        bet1rd12Button.setTitle("1rd12", for: .normal)
        bet1rd12Button.layer.borderWidth = 1
        bet1rd12Button.layer.borderColor = UIColor.white.cgColor
        bet1rd12Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bet2rd12Button.backgroundColor = .clear
        bet2rd12Button.setTitleColor(.white, for: .normal)
        bet2rd12Button.setTitle("2rd12", for: .normal)
        bet2rd12Button.layer.borderWidth = 1
        bet2rd12Button.layer.borderColor = UIColor.white.cgColor
        bet2rd12Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bet3rd12Button.backgroundColor = .clear
        bet3rd12Button.setTitleColor(.white, for: .normal)
        bet3rd12Button.setTitle("3rd12", for: .normal)
        bet3rd12Button.layer.borderWidth = 1
        bet3rd12Button.layer.borderColor = UIColor.white.cgColor
        bet3rd12Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bet1for18Button.backgroundColor = .clear
        bet1for18Button.setTitleColor(.white, for: .normal)
        bet1for18Button.setTitle("1-18", for: .normal)
        bet1for18Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bet1for18Button.layer.borderWidth = 1
        bet1for18Button.layer.borderColor = UIColor.white.cgColor
        betEvenButton.backgroundColor = .clear
        betEvenButton.setTitleColor(.white, for: .normal)
        betEvenButton.setTitle("Even", for: .normal)
        betEvenButton.layer.borderWidth = 1
        betEvenButton.layer.borderColor = UIColor.white.cgColor
        betEvenButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        betRedButton.backgroundColor = .red
        betRedButton.setTitleColor(.white, for: .normal)
        betRedButton.setTitle("Red", for: .normal)
        betRedButton.layer.borderWidth = 1
        betRedButton.layer.borderColor = UIColor.white.cgColor
        betRedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        betBlackButton.backgroundColor = .black
        betBlackButton.setTitleColor(.white, for: .normal)
        betBlackButton.setTitle("Black", for: .normal)
        betBlackButton.layer.borderWidth = 1
        betBlackButton.layer.borderColor = UIColor.white.cgColor
        betBlackButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        betOddButton.backgroundColor = .clear
        betOddButton.setTitleColor(.white, for: .normal)
        betOddButton.setTitle("Odd", for: .normal)
        betOddButton.layer.borderWidth = 1
        betOddButton.layer.borderColor = UIColor.white.cgColor
        betOddButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bet19for36Button.backgroundColor = .clear
        bet19for36Button.setTitleColor(.white, for: .normal)
        bet19for36Button.setTitle("19-36", for: .normal)
        bet19for36Button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        bet19for36Button.layer.borderWidth = 1
        bet19for36Button.layer.borderColor = UIColor.white.cgColor
        startButton.layer.cornerRadius = 5
        minusButton.layer.cornerRadius = 5
        plusButton.layer.cornerRadius = 5
        
    }
    
    private func configureCollectionView() {
        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self
        numberCollectionView.register(cell: NumberCollectionViewCell.self)
        numberCollectionView.backgroundColor = .clear
        
        // Настройка UICollectionViewFlowLayout
        if let layout = numberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            // Отключение прокрутки коллекции
            layout.collectionView?.isScrollEnabled = false
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            
            // Установка размера ячейки в соответствии с размером коллекции
            layout.itemSize = CGSize(width: numberCollectionView.frame.width, height: numberCollectionView.frame.height)
        }
    }
    
    private func configureUI() {
        configureLabel()
        colorView.layer.cornerRadius = colorView.bounds.height / 2
        colorView.backgroundColor = .clear
        rulletkaImage.layer.cornerRadius = rulletkaImage.bounds.height / 2
    }
    
    private func configureLabel() {
        randomNumberLabel.textColor = .white
        betLabel.textAlignment = .left
        
    }
    
    //MARK: - Create Items For CollectionView
    
    
    private func createNumbersItems() {
        self.itemsNumbers = setItemsNumbers()
    }
    
    fileprivate func setItemsNumbers() -> [NumbersModel] {
        
        var characters = [NumbersModel]()
        for index in 1...36 {
            let numberModel = NumbersModel(number: index, color: "", image: "")
            characters.append(numberModel)
        }
        
        return characters
    }
    
    func numberOFRowsForMainCollection() -> Int {
        return itemsNumbers.count
    }
    
    func getNumbersItem(index: Int) -> NumbersModel {
        return itemsNumbers[index]
    }
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        if bet > 10 {
            bet -= 10
        }
        
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        if bet < balance {
            bet += 10
        }
    }
    
    @IBAction func startButtonDidTapped(_ sender: Any) {
        checkBalanceBet()
        if case .empty = currentRate {
            showAlert(message: "Choose a bet before starting the game")
            return
        }
        startButton.isUserInteractionEnabled = false
        rotateImage()
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 2) {
            self.randomRullet()
            self.resetButtons()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func button1_18Tapped(_ sender: UIButton) {
        if case .bet1_18 = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.bet1_18
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func button19_36Tapped(_ sender: UIButton) {
        if case .bet19_36 = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.bet19_36
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func button1rd12DidTapped(_ sender: UIButton) {
        if case .bet1rd12 = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.bet1rd12
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func button2rd12DidTapped(_ sender: UIButton) {
        if case .bet2rd12 = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.bet2rd12
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func button3rd12DidTapped(_ sender: UIButton) {
        if case .bet3rd12 = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.bet3rd12
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func buttonEvenDidTapped(_ sender: UIButton) {
        if case .even = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.even
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func buttonRedDidTapped(_ sender: UIButton) {
        if case .red = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.red
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func buttonBlackDidTapped(_ sender: UIButton) {
        if case .black = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.black
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func buttonOddDidTapped(_ sender: UIButton) {
        if case .odd = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.odd
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    @IBAction func buttonZero(_ sender: UIButton) {
        if case .zero = currentRate {
            resetButtons()
            currentRate = .empty
        } else {
            currentRate = Rate.zero
            handleButtonTap(sender)
            checkBalanceBet()
        }
    }
    
    private func handleButtonTap(_ sender: UIButton) {
        selectedButton?.backgroundColor = .clear
        resetButtons()
        // Выделяем текущую нажатую кнопку
        sender.backgroundColor = UIColor.blue
        // Сохраняем текущую выбранную кнопку
        selectedButton = sender
        numberCollectionView.reloadData()
    }
    
    private func resetButtons() {
        bet1for18Button.setTitleColor(.white, for: .normal)
        bet1for18Button.backgroundColor = UIColor.clear
        bet19for36Button.setTitleColor(.white, for: .normal)
        bet19for36Button.backgroundColor = UIColor.clear
        bet1rd12Button.setTitleColor(.white, for: .normal)
        bet1rd12Button.backgroundColor = UIColor.clear
        bet2rd12Button.setTitleColor(.white, for: .normal)
        bet2rd12Button.backgroundColor = UIColor.clear
        bet3rd12Button.setTitleColor(.white, for: .normal)
        bet3rd12Button.backgroundColor = UIColor.clear
        betEvenButton.setTitleColor(.white, for: .normal)
        betEvenButton.backgroundColor = UIColor.clear
        betOddButton.setTitleColor(.white, for: .normal)
        betOddButton.backgroundColor = UIColor.clear
        betBlackButton.setTitleColor(.white, for: .normal)
        betBlackButton.backgroundColor = UIColor.black
        betRedButton.setTitleColor(.white, for: .normal)
        betRedButton.backgroundColor = UIColor.red
        zeroButton.setTitleColor(.white, for: .normal)
        zeroButton.backgroundColor = UIColor.clear
    }
    
    func rotateImage() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2  // Поворот на 360 градусов (2 * π)
        rotationAnimation.duration = 1.0  // Продолжительность анимации в секундах
        rotationAnimation.repeatCount = 2  // Количество повторений (в данном случае, два раза)
        rulletkaImage.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func randomRullet() {
        let randomInt = Int.random(in: 0...36)
        winNumber = randomInt
        randomNumberLabel.text = String(randomInt)
        switchNumberColor(number: randomInt)
        callculateWin()
    }
    
    private func callculateWin() {
        print(winNumber)
        print("calculateWIN", currentRate)
        switch currentRate {
        case .bet1_18:
            if winNumber >= 1  && winNumber <= 18 {
                print("Win")
                showAlertWin()
                win(value: bet * 2)
            }else{
                print("Lose")
                lose(value: bet)
                showAlertLose()
            }
        case .bet19_36:
            if winNumber >= 19 && winNumber <= 36 {
                print("Win")
                showAlertWin()
                win(value: bet * 2)
            }else{
                print("Lose")
                lose(value:  bet)
                showAlertLose()
            }
        case .bet1rd12:
            if winNumber >= 1 && winNumber <= 12 {
                print("Win")
                showAlertWin()
                win(value: bet * 3)
            }else{
                print("Lose")
                lose(value:  bet)
                showAlertLose()
            }
        case .bet2rd12:
            if winNumber >= 13 && winNumber <= 24 {
                print("Win")
                showAlertWin()
                win(value: bet * 3)
            }else{
                print("Lose")
                lose(value:  bet)
                showAlertLose()
            }
        case .bet3rd12:
            if winNumber >= 25 && winNumber <= 36 {
                print("Win")
                showAlertWin()
                win(value: bet * 3)
            }else {
                print("Lose")
                lose(value: bet)
                showAlertLose()
            }
        case .even:
            if winNumber % 2 == 0 {
                print("Win")
                showAlertWin()
                win(value: bet * 2)
            }else{
                print("Lose")
                lose(value: bet)
                showAlertLose()
            }
        case .odd:
            if winNumber % 2 != 0 {
                print("Win")
                showAlertWin()
                win(value: bet * 2)
            }else{
                print("Lose")
                lose(value: bet)
                showAlertLose()
            }
        case .red:
            if isRedNumber(winNumber) {
                print("Win")
                showAlertWin()
                win(value: bet * 2)
            } else {
                print("Lose")
                showAlertLose()
                lose(value: bet)
            }
        case .black:
            if isBlackNumber(winNumber) {
                print("Win")
                showAlertWin()
                win(value: bet * 2)
            } else {
                print("Lose")
                showAlertLose()
                lose(value: bet)
            }
        case .zero:
            if winNumber == 0 {
                print("Win")
                showAlertWin()
                win(value: bet * 36)
            } else {
                print("Lose")
                showAlertLose()
                lose(value: bet)
            }
        case .digit(let value):
            if winNumber == value {
                print("Win")
                win(value: bet * 36)
            }else{
                print("Lose")
                lose(value: bet)
                showAlertLose()
            }
        case .empty:
            print("Sorry")
        }
    }
    
    func lose(value: Int) {
        currentRate = .empty
        numberCollectionView.reloadData()
        selectedButton?.backgroundColor = .clear
        balance = balance - value
        if balance == 0 {
            balance = 100
        }
        updateBalance()
    }
    
    func win(value: Int) {
        currentRate = .empty
        numberCollectionView.reloadData()
        selectedButton?.backgroundColor = .clear
        balance = balance + value
        updateBalance()
    }
    
    func updateBalance() {
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("users")
        ref.child(userID).updateChildValues(["balance" : balance])
    }
    
    func checkBalanceBet() {
        if balance >= bet {
            startButton.isUserInteractionEnabled = true
        } else {
            startButton.isUserInteractionEnabled = false
        }
    }
    
    func showAlertWin(){
        let alert = UIAlertController(title: "Congratulations", message: "You Win", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlertLose(){
        let alert = UIAlertController(title: "Sorry!", message: "You Lose", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isRedNumber(_ number: Int) -> Bool {
        return [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36].contains(number)
    }
    
    func isBlackNumber(_ number: Int) -> Bool {
        return [2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35].contains(number)
    }
    
    func switchNumberColor(number: Int) {
        switch number {
        case 0:
            colorView.backgroundColor = .green
        case 1:
            colorView.backgroundColor = .red
        case 2:
            colorView.backgroundColor = .black
        case 3:
            colorView.backgroundColor = .red
        case 4:
            colorView.backgroundColor = .black
        case 5:
            colorView.backgroundColor = .red
        case 6:
            colorView.backgroundColor = .black
        case 7:
            colorView.backgroundColor = .red
        case 8:
            colorView.backgroundColor = .black
        case 9:
            colorView.backgroundColor = .red
        case 10:
            colorView.backgroundColor = .black
        case 11:
            colorView.backgroundColor = .black
        case 12:
            colorView.backgroundColor = .red
        case 13:
            colorView.backgroundColor = .black
        case 14:
            colorView.backgroundColor = .red
        case 15:
            colorView.backgroundColor = .black
        case 16:
            colorView.backgroundColor = .red
        case 17:
            colorView.backgroundColor = .black
        case 18:
            colorView.backgroundColor = .red
        case 19:
            colorView.backgroundColor = .black
        case 20:
            colorView.backgroundColor = .black
        case 21:
            colorView.backgroundColor = .red
        case 22:
            colorView.backgroundColor = .black
        case 23:
            colorView.backgroundColor = .red
        case 24:
            colorView.backgroundColor = .black
        case 25:
            colorView.backgroundColor = .red
        case 26:
            colorView.backgroundColor = .black
        case 27:
            colorView.backgroundColor = .red
        case 28:
            colorView.backgroundColor = .red
        case 29:
            colorView.backgroundColor = .black
        case 30:
            colorView.backgroundColor = .red
        case 31:
            colorView.backgroundColor = .black
        case 32:
            colorView.backgroundColor = .red
        case 33:
            colorView.backgroundColor = .black
        case 34:
            colorView.backgroundColor = .red
        case 35:
            colorView.backgroundColor = .black
        case 36:
            colorView.backgroundColor = .red
        default:
            break
        }
    }
}

extension GameVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOFRowsForMainCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionViewCell.identifier, for: indexPath) as? NumberCollectionViewCell {
            let item =  getNumbersItem(index: indexPath.row)
            
            cell.setupCell(item: item,
                           index: indexPath.row)
            if case let .digit(value) = currentRate, value == indexPath.row + 1 {
                cell.viewColor.backgroundColor = .blue
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension GameVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if case let .digit(value) = currentRate, value == indexPath.row + 1 {
            currentRate = .empty
            numberCollectionView.reloadData()
        } else {
            currentRate = Rate.digit(indexPath.row + 1)
            selectedButton?.backgroundColor = .clear
            numberCollectionView.reloadData()
            checkBalanceBet()
        }
        print("didSelect", currentRate)
    }
}
