Class {
	#name : 'CFFontAwesomeIconMetadata',
	#superclass : 'Object',
	#instVars : [
		'selectorSymbol',
		'fontAwesomeName',
		'label',
		'searchTerms',
		'styles',
		'categories',
		'iconLibraryClass'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> categories [
	^ categories
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> categories: aCollection [
	categories := aCollection asArray
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> fontAwesomeName [
	^ fontAwesomeName
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> fontAwesomeName: aString [
	fontAwesomeName := aString
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [ {
			{'Selector'. self selectorSymbol asString}.
			{'Font Awesome Name'. self fontAwesomeName ifNil: [ '' ]}.
			{'Title'. self label ifNil: [ '' ]}.
			{'Styles'. ' , ' join: self styles}.
			{'Categories'. ' , ' join: self categories} } ];
		column: 'Field' text: [ :each | each first ];
		column: 'Value' text: [ :each | each second ]
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> gtDisplayText [
	^ self label ifNil: [ self selectorSymbol asString ]
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 0;
		stencil: [ | icon |
			icon := self iconLibraryClass
				icon: self selectorSymbol
				styleName: self preferredStyleName.
			icon color: Color black.
			GtInspectorElementLiveViewContainer new
				element: (icon asScalableElementSized: (icon extentForHeight: 64));
				clipChildren: false ]
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewDetailRowLabel: aLabel content: aContentElement [
	| row keyLabel valueLabel |
	row := BrHorizontalPane new
		cellSpacing: 8;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	keyLabel := BrLabel new
		aptitude: BrLabelAptitude new;
		text: aLabel;
		opacity: 0.6;
		constraintsDo: [ :c |
			c horizontal exact: 92.
			c vertical fitContent ];
		yourself.

	valueLabel := aContentElement.

	row addChildren: { keyLabel. valueLabel }.
	^ row
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewDetailRowLabel: aLabel value: aValue [
	^ self
		gtSpotterPreviewDetailRowLabel: aLabel
		content: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aValue;
				constraintsDo: [ :c |
					c horizontal matchParent.
					c vertical fitContent ];
				yourself)
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewElement [
	| currentStyleName root styleToggleGroup samplesContainer details |
	currentStyleName := self preferredStyleName.
	root := BrVerticalPane new
		cellSpacing: 4;
		padding: (BlInsets all: 2);
		border: (BlBorder paint: Color cyan);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	samplesContainer := BrFrame new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent];
		border: (BlBorder paint: Color green);
		yourself.
	samplesContainer addChild: (self gtSpotterPreviewSamplesForStyleName: currentStyleName).

	styleToggleGroup := self
		gtSpotterPreviewStyleToggleGroupForSelectedStyle: currentStyleName
		whenActivated: [ :aStyleName |
			currentStyleName := aStyleName.
			samplesContainer removeChildren.
			samplesContainer addChild: (self gtSpotterPreviewSamplesForStyleName: currentStyleName) ].

	details := BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	details addChildren: {
		(self gtSpotterPreviewDetailRowLabel: 'Selector' value: self selectorSymbol asString).
		(self gtSpotterPreviewDetailRowLabel: 'FA name' value: (self fontAwesomeName ifNil: [ '' ])).
		(self gtSpotterPreviewDetailRowLabel: 'Categories' value: (' , ' join: self categories)).
		(self gtSpotterPreviewDetailRowLabel: 'Search' value: (' , ' join: (self searchTerms collect: #asString))) }.

	root addChildren: { styleToggleGroup. samplesContainer. details }.
	^ root
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewSampleForHeight: aHeight styleName: aStyleName [
	^ (CFMaFontAwesomeBuilderUtility
		newFontAwesomeIconForMetadata: self
		styleName: aStyleName
		fitInto: aHeight @ aHeight)
			constraintsDo: [ :c | c linear vertical alignBottom ]
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewSamplesForStyleName: aStyleName [
	| samplesRow rightColumn smallRow mediumSample |
	samplesRow := BrHorizontalPane new
		cellSpacing: 4;
		fitContent;
		yourself.

	rightColumn := BrVerticalPane new
		cellSpacing: 4;
		fitContent;
		yourself.

	smallRow := BrHorizontalPane new
		cellSpacing: 4;
		fitContent;
		yourself.
	smallRow addChildren: {
		(self gtSpotterPreviewSampleForHeight: 24 styleName: aStyleName).
		(self gtSpotterPreviewSampleForHeight: 16 styleName: aStyleName) }.
	smallRow children do: [ :each |
		each constraintsDo: [ :c | c linear vertical alignBottom ] ].

	mediumSample := self gtSpotterPreviewSampleForHeight: 48 styleName: aStyleName.
	mediumSample constraintsDo: [ :c |
		c linear horizontal alignCenter ].

	rightColumn addChildren: {
		smallRow.
		mediumSample }.

	samplesRow addChildren: {
		(self gtSpotterPreviewSampleForHeight: 96 styleName: aStyleName).
		rightColumn }.
	(samplesRow children first) constraintsDo: [ :c | c linear vertical alignBottom ].
	(samplesRow children second) constraintsDo: [ :c | c linear vertical alignBottom ].
	^ samplesRow
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewStyleToggleFor: aStyleName selectedStyleName: aSelectedStyleName whenActivated: aBlock [
	| toggle |
	toggle := BrToggle new
		aptitude: BrGlamorousToggleWithIconAptitude new;
		icon: (CFMaFontAwesomeBuilderUtility
				newFontAwesomeIconForMetadata: self
				styleName: aStyleName
				fitInto: 14 @ 14);
		label: aStyleName capitalized;
		when: BrToggleActivatedEvent
			do: [ :anEvent | aBlock value: anEvent model ];
		yourself.
	toggle viewModel model: aStyleName.
	aStyleName = aSelectedStyleName ifTrue: [ toggle activate ].
	^ toggle
]

{ #category : 'gt extensions' }
CFFontAwesomeIconMetadata >> gtSpotterPreviewStyleToggleGroupForSelectedStyle: aStyleName whenActivated: aBlock [
	| toggleGroup |
	toggleGroup := BrToggleGroup new
		aptitude: BrGlamorousToggleGroupAptitude new;
		yourself.
	self styles do: [ :eachStyleName |
		toggleGroup addToggle: (self
			gtSpotterPreviewStyleToggleFor: eachStyleName
			selectedStyleName: aStyleName
			whenActivated: aBlock) ].
	^ toggleGroup
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> iconLibraryClass [
	^ iconLibraryClass ifNil: [ CFFontAwesomeIcons ]
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> iconLibraryClass: aClass [
	iconLibraryClass := aClass
]

{ #category : 'initialization' }
CFFontAwesomeIconMetadata >> initialize [
	super initialize.
	searchTerms := #().
	styles := #().
	categories := #()
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> label [
	^ label
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> label: aString [
	label := aString
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> matchesAllSearchTerms: aCollection [
	| lowered |
	lowered := self searchableStrings collect: [ :each | each asLowercase ].
	^ aCollection allSatisfy: [ :term |
		lowered anySatisfy: [ :each | each includesSubstring: term ] ]
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> matchesSearchText: aString [
	^ self matchesAllSearchTerms: { aString asLowercase }
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> preferredStyleName [
	(styles includes: self iconLibraryClass defaultStyleName) ifTrue: [
		^ self iconLibraryClass defaultStyleName ].
	(styles includes: 'regular') ifTrue: [ ^ 'regular' ].
	styles isEmpty ifTrue: [ ^ self iconLibraryClass defaultStyleName ].
	^ styles first
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> scoreForSearchTerms: aCollection [
	| selector name title score |
	selector := self selectorSymbol asString asLowercase.
	name := (self fontAwesomeName ifNil: [ '' ]) asLowercase.
	title := (self label ifNil: [ '' ]) asLowercase.
	score := 0.
	aCollection do: [ :term |
		selector = term ifTrue: [ score := score + 1000 ].
		(selector beginsWith: term) ifTrue: [ score := score + 300 ].
		(title beginsWith: term) ifTrue: [ score := score + 200 ].
		((selector includesSubstring: term)
			or: [ (name includesSubstring: term)
				or: [ title includesSubstring: term ] ])
			ifTrue: [ score := score + 50 ].
		(self searchTerms anySatisfy: [ :each | each asString asLowercase includesSubstring: term ])
			ifTrue: [ score := score + 20 ].
		(self categories anySatisfy: [ :each | each asString asLowercase includesSubstring: term ])
			ifTrue: [ score := score + 10 ] ].
	^ score
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> searchTerms [
	^ searchTerms
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> searchTerms: aCollection [
	searchTerms := aCollection asArray
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> searchableStrings [
	^ ({ self selectorSymbol asString.
		self fontAwesomeName ifNil: [ '' ].
		self label ifNil: [ '' ] }
		, self searchTerms
		, self categories)
		collect: [ :each | each asString ]
]

{ #category : 'searching' }
CFFontAwesomeIconMetadata >> searchableText [
	^ ' ' join: self searchableStrings
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> selectorSymbol [
	^ selectorSymbol
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> selectorSymbol: aSymbol [
	selectorSymbol := aSymbol
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> styles [
	^ styles
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> styles: aCollection [
	styles := aCollection asArray
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadata >> supportsStyleNamed: aStyleName [
	^ styles includes: aStyleName
]
