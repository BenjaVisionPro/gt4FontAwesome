"
I represent a configurable Font Awesome import session.

## Responsibilities
- I manage the source metadata file, import target package, family name, version, and base icon library class.
- I load and expose the available styles, categories, and icons from the source metadata.
- I manage the selected styles, categories, and icons that should be imported.
- I provide Magritte descriptions so I can be configured and inspected through GT tools.
- I announce meaningful changes so UI descriptions and views can refresh.
- I execute the import once the configuration is complete.

I am intended to replace the older class-side importer workflow with an inspectable object-centered workflow.

## Intended usage
```smalltalk
FontAwesomeImporter new
	iconsFileReference: aFileReference;
	packageName: 'FontAwesome-Core';
	familyName: 'Font Awesome Pro';
	version: '6.5.1';
	load;
	selectedStyles: #(light regular);
	selectedCategories: #(business communication);
	selectedIcons: #(addressCard envelope);
	import
```
"
Class {
	#name : 'FontAwesomeImporter',
	#superclass : 'Object',
	#instVars : [
		'iconsFileReference',
		'packageName',
		'familyName',
		'version',
		'baseClass',
		'rawMetadata',
		'categoryMap',
		'availableStyles',
		'selectedStyles',
		'availableCategories',
		'selectedCategories',
		'availableIcons',
		'selectedIcons',
		'announcer',
		'lastImportResult',
		'statusMessage'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'accessing' }
FontAwesomeImporter >> announcer [
	^ announcer
]

{ #category : 'accessing' }
FontAwesomeImporter >> announcer: anAnnouncer [
	announcer := anAnnouncer
]

{ #category : 'accessing' }
FontAwesomeImporter >> availableCategories [
	^ availableCategories
]

{ #category : 'accessing' }
FontAwesomeImporter >> availableCategories: aCollection [
	availableCategories := aCollection.
	self announcer announce: FontAwesomeImporterOptionsChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> availableCategoriesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Available categories';
		comment: 'The icon categories discovered in the selected icons file.';
		accessor: #availableCategories;
		priority: 80;
		beReadOnly;
		beDefinitive;
		updateOn: FontAwesomeImporterOptionsChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'private - loading' }
FontAwesomeImporter >> availableIconNamesFromRawMetadata: someRawMetadata [
	^ someRawMetadata keys asSortedCollection asArray
]

{ #category : 'accessing' }
FontAwesomeImporter >> availableIcons [
	^ availableIcons
]

{ #category : 'accessing' }
FontAwesomeImporter >> availableIcons: aCollection [
	availableIcons := aCollection.
	self announcer announce: FontAwesomeImporterOptionsChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> availableIconsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Available icons';
		comment: 'The icon names or metadata entries discovered in the selected icons file.';
		accessor: #availableIcons;
		priority: 100;
		beReadOnly;
		beDefinitive;
		updateOn: FontAwesomeImporterOptionsChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> availableStyles [
	^ availableStyles
]

{ #category : 'accessing' }
FontAwesomeImporter >> availableStyles: aCollection [
	availableStyles := aCollection.
	self announcer announce: FontAwesomeImporterOptionsChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> availableStylesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Available styles';
		comment: 'The styles discovered in the selected icons file.';
		accessor: #availableStyles;
		priority: 60;
		beReadOnly;
		beDefinitive;
		updateOn: FontAwesomeImporterOptionsChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> baseClass [
	^ baseClass
]

{ #category : 'accessing' }
FontAwesomeImporter >> baseClass: aClass [
	baseClass := aClass
]

{ #category : 'magritte' }
FontAwesomeImporter >> baseClassDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		label: 'Base class';
		comment: 'The icon library base class under which imported style classes will be created.';
		accessor: #baseClass;
		options: { FontAwesomeIcons };
		priority: 50;
		beRequired;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> categoryMap [
	^ categoryMap
]

{ #category : 'accessing' }
FontAwesomeImporter >> categoryMap: anObject [
	categoryMap := anObject.
	self announcer announce: FontAwesomeImporterSourceChangedAnnouncement new
]

{ #category : 'private - loading' }
FontAwesomeImporter >> categoryNamesFromCategoryMap: aCategoryMap [
	| categoryNames |
	categoryNames := OrderedCollection new.
	aCategoryMap valuesDo: [ :eachCategories |
		eachCategories do: [ :eachCategory |
			(categoryNames includes: eachCategory) ifFalse: [ categoryNames add: eachCategory ] ] ].
	^ categoryNames asSortedCollection asArray
]

{ #category : 'accessing' }
FontAwesomeImporter >> familyName [
	^ familyName
]

{ #category : 'accessing' }
FontAwesomeImporter >> familyName: aString [
	familyName := aString
]

{ #category : 'magritte' }
FontAwesomeImporter >> familyNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Family name';
		comment: 'The Font Awesome family name recorded in imported metadata.';
		accessor: #familyName;
		priority: 30;
		beRequired;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> iconsFileReference [
	^ iconsFileReference
]

{ #category : 'accessing' }
FontAwesomeImporter >> iconsFileReference: aFileReference [
	iconsFileReference := aFileReference.
	self announcer announce: FontAwesomeImporterSourceChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> iconsFileReferenceDescription [
	<magritteDescription>
	^ MAFileDescription new
		label: 'Icons file';
		comment: 'The Font Awesome metadata/icons.json file to load and import from.';
		accessor: #iconsFileReference;
		priority: 10;
		beRequired;
		updateOn: FontAwesomeImporterSourceChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'private - loading' }
FontAwesomeImporter >> inferredVersionForIconsJsonFile: aFileReference [
	^ FontAwesomeMetadataImporter inferredVersionForIconsJsonFile: aFileReference
]

{ #category : 'initialization' }
FontAwesomeImporter >> initialize [
	super initialize.
	packageName := 'FontAwesome-Icons'.
	familyName := 'Font Awesome Pro'.
	iconsFileReference := '/Users/jupiter/Downloads/fontawesome-pro-5.15.4-desktop/metadata/icons.json' asFileReference.
	baseClass := FontAwesomeIcons.
	availableStyles := #().
	selectedStyles := OrderedCollection new.
	availableCategories := #().
	selectedCategories := OrderedCollection new.
	availableIcons := #().
	selectedIcons := OrderedCollection new.
	announcer := Announcer new.
	statusMessage := ''
]

{ #category : 'accessing' }
FontAwesomeImporter >> lastImportResult [
	^ lastImportResult
]

{ #category : 'accessing' }
FontAwesomeImporter >> lastImportResult: anObject [
	lastImportResult := anObject
]

{ #category : 'loading' }
FontAwesomeImporter >> load [
	| loadedMetadata loadedCategoryMap inferredVersion |
	iconsFileReference ifNil: [
		self statusMessage: 'Choose a valid metadata/icons.json file.'.
		^ self ].

	loadedMetadata := self readMetadataFrom: iconsFileReference.
	loadedCategoryMap := self readCategoryMapFromIconsJsonFile: iconsFileReference.
	inferredVersion := self inferredVersionForIconsJsonFile: iconsFileReference.

	self rawMetadata: loadedMetadata.
	self categoryMap: loadedCategoryMap.
	self availableStyles: (self styleNamesFromRawMetadata: loadedMetadata).
	self availableCategories: (self categoryNamesFromCategoryMap: loadedCategoryMap).
	self availableIcons: (self availableIconNamesFromRawMetadata: loadedMetadata).

	selectedStyles isEmpty ifTrue: [ self selectedStyles: self availableStyles ].
	(selectedCategories isEmpty and: [ self availableCategories notEmpty ]) ifTrue: [ self selectedCategories: #() ].
	(selectedIcons isEmpty and: [ self availableIcons notEmpty ]) ifTrue: [ self selectedIcons: #() ].
	(version isNil or: [ version isEmpty ])
		ifTrue: [ version := inferredVersion ifNil: [ '' ] ].

	self statusMessage: 'Loaded ', self availableStyles size asString, ' styles, ', self availableCategories size asString, ' categories, and ', self availableIcons size asString, ' icons.'.
	^ self
]

{ #category : 'accessing' }
FontAwesomeImporter >> packageName [
	^ packageName
]

{ #category : 'accessing' }
FontAwesomeImporter >> packageName: aString [
	packageName := aString
]

{ #category : 'magritte' }
FontAwesomeImporter >> packageNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Package name';
		comment: 'The package in which generated icon library classes and methods will be compiled.';
		accessor: #packageName;
		priority: 20;
		beRequired;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> rawMetadata [
	^ rawMetadata
]

{ #category : 'accessing' }
FontAwesomeImporter >> rawMetadata: anObject [
	rawMetadata := anObject.
	self announcer announce: FontAwesomeImporterSourceChangedAnnouncement new
]

{ #category : 'private - loading' }
FontAwesomeImporter >> readCategoryMapFromIconsJsonFile: aFileReference [
	| categoriesFile |
	categoriesFile := aFileReference parent / 'categories.yml'.
	(categoriesFile exists and: [ categoriesFile isFile ])
		ifFalse: [ ^ Dictionary new ].
	^ FontAwesomeMetadataImporter readCategoryMapFromYamlFile: categoriesFile
]

{ #category : 'private - loading' }
FontAwesomeImporter >> readMetadataFrom: aFileReference [
	^ NeoJSONReader fromString: aFileReference contents
]

{ #category : 'accessing' }
FontAwesomeImporter >> selectedCategories [
	^ selectedCategories
]

{ #category : 'accessing' }
FontAwesomeImporter >> selectedCategories: aCollection [
	selectedCategories := aCollection asOrderedCollection.
	self announcer announce: FontAwesomeImporterSelectionChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> selectedCategoriesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Selected categories';
		comment: 'The categories that should be imported. An empty selection can later be treated as all categories.';
		accessor: #selectedCategories;
		priority: 90;
		beOrdered;
		updateOn: FontAwesomeImporterSelectionChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> selectedIcons [
	^ selectedIcons
]

{ #category : 'accessing' }
FontAwesomeImporter >> selectedIcons: aCollection [
	selectedIcons := aCollection asOrderedCollection.
	self announcer announce: FontAwesomeImporterSelectionChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> selectedIconsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Selected icons';
		comment: 'The icons that should be imported. An empty selection can later be treated as all matching icons.';
		accessor: #selectedIcons;
		priority: 110;
		beOrdered;
		updateOn: FontAwesomeImporterSelectionChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> selectedStyles [
	^ selectedStyles
]

{ #category : 'accessing' }
FontAwesomeImporter >> selectedStyles: aCollection [
	selectedStyles := aCollection asOrderedCollection.
	self announcer announce: FontAwesomeImporterSelectionChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> selectedStylesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Selected styles';
		comment: 'The styles that should be imported. An empty selection can later be treated as all styles.';
		accessor: #selectedStyles;
		priority: 70;
		beOrdered;
		updateOn: FontAwesomeImporterSelectionChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> statusMessage [
	^ statusMessage
]

{ #category : 'accessing' }
FontAwesomeImporter >> statusMessage: aString [
	statusMessage := aString.
	self announcer announce: FontAwesomeImporterStatusChangedAnnouncement new
]

{ #category : 'magritte' }
FontAwesomeImporter >> statusMessageDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Status';
		comment: 'The current importer status message.';
		accessor: #statusMessage;
		priority: 120;
		beReadOnly;
		updateOn: FontAwesomeImporterStatusChangedAnnouncement from: announcer;
		yourself
]

{ #category : 'private - loading' }
FontAwesomeImporter >> styleNamesFromRawMetadata: someRawMetadata [
	| styleNames |
	styleNames := OrderedCollection new.
	someRawMetadata valuesDo: [ :iconData |
		(iconData at: 'styles' ifAbsent: [ #() ]) do: [ :eachStyleName |
			(styleNames includes: eachStyleName) ifFalse: [ styleNames add: eachStyleName ] ] ].
	^ styleNames asSortedCollection asArray
]

{ #category : 'accessing' }
FontAwesomeImporter >> unsubscribe: anObject [
	^ self announcer unsubscribe: anObject
]

{ #category : 'accessing' }
FontAwesomeImporter >> version [
	^ version
]

{ #category : 'accessing' }
FontAwesomeImporter >> version: aString [
	version := aString
]

{ #category : 'magritte' }
FontAwesomeImporter >> versionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Version';
		comment: 'The Font Awesome version recorded in imported metadata.';
		accessor: #version;
		priority: 40;
		beRequired;
		yourself
]

{ #category : 'accessing' }
FontAwesomeImporter >> when: anAnnouncementClass send: aSelector to: anObject [
	^ self announcer when: anAnnouncementClass send: aSelector to: anObject
]
