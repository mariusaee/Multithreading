import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var array = [Int]()

for i in 0...9 {
    array.append(i)
}

print(array)
print(array.count)

// Ниже пример заполнения массива через парралельный метод concurrentPerform. Получилась гонка потоков.
var arrayWithRaceCondition = [Int]()

DispatchQueue.concurrentPerform(iterations: 10) { index in
    arrayWithRaceCondition.append(index)
}

print(arrayWithRaceCondition)
print(arrayWithRaceCondition.count)

class SafeArray<T> {
    private var array = [T]()
    private let queue = DispatchQueue(label: "My Queue", attributes: .concurrent)
    
    public func append(_ value: T) {
        queue.async(flags: .barrier) {
            self.array.append(value)
        }
    }
    
    public var valueArray: [T] {
        var result = [T]()
        queue.sync {
            result = self.array
        }
        return result
    }
}

var safeArray = SafeArray<Int>()

DispatchQueue.concurrentPerform(iterations: 10) { index in
    safeArray.append(index)
}

print(safeArray.valueArray)
print(safeArray.valueArray.count)
