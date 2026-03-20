"
I provide executable examples for {{gtClass:FontAwesomeImporter}}.

I build importer instances in progressively richer states so the importer can be explored and validated through examples.
"
Class {
	#name : 'FontAwesomeImporterExamples',
	#superclass : 'Object',
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'examples' }
FontAwesomeImporterExamples >> basicImporter [
	<gtExample>
	<return: #FontAwesomeImporter>
	| importer |
	importer := FontAwesomeImporter new.
	self assert: importer packageName equals: 'FontAwesome-Core'.
	self assert: importer familyName equals: 'Font Awesome Pro'.
	self assert: importer baseClass equals: FontAwesomeIcons.
	self assert: importer availableStyles isEmpty.
	self assert: importer availableCategories isEmpty.
	self assert: importer availableIcons isEmpty.
	^ importer
]

{ #category : 'examples' }
FontAwesomeImporterExamples >> loadedImporterFromMissingFile [
	<gtExample>
	<return: #FontAwesomeImporter>
	| importer |
	importer := self basicImporter.
	importer load.
	self assert: importer statusMessage equals: 'Choose a valid metadata/icons.json file.'.
	^ importer
]
