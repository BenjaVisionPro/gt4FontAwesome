Class {
	#name : 'FontAwesomeImportMenuElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconLibraryClass',
		'menuModel',
		'metadataPathEditor',
		'packageNameEditor',
		'familyNameEditor',
		'versionEditor',
		'stylesList',
		'categoriesList',
		'statusLabel',
		'availableStyles',
		'selectedStyles',
		'availableCategories',
		'selectedCategories'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'instance creation' }
FontAwesomeImportMenuElement class >> menuActionIconFor: anIconLibraryClass [
	^ BrGlamorousVectorIcons add
]

{ #category : 'instance creation' }
FontAwesomeImportMenuElement class >> menuContentFor: anIconLibraryClass button: aButton menuModel: anExplicitMenu [
	| menuElement |
	menuElement := self new
		iconLibraryClass: anIconLibraryClass;
		menuModel: anExplicitMenu;
		initializeContent;
		yourself.

	^ menuElement
		background: aButton theme default contentBackground;
		addAptitude: (BrGlamorousPopoverPinnableAptitude new
				withAllPinActions;
				menuModel: anExplicitMenu);
		yourself
]

{ #category : 'private' }
FontAwesomeImportMenuElement class >> menuItemGroup [
	^ BrMenuItemGroupConfiguration new
		name: 'Font Awesome';
		priority: 43;
		yourself
]

{ #category : 'private' }
FontAwesomeImportMenuElement class >> shouldShowActionFor: anIconLibraryClass [
	^ anIconLibraryClass styleName isNil
]

{ #category : 'private - actions' }
FontAwesomeImportMenuElement >> clearCategories [
	selectedCategories := OrderedCollection new.
	self refreshCategoryList
]

{ #category : 'private - actions' }
FontAwesomeImportMenuElement >> clearStyles [
	selectedStyles := OrderedCollection new.
	self refreshStyleList
]

{ #category : 'private - accessing' }
FontAwesomeImportMenuElement >> familyNameString [
	^ familyNameEditor text asString trimBoth
]

{ #category : 'accessing' }
FontAwesomeImportMenuElement >> iconLibraryClass: aClass [
	iconLibraryClass := aClass
]

{ #category : 'private - actions' }
FontAwesomeImportMenuElement >> importSelectedIcons [
	| metadataFile packageName familyName version selectedCategoryNames importedCount |
	metadataFile := self metadataFileReference.
	metadataFile ifNil: [ ^ self updateStatus: 'Choose a valid metadata/icons.json file.' ].
	packageName := self packageNameString.
	packageName isEmpty ifTrue: [ ^ self updateStatus: 'Package name is required.' ].
	selectedStyles isEmpty ifTrue: [ ^ self updateStatus: 'Choose at least one style to import.' ].
	familyName := self familyNameString ifEmpty: [ 'Font Awesome Pro' ].
	version := self resolvedVersionFor: metadataFile.
	version ifNil: [ ^ self ].
	selectedCategoryNames := self selectedCategoryNamesForImport.

	[ FontAwesomeMetadataImporter
		importFromIconsJsonFile: metadataFile
		packageName: packageName
		familyName: familyName
		version: version
		selectedStyleNames: selectedStyles asArray
		selectedCategoryNames: selectedCategoryNames ]
		on: Error
		do: [ :anError | ^ self updateStatus: anError messageText ].

	importedCount := iconLibraryClass metadata allIconMetadata size.
	self updateStatus: 'Imported ', importedCount asString, ' icons.'.
	menuModel
		ifNil: [ self fireEvent: BrContextMenuHideWish new ]
		ifNotNil: [ menuModel hideAll ]
]

{ #category : 'initialization' }
FontAwesomeImportMenuElement >> initialize [
	super initialize.
	availableStyles := #().
	selectedStyles := OrderedCollection new.
	availableCategories := #().
	selectedCategories := OrderedCollection new.
]

{ #category : 'initialization' }
FontAwesomeImportMenuElement >> initializeContent [
	self
		layout: BlLinearLayout vertical;
		padding: (BlInsets all: 8);
		cellSpacing: 8;
		constraintsDo: [ :c |
			c horizontal exact: 520.
			c vertical fitContent ].

	metadataPathEditor := self newTextEditorWith: ''.
	packageNameEditor := self newTextEditorWith: 'BVC-FontAwesome-Fonts'.
	familyNameEditor := self newTextEditorWith: 'Font Awesome Pro'.
	versionEditor := self newTextEditorWith: ''.
	stylesList := self newSelectionList.
	categoriesList := self newSelectionList.
	statusLabel := BrLabel new
		aptitude: BrLabelAptitude new;
		opacity: 0.7;
		text: 'Enter the path to metadata/icons.json and load import options.';
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	self addChildren: {
		self newDescriptionElement.
		(self newFieldRowLabel: 'icons.json' editor: metadataPathEditor).
		(self newFieldRowLabel: 'Package' editor: packageNameEditor).
		(self newFieldRowLabel: 'Family' editor: familyNameEditor).
		(self newFieldRowLabel: 'Version' editor: versionEditor).
		self newPrimaryButtonsRow.
		(self newSectionHeaderLabel: 'Styles' actionRow: self newStylesActionRow).
		stylesList.
		(self newSectionHeaderLabel: 'Categories' actionRow: self newCategoriesActionRow).
		categoriesList.
		statusLabel }.

	self refreshStyleList.
	self refreshCategoryList
]

{ #category : 'private - actions' }
FontAwesomeImportMenuElement >> loadImportOptions [
	| metadataFile options inferredVersion |
	metadataFile := self metadataFileReference.
	metadataFile ifNil: [ ^ self updateStatus: 'Choose a valid metadata/icons.json file.' ].

	options := [ FontAwesomeMetadataImporter importOptionsFromIconsJsonFile: metadataFile ]
		on: Error
		do: [ :anError | ^ self updateStatus: anError messageText ].

	availableStyles := options at: #styles ifAbsent: [ #() ].
	selectedStyles := availableStyles asOrderedCollection.
	availableCategories := options at: #categories ifAbsent: [ #() ].
	selectedCategories := availableCategories asOrderedCollection.
	inferredVersion := options at: #version ifAbsent: [ '' ].
	(self versionString isEmpty and: [ inferredVersion notEmpty ])
		ifTrue: [ versionEditor text: inferredVersion ].

	self
		refreshStyleList;
		refreshCategoryList;
		updateStatus: 'Loaded ', availableStyles size asString, ' styles and ', availableCategories size asString, ' categories.'
]

{ #category : 'accessing' }
FontAwesomeImportMenuElement >> menuModel: aMenuModel [
	menuModel := aMenuModel
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> metadataFileReference [
	| path |
	path := self metadataPathString.
	path isEmpty ifTrue: [ ^ nil ].
	^ [ | fileReference |
	fileReference := path asFileReference.
		(fileReference exists and: [ fileReference isFile ])
			ifTrue: [ fileReference ]
			ifFalse: [ nil ] ]
		on: Error
		do: [ :anError | nil ]
]

{ #category : 'private - accessing' }
FontAwesomeImportMenuElement >> metadataPathString [
	^ metadataPathEditor text asString trimBoth
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newActionButtonLabel: aString action: aBlock [
	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude new;
		label: aString;
		action: [ :aButton | aBlock value ];
		yourself
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newCategoriesActionRow [
	^ BrHorizontalPane new
		cellSpacing: 4;
		fitContent;
		addChildren: {
			(self newActionButtonLabel: 'All' action: [ self selectAllCategories ]).
			(self newActionButtonLabel: 'None' action: [ self clearCategories ]) };
		yourself
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newCategoryRowFor: aCategoryName [
	^ self
		newSelectableRowLabel: aCategoryName
		selected: (selectedCategories includes: aCategoryName)
		onChecked: [ (selectedCategories includes: aCategoryName) ifFalse: [ selectedCategories add: aCategoryName ] ]
		onUnchecked: [ selectedCategories remove: aCategoryName ifAbsent: [ ] ]
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newDescriptionElement [
	^ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude + BrGlamorousTextAreaSpacingAptitude;
		beReadOnlyWithoutSelection;
		background: Color transparent;
		border: BlBorder empty;
		padding: BlInsets empty;
		margin: BlInsets empty;
		text: 'Import icons from metadata/icons.json in your licensed Font Awesome download. Choose the styles to generate and optionally narrow the import to selected categories.';
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newFieldRowLabel: aLabel editor: anEditor [
	| row label |
	row := BrHorizontalPane new
		cellSpacing: 8;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	label := BrLabel new
		aptitude: BrLabelAptitude new;
		opacity: 0.6;
		text: aLabel;
		constraintsDo: [ :c |
			c horizontal exact: 70.
			c vertical fitContent.
			c linear vertical alignCenter ];
		yourself.
	row addChildren: { label. anEditor }.
	^ row
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newPrimaryButtonsRow [
	^ BrHorizontalPane new
		cellSpacing: 6;
		fitContent;
		addChildren: {
			(self newActionButtonLabel: 'Load options' action: [ self loadImportOptions ]).
			(self newActionButtonLabel: 'Import' action: [ self importSelectedIcons ]) };
		yourself
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newSectionHeaderLabel: aLabel actionRow: anActionRow [
	| row label spacer |
	row := BrHorizontalPane new
		cellSpacing: 6;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	label := BrLabel new
		aptitude: BrGlamorousLabelAptitude;
		text: aLabel;
		yourself.
	spacer := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	row addChildren: { label. spacer. anActionRow }.
	^ row
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newSelectableRowLabel: aLabel selected: aBoolean onChecked: checkedBlock onUnchecked: uncheckedBlock [
	| checkbox row label |
	row := BrHorizontalPane new
		cellSpacing: 6;
		padding: (BlInsets top: 2 bottom: 2);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	checkbox := BrCheckbox new
		fitContent;
		aptitude: BrGlamorousCheckboxAptitude;
		checked: aBoolean;
		yourself.
	checkbox
		whenCheckedDo: [ checkedBlock value ];
		whenUncheckedDo: [ uncheckedBlock value ].
	label := BrLabel new
		aptitude: BrLabelAptitude new;
		text: aLabel;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent.
			c linear vertical alignCenter ];
		yourself.
	row addChildren: { checkbox. label }.
	^ row
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newSelectionList [
	^ BrSimpleList new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical exact: 120 ];
		yourself
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newStyleRowFor: aStyleName [
	^ self
		newSelectableRowLabel: aStyleName capitalized
		selected: (selectedStyles includes: aStyleName)
		onChecked: [ (selectedStyles includes: aStyleName) ifFalse: [ selectedStyles add: aStyleName ] ]
		onUnchecked: [ selectedStyles remove: aStyleName ifAbsent: [ ] ]
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newStylesActionRow [
	^ BrHorizontalPane new
		cellSpacing: 4;
		fitContent;
		addChildren: {
			(self newActionButtonLabel: 'All' action: [ self selectAllStyles ]).
			(self newActionButtonLabel: 'None' action: [ self clearStyles ]) };
		yourself
]

{ #category : 'private - instance creation' }
FontAwesomeImportMenuElement >> newTextEditorWith: aString [
	^ BrEditor new
		aptitude: BrEditorAptitude new;
		text: aString;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent.
			c linear weight: 1 ];
		yourself
]

{ #category : 'private - accessing' }
FontAwesomeImportMenuElement >> packageNameString [
	^ packageNameEditor text asString trimBoth
]

{ #category : 'private - updating' }
FontAwesomeImportMenuElement >> refreshCategoryList [
	categoriesList
		stencil: [ :eachCategoryName :anIndex :aList |
			self newCategoryRowFor: eachCategoryName ];
		items: availableCategories.
	categoriesList constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: (availableCategories isEmpty ifTrue: [ 32 ] ifFalse: [ 160 ]) ]
]

{ #category : 'private - updating' }
FontAwesomeImportMenuElement >> refreshStyleList [
	stylesList
		stencil: [ :eachStyleName :anIndex :aList |
			self newStyleRowFor: eachStyleName ];
		items: availableStyles.
	stylesList constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: (availableStyles isEmpty ifTrue: [ 32 ] ifFalse: [ 110 ]) ]
]

{ #category : 'private - accessing' }
FontAwesomeImportMenuElement >> resolvedVersionFor: aMetadataFile [
	| version |
	version := self versionString.
	version notEmpty ifTrue: [ ^ version ].
	^ [ FontAwesomeMetadataImporter requiredVersionForIconsJsonFile: aMetadataFile ]
		on: Error
		do: [ :anError |
			self updateStatus: anError messageText.
			nil ]
]

{ #category : 'private - actions' }
FontAwesomeImportMenuElement >> selectAllCategories [
	selectedCategories := availableCategories asOrderedCollection.
	self refreshCategoryList
]

{ #category : 'private - actions' }
FontAwesomeImportMenuElement >> selectAllStyles [
	selectedStyles := availableStyles asOrderedCollection.
	self refreshStyleList
]

{ #category : 'private - accessing' }
FontAwesomeImportMenuElement >> selectedCategoryNamesForImport [
	availableCategories isEmpty ifTrue: [ ^ nil ].
	selectedCategories size = availableCategories size ifTrue: [ ^ nil ].
	^ selectedCategories asArray
]

{ #category : 'private - updating' }
FontAwesomeImportMenuElement >> updateStatus: aString [
	statusLabel text: aString
]

{ #category : 'private - accessing' }
FontAwesomeImportMenuElement >> versionString [
	^ versionEditor text asString trimBoth
]
