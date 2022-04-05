import Darwin
import Foundation

// POSIX написано на C

//var thread = pthread_override_t(bitPattern: 0) // создаем поток
//var attribute = pthread_attr_t() // создаем атрибут


//var nsthread = Thread {
//    print("test")
//}
//nsthread.start()

// Создаем поток
var pthread = pthread_t(bitPattern:0)
// Создаем атрибут
var attribute = pthread_attr_t()
// Инициализируем атрибут
pthread_attr_init(&attribute)
// Метод которому передаем атрибут и вызываем QoS.
pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_USER_INITIATED, 0)
// Создаем поток с адресом треда, атрибутом и замыканием, в котором выполняем код.
pthread_create(&pthread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
    print("test")
// После выполнения кода, прямо в этом же замыкании мы можем ппереопределить QoS
    pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0)
    return nil
}, nil)

let nsThread = Thread {
    print("test NSThread")
    print(qos_class_self())
}
nsThread.qualityOfService = .userInteractive
nsThread.start()

print(qos_class_main())


