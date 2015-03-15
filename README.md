# IBANTools
Tools for generating and validating IBANs (International Bank Account Numbers)

This Swift framework comprises a number of static utility functions usefull for banking applications. There are functions to create and verify IBAN numbers, retrieve a BIC from an IBAN or account number, account number checks and financial institute information. It uses informations provided by the European Central Bank plus country specific data (currently Germany only, provided by the Deutsche Bundesbank).

# Extensibility
The entire concept is made to allow flexible enhancements for other countries where needed. Simply add a new Swift class like DERules.swift to the source folder (and project) and the rules will automatically be picked up if you follow the same naming scheme (upper case country code + "Rules" as class name). You should also add unit tests for such an implementation, by adding an IBANToolsXXTest.swift class in the tests subfolder (and the project). Similar for account checks, if there are any.

# Usage
The package is a framework that you can either compile separately and just use the compiled framework or add the entire project as subproject to yours, which has the additional advantage that in the future Swift runtime updates are automatically included. This is important since applications contain embedded swift runtime libs to ensure even with later updates they still work for the version they are compiled against. If such embedded swift libs in your app and embedded frameworks differ, you can get all kind of trouble. This means you should always take care that all parts (main app and framework) of your product are compiled with the same Swift version.

Note: at the moment it's not possible to include the framework as sub project (at least I couldn't get it to work with an obj-c application). In such a case you have to directly include the swift files in your project and take care the resource files are included in your app so that the IBANtools can find their required data.
