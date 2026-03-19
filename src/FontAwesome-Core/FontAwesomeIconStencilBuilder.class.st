"
I am a stencil builder that creates the default UI for a model described through a {{gtClass:FontAwesomeIconDescription}}.

## Responsibilities
- I connect Magritte model rendering to the specialized Font Awesome icon UI.
- I centralize default widget creation for icon-oriented model presentations.

I am part of the Magritte integration layer and am usually not used directly.
"
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
