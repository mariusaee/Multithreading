import UIKit
import PlaygroundSupport

class MyViewController: UIViewController {
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "VC 1"
        view.backgroundColor = .white
        
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
        loadImage()
//        guard let imageUrl = URL(string: "https://cdn.eso.org/images/thumb300y/eso1907a.jpg") else { return }
//        if let data = try? Data(contentsOf: imageUrl) {
//            self.image.image = UIImage(data: data)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initImage()
    }
    
    func initImage() {
        image.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
        image.center = view.center
        view.addSubview(image)
    }
    
    func loadImage() {
        guard let imageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg") else { return }
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: data)
                }
            }
        }
    }
}

let vc = MyViewController()
let navBar = UINavigationController(rootViewController: vc)
navBar.view.frame = CGRect(x: 0, y: 0, width: 320, height: 550)

PlaygroundPage.current.liveView = navBar.view
