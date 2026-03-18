Class {
	#name : 'FontAwesomeIconFieldElement',
	#superclass : 'BrFrame',
	#traits : 'TGtMagritteWithFieldViewModel',
	#classTraits : 'TGtMagritteWithFieldViewModel classTrait',
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'private' }
FontAwesomeIconFieldElement >> currentValue [
	self fieldViewModel ifNil: [ ^ nil ].
	self observableValue
		ifSome: [ :aValue | ^ aValue currentValue ].
	^ nil
]

{ #category : 'private' }
FontAwesomeIconFieldElement >> iconElementForValue: aValue [
	self fieldViewModel ifNil: [ ^ self newPlaceholderElement ].
	^ aValue
		ifNil: [ FontAwesomeBuilderUtility newChooseIconAffordanceFor: self description ]
		ifNotNil: [ FontAwesomeBuilderUtility newFontAwesomeIconFor: aValue using: self description ]
]

{ #category : 'initialization' }
FontAwesomeIconFieldElement >> initialize [
	super initialize.
	self
		beFocusable;
		fitContent;
		padding: (BlInsets all: 2).

	self
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude
				handle: [ self newDropdownHandleElement ]
				content: [ self newDropdownContentElement ]).

	self
		withAsyncSinkDo: [ :anElementSink |
			anElementSink
				sink: AsyncPeekSink new;
				whenUpdate: [ :aContainer :aSink |
					self updateDisplayedIconFor: aSink value currentValue in: aContainer ] ]
]

{ #category : 'private' }
FontAwesomeIconFieldElement >> newDropdownContentElement [
	self fieldViewModel ifNil: [ ^ self newPlaceholderElement ].
	^ FontAwesomeIconSelectorElement new
		fieldViewModel: self fieldViewModel;
		dropdownAnchor: self;
		constraintsDo: [ :c |
			c horizontal exact: self description selectorExtent x.
			c vertical exact: self description selectorExtent y ];
		yourself
]

{ #category : 'private' }
FontAwesomeIconFieldElement >> newDropdownHandleElement [
	^ BrFrame new
		fitContent;
		padding: (BlInsets all: 2);
		constraintsDo: [ :c |
			c grid vertical alignCenter.
			c grid horizontal alignLeft ];
			addChild: (self iconElementForValue: self currentValue);
			yourself
]

{ #category : 'private' }
FontAwesomeIconFieldElement >> newPlaceholderElement [
	^ BrLabel new
		aptitude: BrLabelAptitude new;
		text: '';
		fitContent;
		yourself
]

{ #category : 'api - field view model' }
FontAwesomeIconFieldElement >> onFieldViewModelChanged [
	self inUIProcessDo: [
		self updateDisplayedIcon ]
]

{ #category : 'api - field view model' }
FontAwesomeIconFieldElement >> onPostFieldViewModelChanged [
	self withAsyncSinkDo: [ :anElementSink |
		self observableValue observe: anElementSink ]
]

{ #category : 'private' }
FontAwesomeIconFieldElement >> updateDisplayedIcon [
	self updateDisplayedIconFor: self currentValue in: self
]

{ #category : 'private' }
FontAwesomeIconFieldElement >> updateDisplayedIconFor: aValue in: aContainer [
	aContainer
		removeChildren;
		addChild: (self iconElementForValue: aValue)
]
