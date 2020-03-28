//----------------------------------------------------------------------------//

CLASS CardController

    METHOD New( oController )		CONSTRUCTOR

    METHOD See( oController )  

ENDCLASS    

//----------------------------------------------------------------------------//

METHOD New( oController ) CLASS CardController

return Self    

//----------------------------------------------------------------------------//

METHOD See( oController ) CLASS CardController  

	local oModelEntry   := EntryModel():New() 
	local nRecno 		:= oController:oRequest:Get( 'recno', 0, 'N' )
	local hRow 			:= oModelEntry:GetId( nRecno )
	
	//? '--------------> See'
	//? nRecno
	//? valtoChar( hRow )		
	
	oController:View( 'card.view', hRow )
	
RETU NIL

{% LoadFile( "/src/model/entry.prg" ) %}
