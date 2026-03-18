Extension { #name : 'GtMagritteElementBuilder' }

{ #category : '*FontAwesome-Core' }
GtMagritteElementBuilder >> visitFontAwesomeIconDescription: aDescription [
	| anElement |
	anElement := aDescription isReadOnly
		ifTrue: [ GtMagritteBuilderUtility newIconWithMemento: self memento using: aDescription ]
		ifFalse: [ FontAwesomeIconFieldStencilBuilder new
				memento: self memento;
				description: aDescription;
				asElement ].

	^ self addFieldElement: anElement using: aDescription
]
