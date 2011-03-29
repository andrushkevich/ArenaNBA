/*
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2008 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * Canadian French language file.
 */

var FCKLang =
{
// Language direction : "ltr" (left to right) or "rtl" (right to left).
Dir					: "ltr",

ToolbarCollapse		: "Masquer Outils",
ToolbarExpand		: "Afficher Outils",

// Toolbar Items and Context Menu
Save				: "Sauvegarder",
NewPage				: "Nouvelle page",
Preview				: "Previsualiser",
Cut					: "Couper",
Copy				: "Copier",
Paste				: "Coller",
PasteText			: "Coller en tant que texte",
PasteWord			: "Coller en tant que Word (formaté)",
Print				: "Imprimer",
SelectAll			: "Tout sélectionner",
RemoveFormat		: "Supprimer le formatage",
InsertLinkLbl		: "Lien",
InsertLink			: "Insérer/modifier le lien",
RemoveLink			: "Supprimer le lien",
Anchor				: "Insérer/modifier l'ancre",
AnchorDelete		: "Supprimer l'ancre",
InsertImageLbl		: "Image",
InsertImage			: "Insérer/modifier l'image",
InsertFlashLbl		: "Animation Flash",
InsertFlash			: "Insérer/modifier l'animation Flash",
InsertTableLbl		: "Tableau",
InsertTable			: "Insérer/modifier le tableau",
InsertLineLbl		: "Séparateur",
InsertLine			: "Insérer un séparateur",
InsertSpecialCharLbl: "Caractères spéciaux",
InsertSpecialChar	: "Insérer un caractère spécial",
InsertSmileyLbl		: "Emoticon",
InsertSmiley		: "Insérer un Emoticon",
About				: "A propos de FCKeditor",
Bold				: "Gras",
Italic				: "Italique",
Underline			: "Souligné",
StrikeThrough		: "Barrer",
Subscript			: "Indice",
Superscript			: "Exposant",
LeftJustify			: "Aligner à gauche",
CenterJustify		: "Centrer",
RightJustify		: "Aligner à Droite",
BlockJustify		: "Texte justifié",
DecreaseIndent		: "Diminuer le retrait",
IncreaseIndent		: "Augmenter le retrait",
Blockquote			: "Citation",
Undo				: "Annuler",
Redo				: "Refaire",
NumberedListLbl		: "Liste numérotée",
NumberedList		: "Insérer/supprimer la liste numérotée",
BulletedListLbl		: "Liste à puces",
BulletedList		: "Insérer/supprimer la liste à puces",
ShowTableBorders	: "Afficher les bordures du tableau",
ShowDetails			: "Afficher les caractères invisibles",
Style				: "Style",
FontFormat			: "Format",
Font				: "Police",
FontSize			: "Taille",
TextColor			: "Couleur de caractère",
BGColor				: "Couleur de fond",
Source				: "Source",
Find				: "Chercher",
Replace				: "Remplacer",
SpellCheck			: "Orthographe",
UniversalKeyboard	: "Clavier universel",
PageBreakLbl		: "Saut de page",
PageBreak			: "Insérer un saut de page",

Form			: "Formulaire",
Checkbox		: "Case à cocher",
RadioButton		: "Bouton radio",
TextField		: "Champ texte",
Textarea		: "Zone de texte",
HiddenField		: "Champ caché",
Button			: "Bouton",
SelectionField	: "Champ de sélection",
ImageButton		: "Bouton image",

FitWindow		: "Edition pleine page",
ShowBlocks		: "Afficher les blocs",

// Context Menu
EditLink			: "Modifier le lien",
CellCM				: "Cellule",
RowCM				: "Ligne",
ColumnCM			: "Colonne",
InsertRowAfter		: "Insérer une ligne après",
InsertRowBefore		: "Insérer une ligne avant",
DeleteRows			: "Supprimer des lignes",
InsertColumnAfter	: "Insérer une colonne après",
InsertColumnBefore	: "Insérer une colonne avant",
DeleteColumns		: "Supprimer des colonnes",
InsertCellAfter		: "Insérer une cellule après",
InsertCellBefore	: "Insérer une cellule avant",
DeleteCells			: "Supprimer des cellules",
MergeCells			: "Fusionner les cellules",
MergeRight			: "Fusionner à droite",
MergeDown			: "Fusionner en bas",
HorizontalSplitCell	: "Scinder la cellule horizontalement",
VerticalSplitCell	: "Scinder la cellule verticalement",
TableDelete			: "Supprimer le tableau",
CellProperties		: "Propriétés de cellule",
TableProperties		: "Propriétés du tableau",
ImageProperties		: "Propriétés de l'image",
FlashProperties		: "Propriétés de l'animation Flash",

AnchorProp			: "Propriétés de l'ancre",
ButtonProp			: "Propriétés du bouton",
CheckboxProp		: "Propriétés de la case à cocher",
HiddenFieldProp		: "Propriétés du champ caché",
RadioButtonProp		: "Propriétés du bouton radio",
ImageButtonProp		: "Propriétés du bouton image",
TextFieldProp		: "Propriétés du champ texte",
SelectionFieldProp	: "Propriétés de la liste/du menu",
TextareaProp		: "Propriétés de la zone de texte",
FormProp			: "Propriétés du formulaire",

FontFormats			: "Normal;Formaté;Adresse;En-tête 1;En-tête 2;En-tête 3;En-tête 4;En-tête 5;En-tête 6;Normal (DIV)",

// Alerts and Messages
ProcessingXHTML		: "Calcul XHTML. Veuillez patienter...",
Done				: "Terminé",
PasteWordConfirm	: "Le texte à coller semble provenir de Word. Désirez-vous le nettoyer avant de coller?",
NotCompatiblePaste	: "Cette commande nécessite Internet Explorer version 5.5 et plus. Souhaitez-vous coller sans nettoyage?",
UnknownToolbarItem	: "Élément de barre d'outil inconnu \"%1\"",
UnknownCommand		: "Nom de commande inconnu \"%1\"",
NotImplemented		: "Commande indisponible",
UnknownToolbarSet	: "La barre d'outils \"%1\" n'existe pas",
NoActiveX			: "Les paramètres de sécurité de votre navigateur peuvent limiter quelques fonctionnalités de l'éditeur. Veuillez activer l'option \"