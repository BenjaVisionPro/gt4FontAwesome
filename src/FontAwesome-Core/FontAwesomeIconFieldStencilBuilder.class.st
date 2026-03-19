"
I am a stencil builder that creates the default Magritte field element for a {{gtClass:FontAwesomeIconDescription}}.

## Responsibilities
- I bridge the description object to the concrete field element shown in a form.
- I centralize how Font Awesome icon fields are instantiated in Magritte-based UIs.

I am usually used indirectly through the Magritte building pipeline.
"
Class {
	#name : 'FontAwesomeIconFieldStencilBuilder',
	#superclass : 'GtMagritteDescriptionElementStencilBuilder',
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'api - instantiation' }
FontAwesomeIconFieldStencilBuilder >> buildDefault [
	^ FontAwesomeIconFieldElement new
		fieldViewModel: (GtMagritteFieldViewModel new
				memento: self memento;
				description: self description;
				yourself);
		yourself
]
