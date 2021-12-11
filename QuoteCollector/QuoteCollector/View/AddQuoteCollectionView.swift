//
//  AddQuoteCollectionView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/10/21.
//

import SwiftUI
import CoreData

/**
 * For adding and editing quote collections.
 */
struct AddQuoteCollectionView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentation

    @State private var name = ""
    @State private var nameError = false

    var objectId: NSManagedObjectID?
    
    let viewModel = AddQuoteCollectionViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Quote Collection Info") {
                        VStack {
                            TextField(
                                "Name",
                                text: $name,
                                prompt: Text("Name")
                            )
                            if nameError {
                                Text("Name is required")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    Button {
                        if name.isEmpty {
                            nameError = name.isEmpty
                        } else {
                            let values = QuoteCollectionValues(name: name)
                            _ = viewModel.addQuoteCollection(
                                context: context, objectId: objectId, values: values
                            )
                            presentation.wrappedValue.dismiss()
                        }
                    } label: {
                        Text(objectId == nil ? "Add" : "Edit")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: 300)
                    }
                    .tint(Color("rw-green"))
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 5))
                    .controlSize(.large)
                }
                .navigationTitle("\(objectId == nil ? "Add Quote Collection" : "Edit Quote Collection")")
                Spacer()
            }
            .onAppear {
                if let quoteCollectionId = objectId,
                   let quoteCollection = viewModel.fetchQuoteCollection(context: context, objectId: quoteCollectionId)
                {
                    name = quoteCollection.name!
                }
            }
        }
    }
}

struct AddQuoteCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteCollectionView()
    }
}
