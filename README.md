# SwiftUIKit
Another UIKit layout system but based on SwiftUI declarative syntax sugar

![Example](https://raw.githubusercontent.com/garranhado/SwiftUIKit/master/Screenshot.jpg)

## Motivation
- SwiftUI requires iOS/iPadOS/tvOS 13.0

## Notes:
- Not a Framework / Library, **it's just an Example**
- Unlike SwiftUI, this do not replace UIViewControllers, **it's just an UI builder**
- You are free to use, change, share and make a next great UIKit Framework

## Usage

1. Create your empty UIViewControllers on storyboard and use *HostingView* as custom class for root view
2. Inside your UIViewController Make a property or function that return *View* type

```swift
var viewBody: View {
    VStack(spacing: 50) {
        Text("Movies")
            .font(style: .title1)
        ZStack {
            MovieCard("Minions: The Rise of Gru", detailText: "M/6 | Animation", image: "minions-2")
                .offset(x: showed ? -20 : 0, y: showed ? 10 : 0)
                .rotationEffect(angle: showed ? -10 : 0)
            MovieCard("Despicable Me 3", detailText: "M/6 | 1h 29min | Animation", image: "minions-3")
                .offset(x: showed ? 20 : 0, y: showed ? 10 : 0)
                .rotationEffect(angle: showed ? 10 : 0)
            MovieCard("Minions", detailText: "M/6 | 1h 31min | Animation", image: "minions-1")
        }
        HStack(spacing: 10) {
            MyButton("BUY", action: #selector(self.buttonAction), secondary: false)
            MyButton("TRAILER", action: #selector(self.buttonAction), secondary: true)
        }
    }
}
```

3. Render your view inside *viewDidLoad()* function

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    showed = false
    
    let hv = view as! HostingView
    hv.render(viewBody)
}

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    showed = true

    let hv = view as! HostingView
    hv.animatedRender(viewBody, animation: .spring())
}
```
