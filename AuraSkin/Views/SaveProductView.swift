//
//  SaveProductView.swift
//  AuraSkin
//
//  Created by M. Ilham Syaputra on 19/05/24.
//

import SwiftUI
import PhotosUI

struct SaveProductView: View {
    // MARK: Core data
    @EnvironmentObject var manager: CoreDataManager
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    enum photoStateEnum {
        case noImage, image
    }

    @State private var photosPickerItem: PhotosPickerItem?
    @State private var photoState: photoStateEnum = .noImage

    @State var product: ProductModel
    
    var saveProductViewModel = SaveProductViewModel()
    
    init(ingredients: String) {
        _product = State(initialValue: ProductModel(
            name: "",
            ingredients: ingredients,
            category: "Facial Wash",
            currentlyUsed: true,
            expiredDate: Date.now,
            image: UIImage(named: "productImageDefault")?.pngData()
        ))
    }

    var body: some View {
        VStack {
            PhotosPicker(selection: $photosPickerItem, matching: .images) {
                switch photoState {
                    case .noImage:
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 55, height: 55)
                            .foregroundStyle(.gray)
                            .frame(width: 215, height: 200)
                            .overlay(RoundedRectangle(cornerRadius: 11).stroke(.gray))
                            .padding(.bottom)
                    case .image:
                        Image(data: (product.image ?? UIImage(named: "productImageDefault")?.pngData())!)!
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 215, height: 200)
                            .foregroundColor(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                            .padding(.bottom)
                }
            }
                .onChange(of: photosPickerItem) { _, _ in
                    Task {
                        if let photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                            if UIImage(data: data) != nil {
                                product.image = data
                                self.photoState = .image
                            }
                        }
                        photosPickerItem = nil
                    }
                }


            SectionTextLeading("Product's Name")
                .foregroundStyle(Color(UIColor.darkGray))

            TextFieldComponents(text: $product.name, localizedStringKey: "product's name", prompt: "product's name")
                .padding(.bottom)

            SectionTextLeading("Basic Skincare Category")
                .foregroundStyle(Color(UIColor.darkGray))
            ConfirmationDialogComponent(selectedOption: $product.category, confirmationDialogTitle: "Select category", items: productCategory)
                .padding(.bottom)

            SectionTextLeading("Expired Date")
                .foregroundStyle(Color(UIColor.darkGray))
            DatePickerComponent(expiredDate: $product.expiredDate)
                .padding(.bottom)

            ToggleComponent(text: "Currently used", isOn: $product.currentlyUsed)

            Button(action: {
                saveProductViewModel.saveProduct(context: viewContext, product: product)
                dismiss()
            }, label: {
                TestButton(text: "Save")
            })
        }
        .navigationTitle("Add Product")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("Cancel")
                }
                .foregroundStyle(Color.auraSkinPrimaryColor)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct SaveProductView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SaveProductView(ingredients: "Sample ingredients")
        }
    }
}

#Preview {
    SaveProductView_Previews.previews
}
