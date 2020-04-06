import UIKit

//KVO - Key Value Observer

//KVO is part of the observer pattern, e.g notif center

//KVO is one-to many pattern relationship as opposed to delegation which is one-to-one
//In the delegation pattern
/*
 class ViewController: UIViewController{ }
 */
//e.g tableview.datasource = self

//KVO is an objective-C runtime
//along with KVO being an objective-C runtime some essential are required
/*
 1. The object being observed needs to be a class
 2. The class needs to inherit from NSObject, NSObject is the top abstract class in ObjC
 3. Any property being marked for observation needs to be prefixed with @objc
 dynamic. Dynamic means that the property is being dynamically dispatched (at runtime the compiler verifies the underlying property)
 In Swift types are typically statically dispatched which means they are checked at compile time vc Objective-C which is dynammically dispatched and checked at runtime
 //CLASS AND PROPERTY needs to be marked with @objc
 */

//Dog class - class being observed

//Observer class One
@objc class Dog: NSObject {
    var name: String
    @objc dynamic var age: Int //age is an observable property
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

//Observer class Two

class DogWalker {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation? //a handle for the property being observed
    
    init(dog:Dog){
        self.dog = dog
        configureBirthday()
    }
    
    private func configureBirthday() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            //update UI accordingly if in View Controller
            guard let age = change.newValue else {
                return
            }
            print ("Hey \(dog.name), happy \(age) from the dog walker ")
            print("old \(change.oldValue ?? 0)")
            print("new \(change.newValue ?? 0)")
        })
    }
}

class DogGroomer {
    let dog: Dog
    var birthdayObservation: NSKeyValueObservation?
    
    init(dog:Dog){
        self.dog = dog
        configureBday()
    }
    
    private func configureBday() {
        birthdayObservation = dog.observe(\.age, options: [.old, .new], changeHandler: { (dog, change) in
            
            //unwrap new value on change
            guard let age = change.newValue else { return }
            print("Hey \(dog.name), happy \(age) birthday from your groomer")
            print("old \(change.oldValue ?? 0)")
            print("new \(change.newValue ?? 0)")
        })
    }
}

//test out KVO observing on the .age property of Dog
//bot classes (DogWalker and DogGroomer should get .age changes)

let snoopy = Dog(name: "Snoopy", age: 5)
let dogWalker = DogWalker(dog: snoopy)
let dogGroomer = DogGroomer(dog: snoopy)

snoopy.age += 1
