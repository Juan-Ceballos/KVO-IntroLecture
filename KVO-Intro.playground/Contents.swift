import UIKit

// KVO - Key Value Observing
// KVO is part of the observer pattern similar to Notif Center
// One to Many pattern relationship unlike del One to One

// In delegation pattern
// class VC: ViewController {}
// eg tableView.datasource = self

// KVO is an objc runtime API, some essentials required
// Object only works with reference types so on classes
// 1. The object being observed needs to be a class
// 2. The class needs to inherit from NSObject, it's top abstract class in Objective-C
// 3. Any property being marked for observation needs to be prefixed with @objc dynamic. Dynamic means
//    that the property is being dynamically dispatched (at runtime the compiler verifies the
//    underlying property)
// In swift types are statiscally dispatched which means they are checked at compile time vs objective c which
// dynamically dispatched and check at runtime

// dog class(class being observed) - will have a property to be observed
@objc class Dog: NSObject { // inherits from NSObject, for protocols conforms
    var name: String
    @objc dynamic var age: Int // age is observable property
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    // Dog is the subject
}

// observer class one
class DogWalker { // class vc1
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? // a handle for the property being observed
    
    init(dog: Dog)  {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        // now can do observation syntax
        // \. = keypass for kvo
        // dog value, and change property will have values for age new and old
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            guard let age = change.newValue else    {
                return
            }
            print("hey \(dog.name), hbd \(age) walker")
            print("dw: \(change.oldValue ?? 0), \(change.newValue ?? 0)")
        })
    }
}

// 2 classes observing same property, will get same value when change is made
// otherwise wuda used custom del or completion handler
// observer class 2
class DogGroomer    {
    let dog: Dog
    var birthdayObservarion: NSKeyValueObservation?
    
    init(dog: Dog)  {
        self.dog = dog
        configureBirthdayObservation()
    }
    
    private func configureBirthdayObservation() {
        birthdayObservarion = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            // unwrap the new value property on change as it's optional
            guard let age = change.newValue else    {return}
            print("hey \(dog.name), hbd \(age) groomer")
            print("dg: \(change.oldValue ?? 0), \(change.newValue ?? 0)")
        })
    }
}

//  test out KVO observing on the .age property of Dog
//  both classes get .age changes

let snoopy = Dog(name: "Snoopy", age: 5)
let dogWalker = DogWalker(dog: snoopy)
let dogGroomer = DogGroomer(dog: snoopy) // both reference to snoopy

snoopy.age += 1 // 5 to 6, run when changes execute code in handler



