//
//  SavedProductsView.swift
//  AuraSkin
//
//  Created by Risma Harby on 23/05/24.
//

import SwiftUI

struct SavedProductsView: View {
    @StateObject var segmentState = SegmentState()
    
    @StateObject var viewModel = ProductListViewModel()
    @State private var category = ""
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "Facial Wash"
    
    let categories = ["Facial Wash", "Toner", "Moisturizer", "Sunscreen"]
    @FetchRequest(sortDescriptors: []) private var products: FetchedResults<Product>
    
    let colorHex = "#003C43"
    
    init() {
        
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                SectionTextLeading("Current Use")
                    .foregroundColor(Color.auraSkinPrimaryColor)
            }.padding(.horizontal)
                .onAppear {
                    segmentState.segment = "saved"
                    if segmentState.segment == "saved" {
                        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.auraSkinPrimaryColor)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
                        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                        UISegmentedControl.appearance().setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
                    } else {
                        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 14)], for: .normal)
                        UISegmentedControl.appearance().backgroundColor = .systemBackground.withAlphaComponent(0.10)
                    }
                }
            
            VStack() {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.flexible(), spacing: 1)]) {
                        ForEach(filteredProducts, id: \.self) { product in
                            ProductCardView(product: product)
                                .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .listRowSeparator(.hidden, edges: .all)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .listStyle(.plain)
                .navigationTitle("Saved Products")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                .padding(.leading, -5)
                .padding(.bottom, 5)
                
                Picker("Choose your starter", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                            .foregroundColor(.white)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.leading, 9)
                .padding(.trailing, 9)
                .frame(height: 30)
                
                // below is for after segment
                ScrollView(.vertical) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 5),
                        GridItem(.flexible(), spacing: 5),
                        GridItem(.flexible(), spacing: 5)
                    ]) {
                        ForEach(filteredSegmentProducts, id: \.self) { product in
                            
                            ProductCardMiniView(product: product)
                                .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    
                    .listStyle(.plain)
                    .navigationTitle("Saved Products")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $selectedCategory)
                }
                .padding(.leading, 9)
                .padding(.trailing, 9)
            }
            .frame(alignment: .top)
        }
    }
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products.map { $0 }
        } else {
            return products.filter { product in
                (product.currentlyUsed == true) &&
                ( product.name?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (product.category?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }
    var filteredSegmentProducts: [Product] {
        print("Segment State: \(segmentState.segment)")
        return products.filter { product in
            (product.category == selectedCategory) &&
            (searchText.isEmpty || (product.name?.lowercased().contains(searchText.lowercased()) ?? false))
        }
    }
}

#Preview {
    SavedProductsView()
    
}
