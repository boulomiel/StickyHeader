//
//  File.swift
//  
//
//  Created by Ruben Mimoun on 15/09/2023.
//

import Foundation
import SwiftUI

struct ScrollDetector: UIViewRepresentable {
    var onScroll: (CGFloat) -> ()
    var onDraggingEnd: (CGFloat, CGFloat, CGSize) -> ()
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView
                .superview?
                .superview?
                .superview as? UIScrollView,
               !context.coordinator.isDelegateAdded {
               
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: ScrollDetector
        
        init(parent: ScrollDetector) {
            self.parent = parent
        }
        
        var isDelegateAdded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            print(scrollView.contentOffset)
            parent.onDraggingEnd(scrollView.contentOffset.y, velocity.y, scrollView.contentSize)
        }
    }
}
