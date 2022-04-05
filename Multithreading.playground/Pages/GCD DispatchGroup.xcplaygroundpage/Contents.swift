import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



class DispatchGroupTestOne {
    private let queueSerial = DispatchQueue(label: "My Serial Queue")
    
    private let groupRed = DispatchGroup()
    
    func loadInfo() {
        queueSerial.async(group: groupRed) {
            sleep(1)
            print("1 in \(Thread.current)")
        }
        
        queueSerial.async(group: groupRed) {
            sleep(1)
            print("2 in \(Thread.current)")
        }
        
        groupRed.notify(queue: .main) {
            print("All tasks finished in \(Thread.current)")
        }
    }
}

//let dispatchGroupTestOne = DispatchGroupTestOne()
//dispatchGroupTestOne.loadInfo()

class DispatchGroupTestTwo {
    private let queueConcurrent = DispatchQueue(label: "My Serial Queue", attributes: .concurrent)
    
    private let groupBlack = DispatchGroup()
    
    func loadInfo() {
        groupBlack.enter()
        queueConcurrent.async {
            sleep(1)
            print("1 in \(Thread.current)")
            self.groupBlack.leave()
        }
        
        groupBlack.enter()
        queueConcurrent.async {
            sleep(1)
            print("2 in \(Thread.current)")
            self.groupBlack.leave()
        }
        
        // Пока весь код выше не выполнится, метод будет ждать.
        groupBlack.wait()
        
        print("Finished")
        
        groupBlack.notify(queue: .main) {
            print("All tasks finished in \(Thread.current)")
        }
    }
}

//let dispatchGroupTestTwo = DispatchGroupTestTwo()
//dispatchGroupTestTwo.loadInfo()

class EightImage: UIView {
    public var ivs = [UIImageView]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100)))
        
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 300, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 300, y: 100, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 400, width: 100, height: 100)))
        ivs.append(UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100)))
        
        for i in 0...7 {
            ivs[i].contentMode = .scaleAspectFit
            self.addSubview(ivs[i])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var view = EightImage(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
view.backgroundColor = .red

let imageUrls = [
    "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg",
    "https://media.game-debate.com/images/news/27926/red-dead-redemption-2-best-pc-graphics-settings-for-optimised-performance.jpg",
    "https://image.ceneostatic.pl/data/products/87313271/i-magiczne-drzewo-pioro-t-rexa-andrzej-maleszka.jpg",
    "https://image.posterlounge.pl/images/l/1892396.jpg"
]

var images = [UIImage]()

PlaygroundPage.current.liveView = view

func asyncLoadImage(imageURL: URL,
                    runQueue: DispatchQueue,
                    completionQueue: DispatchQueue,
                    completion: @escaping (UIImage?, Error?) -> Void) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async { completion(UIImage(data: data), nil) }
        } catch let error {
            completionQueue.async { completion(nil, error) }
        }
    }
}

func asyncGroup() {
    let aGroup = DispatchGroup()
    
    for i in 0...3 {
        aGroup.enter()
        asyncLoadImage(imageURL: URL(string: imageUrls[i])!,
                       runQueue: .global(),
                       completionQueue: .main) { (result, error) in
            guard let image1 = result else { return }
            images.append(image1)
            aGroup.leave()
        }
    }
    
    aGroup.notify(queue: .main) {
        for i in 0...3 {
            view.ivs[i].image = images[i]
        }
    }
}

asyncGroup()
