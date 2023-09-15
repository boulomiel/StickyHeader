//
//  StickyHeaderView.swift
//  
//
//  Created by Ruben Mimoun on 15/09/2023.
//

import Foundation
import SwiftUI

public enum HeaderDirection {
    case center
    case leading
    case trailing
    
    func xOffset(_ progress: CGFloat, minX: CGFloat) -> CGFloat {
        switch self {
        case .center:
            return 30 * progress
        case .leading:
            return -(minX - 15) * progress
        case .trailing:
            return (minX + 15) * progress
        }
    }
}

public struct StickyHeaderView <
    Header: View,
    Title: View,
    ScrollBody: View,
    ScrollBackground: View,
    HeaderBackground: View,
    LeftNav: View,
    RightNav: View>: View {
    
    let headerDirection: HeaderDirection
    var screenRatioHeaderHeight: CGFloat
    var header: (CGFloat, CGSize) -> Header
    var TitleView: (CGFloat) -> Title
    var Scroll: (CGFloat) -> ScrollBody
    var ScrollBG: (CGFloat) -> ScrollBackground
    var BackgroundView: (CGFloat) -> HeaderBackground
    var LeftNavButton: (CGFloat) -> LeftNav
    var RightNavButton: (CGFloat) -> RightNav

    @State var offsetY:CGFloat = 0
    @State var headerHeight: CGFloat = 0.0
    let minimumHeaderHeight: CGFloat = 80
    
    var updatingHeaderHeight: CGFloat {
       
        (headerHeight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offsetY)
    }
    var progress: CGFloat {
        max(min(-offsetY / (headerHeight - minimumHeaderHeight), 1), 0)
    }
        
    public init(
         headerDirection: HeaderDirection = .leading,
         screenRationHeaderHeight: CGFloat = 0.3,
         @ViewBuilder header: @escaping (CGFloat, CGSize) -> Header,
         @ViewBuilder title: @escaping (CGFloat) -> Title = { _ in EmptyView() },
         @ViewBuilder scrollBody: @escaping (CGFloat) -> ScrollBody,
         @ViewBuilder background: @escaping (CGFloat) -> HeaderBackground = {_ in EmptyView()},
         @ViewBuilder letfNavButton: @escaping (CGFloat) -> LeftNav = {_ in EmptyView()},
         @ViewBuilder rightNavButton: @escaping (CGFloat) -> RightNav = {_ in EmptyView()},
         @ViewBuilder scrollBackground: @escaping (CGFloat) -> ScrollBackground = {_ in EmptyView()}
    ) {
        self.screenRatioHeaderHeight = screenRationHeaderHeight
        self.header = header
        self.Scroll = scrollBody
        self.TitleView = title
        self.BackgroundView = background
        self.LeftNavButton = letfNavButton
        self.RightNavButton = rightNavButton
        self.ScrollBG = scrollBackground
        self.headerDirection = headerDirection
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                let size: CGSize = proxy.size
                ScrollView {
                    VStack {
                        HeaderView(size: size)
                            .zIndex(1000)
                        Scroll(progress)
                    }
                    .background {
                        ScrollDetector { offset in
                            offsetY = -offset

                        } onDraggingEnd: { offset, velocity, scrollSize in
                        }
                    }
                }
                .onAppear {
                    headerHeight = size.height * screenRatioHeaderHeight
                }
            }
            .background {
                ScrollBG(progress)
            }
            .onChange(of: progress, perform: { newValue in
                print(#function, newValue)
            })
            .ignoresSafeArea()
            .toolbarBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    LeftNavButton(progress)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    RightNavButton(progress)
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView(size: CGSize) -> some View {
        GeometryReader { proxy in
            ZStack {
                BackgroundView(progress)
                VStack {
                    GeometryReader { reader in
                        let rect = reader.frame(in: .global)
                        let midY = rect.midY
                        
                        header(progress, .init(width: size.width, height: headerHeight))
                            .aspectRatio(contentMode: .fill)
                            .frame(width: rect.width, height: rect.height)
                            .scaleEffect(1 - min(0.7, progress), anchor: .leading)
                            .offset(x: headerDirection.xOffset(progress, minX: rect.minX),
                                    y: min(max(50 , midY), rect.maxY) * progress)
                            .onAppear {
                                print(rect.size)
                            }
                            .opacity(headerDirection == .center ? 1 - progress : 1)
                    }
                    .frame(width: headerHeight * screenRatioHeaderHeight,
                           height: headerHeight * screenRatioHeaderHeight)
                    
                    TitleView(progress)
                        .scaleEffect(1 - min(0.15, progress))
                        .offset(y: -4.5 * progress)
                }
            }
            .frame(height: updatingHeaderHeight,
                   alignment: .bottom)
            .offset(y:-offsetY)
        }
        .frame(height: headerHeight)
    }
}

struct StickyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StickyHeaderView (headerDirection: .center){ progress, headerSize in
            if progress == 0 {
                Image(systemName: "apple.logo")
                    .resizable()
            } else {
                Image(systemName: "person")
                    .resizable()
            }
        } title: { progress in
            Text(" changing title \(progress)")
                .frame(maxWidth: .infinity)

        } scrollBody: { progress in
           Rectangle()
                .fill(Color(red: 1.0 * min(0.2, progress), green: 1 * min(0.5, progress), blue: 1 * min(0.3, progress)))
                .frame(height: 400)
            
            Rectangle()
                 .fill(Color.green)
                 .frame(height: 500)
            
            Rectangle()
                 .fill(Color.red)
                 .frame(height: 400)
        } background: { progress in
            Color.orange
        } rightNavButton: { progress in
            Button {
                
            } label: {
                Image(systemName: "apple.logo")
                    .opacity(progress)
            }

        } scrollBackground: { _ in
            Color.red
        }
    }
}
