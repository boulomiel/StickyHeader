# StickyHeader
A SPM Package for SwiftUI to Implement a customizable Sticky Header

# Examples:
![](https://github.com/boulomiel/StickyHeader/blob/main/StickyHeader3.gif)
![](https://github.com/boulomiel/StickyHeader/blob/main/StickyHeader2.gif)
![](https://github.com/boulomiel/StickyHeader/blob/main/StickyHeader4.gif)

# Installation:

SPM: https://github.com/boulomiel/StickyHeader

## Parameters:
  - headerDirection:leading, trailing or center whether the header will animate whilst scrolling to the top leading, top center, top trailing. (<b>default: leading</b>).
  - screenRationHeaderHeight: Screen ration height of header (<b>default: 0.3</b>).
  - header: Header view content. Gives current scroll position, and current header size.
  - title: Title view below the header. Gives current scroll position.
  - scrollBody: The content of the scroll view below the header. Gives current scroll position.
  - background: header background. Gives current scroll position. (<b>default: EmptyView()</b>).
  - letfNavButton : Leading navigation button. Gives current scroll position. (<b>default: EmptyView()</b>).
  - rightNavButton : Trailing navigation button. Gives current scroll position. (<b>default: EmptyView()</b>).
  - scrollBackground: ScrollView background.  Gives current scroll position. (<b>default: EmptyView()</b>).
  - 
## Notes:
- iOS : <b>.v16</b>
- The content already being a <b>ScrollView</b>, scrollBody can add views in a list only with <b>ForEach</b>.

# Implementation:

        import StickyHeader

        struct ContentView: View {

          var body: some View {
               StickyHeaderView(
                screenRationHeaderHeight: 0.3,
                headerDirection: .leading,
                header: { progress, size in
                    Map(coordinateRegion: $coordinateRegion,
                        annotationItems: annotations,
                        annotationContent: {
                        MapMarker(coordinate: $0.location)
                    })
                    .onAppear {
                        print("header", size)
                    }
                    .ignoresSafeArea()
                    .frame(width: size.width, height: size.height * 2)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.horizontal)
                    .opacity(1 - progress)
                    .shadow(radius: 4, y: 8)
                    .task {
                        await getLocationForAddress()
                    }
                    
            }, title: { progress in
                if progress < 1 {
                    ScreenText(addressTitle)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 3)
                        .frame(maxWidth: .infinity)
                } else {
                    ScreenText(addressTitleShort)
                        .frame(maxWidth: .infinity)
    
                }
    
            }, scrollBody: { progress in
                Content()
            }, background: { _ in
                Spacer()
            }, letfNavButton: { progress in
                CloseButtonView(foregroundColor: .orange.opacity(0.8)) {
                    router.closeModal()
                }
                .padding(.bottom, 4)
                .shadow(radius: 3 * progress, x: 3 * progress, y: 4 * progress)
            }, scrollBackground: { progress in
                LinearGradient(colors: [.yellow,
                    .orange.opacity(1 - min(0.5, progress))],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
            })
          
          }
        
        }


# Credits:
Gifs built with [RocketSim](https://www.rocketsim.app/)
