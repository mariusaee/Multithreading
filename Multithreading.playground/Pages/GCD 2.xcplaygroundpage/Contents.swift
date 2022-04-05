import UIKit
import PlaygroundSupport

class MyViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC 1"
        button.addTarget(self, action: #selector(pressAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initButton()
    }
    
    @objc func pressAction() {
        let vc = MySecondViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("Press", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        view.addSubview(button)
    }
}

class MySecondViewController: UIViewController {
    
    var image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC 2"
        
        // Запуск цикла происходит в main потоке. Приложение зависает и считает до 20_000.
        for i in 0...20_000 {
            print(i)
            print(Thread.current)
        }
        
        //   Ниже мы перевели все в global очередь и указали QOS. Теперь все выполняется в фоне и приложуха не зависает!
        DispatchQueue.global(qos: .utility).async {
            for i in 0...10_000 {
                print(i)
                print(Thread.current)
            }
        }
        
        //  А теперь еще круче! Вместо цикла for in мы используем метод concurrentPerform. Теперь GCD сам выбирает очереди для выполнения задач. Какие-то задачи попадают в очередь 3, какие-то в 5, какие-то в 9 и так далее. Все работает еще быстрее!
        DispatchQueue.global(qos: .utility).async {
            DispatchQueue.concurrentPerform(iterations: 10_000) {
                print($0)
                print(Thread.current)
            }
        }
        
        // Управляемая очередь!
        let queue = DispatchQueue(label: "MyQueue",
                                  attributes: [.concurrent, .initiallyInactive])
        queue.async {
            print("Done")
        }
        print("Not started...")
        
        queue.activate()
        print("Active")
        
        queue.suspend()
        print("Suspended")
        
        queue.resume()
    }
}

let vc = MyViewController()
let navBar = UINavigationController(rootViewController: vc)
navBar.view.frame = CGRect(x: 0, y: 0, width: 320, height: 550)

PlaygroundPage.current.liveView = navBar.view
