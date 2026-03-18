Class {
	#name : 'FontAwesomeIconStencilBuilder',
	#superclass : 'GtMagritteModelStencilBuilder',
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'api - instantiation' }
FontAwesomeIconStencilBuilder >> buildDefault [
	^ self model
		ifNil: [ FontAwesomeBuilderUtility newChooseIconAffordanceFor: self description ]
		ifNotNil: [ FontAwesomeBuilderUtility newFontAwesomeIconFor: self model using: self description ]
]
