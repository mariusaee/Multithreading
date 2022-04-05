import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class DispatchWorkItemOne {
    private let queue = DispatchQueue(label: "DispatchWorkItemOne", attributes: .concurrent)
    
    func create() {
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("Task Stated")
        }
        
        workItem.notify(queue: .main) {
            print(Thread.current)
            print("Task finished")
        }
        
        queue.async(execute: workItem)
        
    }
}

//let dispatchWorkItemOne = DispatchWorkItemOne()
//dispatchWorkItemOne.create()

//-------------------------------------------------------------------------------------------

// Ниже пример с serial queue. Все задачи будут выполнены последовательно в одной очереди.
class DispatchWorkItemTwo {
    private let queue = DispatchQueue(label: "DispatchWorkItemTwo")
    
    func create() {
        queue.async {
            sleep(1)
            print(Thread.current)
            print("Task 1")
        }
        
        queue.async {
            sleep(1)
            print(Thread.current)
            print("Task 2")
        }
        
        let workItem = DispatchWorkItem {
            print(Thread.current)
            print("WorkItem started task")
        }
        
        queue.async(execute: workItem)
        workItem.cancel()
    }
}

//let dispatchWorkItemTwo = DispatchWorkItemTwo()
//dispatchWorkItemTwo.create()

// Пример с View
var view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
var myImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

myImage.backgroundColor = .blue
myImage.contentMode = .scaleAspectFit
view.addSubview(myImage)

PlaygroundPage.current.liveView = view

let imageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg")!

// Загрузка картинки классическим способом
func fetchImage() {
    let queue = DispatchQueue.global(qos: .utility)
    
    queue.async {
        guard let data = try? Data(contentsOf: imageUrl) else { return }
        
        DispatchQueue.main.async {
            myImage.image = UIImage(data: data)
        }
    }
}

//fetchImage()

// Загрузка картинки с помощью DispatchWorkItem
func fetchImageWithDispatchWorkItem() {
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        data = try? Data(contentsOf: imageUrl)
        print(Thread.current)
    }
    
    queue.async(execute: workItem)
    
    // Подписываемся на уведомление. Когда наш workItem завершится, сработает наш notify и вызовет замыкание, в котором мы отображаем загруженную картинку.
    workItem.notify(queue: DispatchQueue.main) {
        guard let imageData = data else { return }
        myImage.image = UIImage(data: imageData)
    }
}

//fetchImageWithDispatchWorkItem()


// Загрузка картинки с помощью async URLSession
func fetchImageWithURLSession() {
    let task = URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
        print(Thread.current)
        
        if let imageData = data {
            DispatchQueue.main.async {
                print(Thread.current)
                myImage.image = UIImage(data: imageData)
            }
        }
    }
    task.resume()
}

fetchImageWithURLSession()
