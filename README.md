# IBANTools
Tools for generating and validating IBANs (International Bank Account Numbers)

This Swift framework contains a method to validate IBANs (checksum computation and check) and to generate IBANs based on account number and bank code. It supports a generic method used for all standard cases (in any country using IBANs) + handling of special rules for Germany, including validation of account numbers, to avoid generating a correctly checksum'ed IBAN out of an invalid account number.

# Extensibility
The entire concept is made to allow flexible enhancements for other countries where needed. Simply add a new Swift class like DERules.swift to the source folder (and project) and the rules will automatically be picked up if you follow the same naming scheme (upper case country code + "Rules" as class name). You should also add unit tests for such an implementation, by adding an IBANToolsXXTest.swift class in the tests subfolder (and the project). Similar for account checks, if there are any.

# Usage
The package is a framework that you can either compile separately and just use the compiled framework or add the entire project as subproject to yours, which has the additional advantage that in the future Swift runtime updates are automatically included. This is important since applications contain embedded swift runtime libs to ensure even with later updates they still work for the version they are compiled against. If such embedded swift libs in your app and embedded frameworks differ, you can get all kind of trouble. This means you should always take care that all parts (main app and framework) of your product are compiled with the same Swift version.
