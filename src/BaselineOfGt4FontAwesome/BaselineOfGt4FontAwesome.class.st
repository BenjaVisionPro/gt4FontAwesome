Class {
	#name : 'BaselineOfGt4FontAwesome',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGt4FontAwesome',
	#package : 'BaselineOfGt4FontAwesome'
}

{ #category : 'loading' }
BaselineOfGt4FontAwesome class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'Gt4FontAwesome' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : 'baseline' }
BaselineOfGt4FontAwesome >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'BVC-FontAwesome-Core'
		]
]
