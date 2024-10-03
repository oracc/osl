https://raw.githubusercontent.com/oracc/osl/refs/heads/master/00etc/oracc-pua.tab

				OSL Use of PUA
				==============

Oracc uses the PUA from F0000-FFFFD and all management of the Oracc
PUA is consolidated in the OSL project.

The region from F0000-F0FFF is used for core Oracc additions; the
region from F1000 and up is used for font-specific additions.

Characters are added to the PUA but are never removed.  If a PUA
character is subsequently encoded the OSL is updated to reflect the
encoded character but the version in the PUA is left as it is.

A running account of the PUA usage is kept in osl/00etc/oracc-pua.tab.

pua-used.txt is simple:

 OID|KEY	PUA-CODE	SCRIPT|FONT-KEY

A KEY is a namespace for a sign, e.g., tcl8, where there is a variant
'e' form, named tcl8:e~a.

PUA-CODE is the uppercase hex codepoint

SCRIPT|FONT-KEY is either a script code--Xsux, Pcun--or a font name
which can be used (perhaps with additional metadata outside the scope
of pua-used.txt) to locate the font that uses the relevant PUA
character.

The signlist tool suite, sx, might one day provide a utility for
managing Oracc's PUA use.

