# IBANTools
Tools for generating and validating IBANs (International Bank Account Numbers)

This Swift framework comprises a number of static utility functions usefull for banking applications. There are functions to create and verify IBAN numbers, retrieve a BIC from an IBAN or account number, account number checks and financial institute information. It uses informations provided by the European Central Bank plus country specific data (currently Germany only, provided by the Deutsche Bundesbank).

# Extensibility
The entire concept is made to allow flexible enhancements for other countries where needed. Simply add a new Swift class like DERules.swift to the source folder (and project) and the rules will automatically be picked up if you follow the same naming scheme (upper case country code + "Rules" as class name). You should also add unit tests for such an implementation, by adding an IBANToolsXXTest.swift class in the tests subfolder (and the project). Similar for account checks, if there are any.

# Usage
The package is a framework that you can either compile separately and just use the compiled framework or add the entire project as subproject to yours.
