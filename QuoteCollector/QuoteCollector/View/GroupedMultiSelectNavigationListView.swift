//
//  GroupedMultiSelectNavigationListView.swift
//  QuoteCollector
//
//  Created by Eric Latham on 12/26/21.
//

import SwiftUI
import CoreData

struct GroupedMultiSelectNavigationListItemView<
    Element: NSManagedObject,
    RowView: View,
    ContentView: View
>: View {
    @ObservedObject var element: Element
    @Binding var selectedElements: Set<Element>
    var inSelectionMode: Bool

    let rowView: RowView
    let contentView: ContentView

    init(
        element: Element,
        selectedElements: Binding<Set<Element>>,
        inSelectionMode: Bool,
        @ViewBuilder rowViewBuilder: (Element) -> RowView,
        @ViewBuilder contentViewBuilder: (Element) -> ContentView
    ) {
        self.element = element
        _selectedElements = selectedElements
        self.inSelectionMode = inSelectionMode
        self.rowView = rowViewBuilder(element)
        self.contentView = contentViewBuilder(element)
    }

    var body: some View {
        let isSelected: Bool = selectedElements.contains(element)
        if inSelectionMode {
            HStack {
                Button {
                    if isSelected { selectedElements.remove(element) }
                    else { selectedElements.update(with: element) }
                } label: {
                    Image(
                        systemName: isSelected
                            ? "checkmark.circle.fill"
                            : "checkmark.circle"
                    )
                }
                rowView
            }.foregroundColor(isSelected ? .accentColor : .black)
        } else { NavigationLink { contentView } label: { rowView } }
    }
}

struct GroupedMultiSelectNavigationListSortSelectView<E>: View {
    @Binding var selectedSort: Sort<E>
    let sortOptions: [Sort<E>]

    var body: some View {
        Menu {
            Picker("Sort By", selection: $selectedSort) {
                ForEach(sortOptions, id: \.self) { sort in
                    Text(sort.name)
                }
            }
        } label: { Text("Sort") }
        .pickerStyle(.inline)
    }
}

struct GroupedMultiSelectNavigationListView<
    Element: NSManagedObject,
    ElementRowView: View,
    ElementContentView: View,
    ConstantListPrefixView: View,
    ConstantListSuffixView: View,
    AddElementSheetContentView: View,
    EditParentSheetContentView: View,
    BulkEditSheetContentView: View,
    BulkMoveSheetContentView: View
>: View {
    @SectionedFetchRequest var elements: SectionedFetchResults<String, Element>
    @Binding var searchQuery: String
    @Binding var selectedSort: Sort<Element>
    var sortOptions: [Sort<Element>]
    var elementRowViewBuilder: (Element) -> ElementRowView
    var elementContentViewBuilder: (Element) -> ElementContentView
    var constantListPrefixViewBuilder: (() -> ConstantListPrefixView)? = nil
    var constantListSuffixViewBuilder: (() -> ConstantListSuffixView)? = nil
    var addElementSheetContentViewBuilder: (() -> AddElementSheetContentView)? = nil
    var editParentSheetContentViewBuilder: (() -> EditParentSheetContentView)? = nil
    var bulkEditSheetContentViewBuilder: ((Set<Element>) -> BulkEditSheetContentView)? = nil
    var bulkMoveSheetContentViewBuilder: ((Set<Element>) -> BulkMoveSheetContentView)? = nil
    var bulkDeleteFunction: ((Set<Element>) -> Void)? = nil
    var bulkDeleteAlertMessage: String = "This action cannot be undone!"
    
    @State private var selectedElements: Set<Element> = []
    @State private var inSelectionMode: Bool = false
    @State private var showAddElementView: Bool = false
    @State private var showEditParentView: Bool = false
    @State private var showBulkEditView: Bool = false
    @State private var showBulkMoveView: Bool = false
    @State private var showBulkDeleteAlert: Bool = false

    var body: some View {
        List {
            if constantListPrefixViewBuilder != nil {
                constantListPrefixViewBuilder!()
            }
            ForEach(elements) { section in
                Section(header: Text(section.id)) {
                    ForEach(section, id: \.self) { element in
                        GroupedMultiSelectNavigationListItemView(
                            element: element,
                            selectedElements: $selectedElements,
                            inSelectionMode: inSelectionMode,
                            rowViewBuilder: elementRowViewBuilder,
                            contentViewBuilder: elementContentViewBuilder
                        )
                    }
                }
            }
            if constantListSuffixViewBuilder != nil {
                constantListSuffixViewBuilder!()
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $searchQuery)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    if inSelectionMode {
                        selectedElements.removeAll()
                    }
                    inSelectionMode.toggle()
                } label: {
                    Text(inSelectionMode ? "Done" : "Select")
                }
                if inSelectionMode {
                    let disabled: Bool = selectedElements.isEmpty
                    if bulkEditSheetContentViewBuilder != nil {
                        Button { showBulkEditView = true }
                            label: { Text("Edit") }.disabled(disabled)
                    }
                    if bulkMoveSheetContentViewBuilder != nil {
                        Button { showBulkMoveView = true }
                            label: { Text("Move") }.disabled(disabled)
                    }
                    if bulkDeleteFunction != nil {
                        Button { showBulkDeleteAlert = true }
                            label: { Text("Delete") }.disabled(disabled)
                    }
                } else {
                    GroupedMultiSelectNavigationListSortSelectView<Element>(
                        selectedSort: $selectedSort,
                        sortOptions: sortOptions
                    )
                    if addElementSheetContentViewBuilder != nil {
                        Button { showAddElementView = true } label: { Text("Add") }
                    }
                    if editParentSheetContentViewBuilder != nil {
                        Button { showEditParentView = true } label: { Text("Edit") }
                    }
                }
            }
        }
        .sheet(isPresented: $showAddElementView ) {
            // Only renders when addElementSheetContentViewBuilder != nil
            addElementSheetContentViewBuilder!()
        }
        .sheet(isPresented: $showEditParentView ) {
            // Only renders when editParentSheetContentViewBuilder != nil
            editParentSheetContentViewBuilder!()
        }
        .sheet(isPresented: $showBulkEditView ) {
            // Only renders when bulkEditSheetContentViewBuilder != nil
            bulkEditSheetContentViewBuilder!(selectedElements)
        }
        .sheet(isPresented: $showBulkMoveView ) {
            // Only renders when bulkMoveSheetContentViewBuilder != nil
            bulkMoveSheetContentViewBuilder!(selectedElements)
        }
        .alert(isPresented: $showBulkDeleteAlert) {
            // Only renders when bulkDeleteFunction != nil
            Alert(
                title: Text("Are you sure?"),
                message: Text(bulkDeleteAlertMessage),
                primaryButton: .destructive(Text("Yes, delete")) {
                    withAnimation {
                        bulkDeleteFunction!(selectedElements)
                        selectedElements.removeAll()
                    }
                },
                secondaryButton: .cancel(Text("No, cancel"))
            )
        }
    }
}
