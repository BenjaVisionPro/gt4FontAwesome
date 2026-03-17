## gt4FontAwesome

**gt4FontAwesome** brings Font Awesome icons into Glamorous Toolkit without bundling or redistributing any Font Awesome assets. Font Awesome is a licensed product, and this project intentionally contains **no icon files, no font files, and no packaged Font Awesome metadata**. Instead, gt4FontAwesome reads the metadata from **your own licensed Font Awesome download** and generates the corresponding icon classes inside your image. This keeps the integration clean and flexible while ensuring that Font Awesome assets remain sourced from the user’s licensed distribution.

To install icons, point the importer at the `icons.json` file inside your downloaded Font Awesome package. This import only needs to be performed once per image unless you choose to regenerate the icons later. The generated icon classes are placed into the package name you provide in the import script, so you can either commit those generated classes to your own repository or arrange for the import to run automatically on startup.

### Example import

```smalltalk
CFFontAwesomeIcons >> loadFromDisc
	"Point this to your licensed download of the font awesome metadata"

	CFFontAwesomeMetadataImporter
		importFromIconsJsonFile: '/Users/jupiter/Downloads/fontawesome-pro-5.15.4-desktop/metadata/icons.json'
				asFileReference
		packageName: 'BVC-FontAwesome'
		version: '5.15.4'
```

### Installation

```smalltalk
Metacello new
	repository: 'github://BenjaVisionPro/gt4FontAwesome:main/src';
	baseline: 'Gt4FontAwesome';
	load
```

### Load Lepiter

After installing with Metacello, you can execute:

```smalltalk
#BaselineOfGt4FontAwesome asClass loadLepiter
```

### How it works

The importer reads the Font Awesome metadata from your licensed distribution, creates style-specific icon libraries as needed, and generates Glamorous Toolkit-friendly icon classes for use in your UI. Once imported, those icons behave like normal code in your image: you can browse them, package them, commit them, and load them like any other generated artifact.

### Notes

- You must supply your **own licensed Font Awesome distribution**.
- gt4FontAwesome does **not** ship with Font Awesome icons.
- The generated icons are written into the package you specify during import.
- You may choose to commit the generated icon package to source control, or re-import the icons automatically during image startup or build setup.
