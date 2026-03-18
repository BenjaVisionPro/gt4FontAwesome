Class {
	#name : 'CFFontAwesomeIconMetadataPreviewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconMetadata',
		'currentStyleName',
		'samplesContainer'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'instance creation' }
CFFontAwesomeIconMetadataPreviewElement class >> forMetadata: anIconMetadata [
	^ self new
		iconMetadata: anIconMetadata;
		yourself
]

{ #category : 'initialization' }
CFFontAwesomeIconMetadataPreviewElement >> buildPreview [
	| details previewSection styleToggleGroup |
	self removeChildren.

	currentStyleName := iconMetadata preferredStyleName.

	previewSection := BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	samplesContainer := CFFontAwesomeGoldenPreviewElement
		forMetadata: iconMetadata
		styleName: currentStyleName.

	styleToggleGroup := self newStyleToggleGroup.
	styleToggleGroup constraintsDo: [ :c |
		c linear horizontal alignCenter ].
	previewSection addChildren: { styleToggleGroup. samplesContainer }.

	details := BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.
	details addChildren: {
		(self newDetailRowLabel: 'Selector' value: iconMetadata selectorSymbol asString).
		(self newDetailRowLabel: 'FA name' value: (iconMetadata fontAwesomeName ifNil: [ '' ])).
		(self newDetailRowLabel: 'Categories' value: (' , ' join: iconMetadata categories)).
		(self newDetailRowLabel: 'Search' value: (' , ' join: (iconMetadata searchTerms collect: #asString))) }.

	self addChildren: { previewSection. details }
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadataPreviewElement >> iconMetadata [
	^ iconMetadata
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadataPreviewElement >> iconMetadata: anIconMetadata [
	iconMetadata := anIconMetadata.
	self buildPreview
]

{ #category : 'initialization' }
CFFontAwesomeIconMetadataPreviewElement >> initialize [
	super initialize.
	self
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 2)
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newDetailRowLabel: aLabel value: aValue [
	^ self
		newDetailRowLabel: aLabel
		content: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aValue;
				constraintsDo: [ :c |
					c horizontal matchParent.
					c vertical fitContent ];
				yourself)
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newDetailRowLabel: aLabel content: aContentElement [
	| row keyLabel |
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

	row addChildren: { keyLabel. aContentElement }.
	^ row
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newStyleToggleFor: aStyleName [
	| toggle |
	toggle := BrToggle new
		aptitude: BrGlamorousToggleWithIconAptitude new;
		icon: (CFMaFontAwesomeBuilderUtility
				newFontAwesomeIconForMetadata: iconMetadata
				styleName: aStyleName
				fitInto: 14 @ 14);
		label: aStyleName capitalized;
		when: BrToggleActivatedEvent
			do: [ :anEvent | self onStyleActivated: anEvent model ];
		yourself.
	toggle viewModel model: aStyleName.
	aStyleName = currentStyleName ifTrue: [ toggle activate ].
	^ toggle
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newStyleToggleGroup [
	| toggleGroup |
	toggleGroup := BrToggleGroup new
		aptitude: BrGlamorousToggleGroupAptitude new;
		yourself.
	iconMetadata styles do: [ :eachStyleName |
		toggleGroup addToggle: (self newStyleToggleFor: eachStyleName) ].
	^ toggleGroup
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> onStyleActivated: aStyleName [
	currentStyleName := aStyleName.
	self refreshSamples
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> refreshSamples [
	samplesContainer ifNil: [ ^ self ].
	samplesContainer styleName: currentStyleName
]
