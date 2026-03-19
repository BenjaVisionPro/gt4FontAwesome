"
I am a preview element that presents the details and style variants of one icon metadata entry.

## Responsibilities
- I show a richer preview section for one icon.
- I let the user switch between available styles.
- I present key metadata such as selector, Font Awesome name, categories, and search terms.

I am commonly used as the spotter-style preview produced from {{gtClass:FontAwesomeIconMetadata}}.
"
Class {
	#name : 'FontAwesomeIconMetadataPreviewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconMetadata',
		'currentStyleName',
		'samplesContainer'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'instance creation' }
FontAwesomeIconMetadataPreviewElement class >> forMetadata: anIconMetadata [
	^ self new
		iconMetadata: anIconMetadata;
		yourself
]

{ #category : 'initialization' }
FontAwesomeIconMetadataPreviewElement >> buildPreview [
	| details previewSection styleToggleGroup |
	self removeChildren.

	currentStyleName := iconMetadata preferredStyleName.

	previewSection := BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	samplesContainer := FontAwesomeSpotterPreviewElement
		forMetadata: iconMetadata
		styleName: currentStyleName.
	samplesContainer constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

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
		(self newDetailRowLabel: 'Categories' content: (self newWrappingDetailValue: (', ' join: iconMetadata categories))).
		(self newDetailRowLabel: 'Search' content: (self newWrappingDetailValue: (', ' join: (iconMetadata searchTerms collect: #asString)))) }.

	self addChildren: { previewSection. details }
]

{ #category : 'accessing' }
FontAwesomeIconMetadataPreviewElement >> iconMetadata [
	^ iconMetadata
]

{ #category : 'accessing' }
FontAwesomeIconMetadataPreviewElement >> iconMetadata: anIconMetadata [
	iconMetadata := anIconMetadata.
	self buildPreview
]

{ #category : 'initialization' }
FontAwesomeIconMetadataPreviewElement >> initialize [
	super initialize.
	self
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 2)
]

{ #category : 'private - instance creation' }
FontAwesomeIconMetadataPreviewElement >> newDetailRowLabel: aLabel content: aContentElement [
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
			c vertical fitContent.
			c linear vertical alignTop ];
		yourself.

	row addChildren: { keyLabel. aContentElement }.
	^ row
]

{ #category : 'private - instance creation' }
FontAwesomeIconMetadataPreviewElement >> newDetailRowLabel: aLabel value: aValue [
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
FontAwesomeIconMetadataPreviewElement >> newStyleToggleFor: aStyleName [
	| toggle |
	toggle := BrToggle new
		aptitude: BrGlamorousToggleWithIconAptitude new;
		icon: (FontAwesomeBuilderUtility
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
FontAwesomeIconMetadataPreviewElement >> newStyleToggleGroup [
	| toggleGroup |
	toggleGroup := BrToggleGroup new
		aptitude: BrGlamorousToggleGroupAptitude new;
		yourself.
	iconMetadata styles do: [ :eachStyleName |
		toggleGroup addToggle: (self newStyleToggleFor: eachStyleName) ].
	^ toggleGroup
]

{ #category : 'private - instance creation' }
FontAwesomeIconMetadataPreviewElement >> newWrappingDetailValue: aValue [
	^ BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude + BrGlamorousTextAreaSpacingAptitude;
		beReadOnlyWithoutSelection;
		background: Color transparent;
		border: BlBorder empty;
		padding: BlInsets empty;
		margin: BlInsets empty;
		text: aValue;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent.
			c linear weight: 1 ]
]

{ #category : 'private - updating' }
FontAwesomeIconMetadataPreviewElement >> onStyleActivated: aStyleName [
	currentStyleName := aStyleName.
	self refreshSamples
]

{ #category : 'private - updating' }
FontAwesomeIconMetadataPreviewElement >> refreshSamples [
	samplesContainer ifNil: [ ^ self ].
	samplesContainer styleName: currentStyleName
]
