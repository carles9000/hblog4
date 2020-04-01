//----------------------------------------------------------------------------//

CLASS RootController


    METHOD New( oController )			CONSTRUCTOR

    METHOD Next( oController )  
    METHOD Prev( oController )      
    METHOD Gotop( oController ) 
    METHOD Gobottom( oController )  
    METHOD Search( oController )    
    METHOD Go( oController )  

    METHOD Default( oController )  

ENDCLASS    

//----------------------------------------------------------------------------//

METHOD New( oController ) CLASS RootController

    local cAction := oController:oRequest:Post( 'action' )

	//? 'Action => ', cAction	
	
    do case

       case cAction == "next"   		; ::Next( oController )
       case cAction == "prev"   		; ::Prev( oController )
       case cAction == "gotop"   		; ::Gotop( oController )
       case cAction == "gobottom"   	; ::Gobottom( oController )
       case cAction == "buscar"   		; ::Search( oController )       
       case cAction == "go"   			; ::Go( oController )       

       otherwise
          ::Default( oController ) 		 		  
    endcase

return Self    

//----------------------------------------------------------------------------//

METHOD Default( oController ) CLASS RootController

   local oModelEntry 		:= EntryModel():New()   
   local hData 		    := oModelEntry:Rows() 

   oController:View( "root.view", hData )

RETU nil 

METHOD Go( oController ) CLASS RootController

   local oModelEntry 		:= EntryModel():New()   
   local nRecno			:= oController:oRequest:Post( 'recno', 0, 'N' ) - 1 
   local hData 		    := oModelEntry:Rows( nRecno ) 

   oController:View( "root.view", hData )

RETU nil 

METHOD Next( oController ) CLASS RootController  

	local oModelEntry   	:= EntryModel():New() 
	local nFirst 			:= oController:oRequest:Post( 'first', 0, 'N' )
	local nLast 			:= oController:oRequest:Post( 'last', 0, 'N' )
	local hData 			:= oModelEntry:Rows( nFirst, nLast )

	oController:View( "root.view", hData )
	
RETU NIL

METHOD Prev( oController ) CLASS RootController  

	local oModelEntry    	:= EntryModel():New() 
	local nFirst 			:= oController:oRequest:Post( 'first', 0, 'N' )
	local nLast 			:= oController:oRequest:Post( 'last', 0, 'N' )	
	local hData 			:= oModelEntry:Rows( nFirst, nLast, .F.)

	oController:View( "root.view", hData )
	
RETU NIL


METHOD Gotop( oController ) CLASS RootController  

	local oModelEntry   	:= EntryModel():New() 
	local hData 			:= oModelEntry:Rows()

	oController:View( "root.view", hData )
	
RETU NIL

METHOD Search( oController ) CLASS RootController  

	local cSearch 			:= oController:oRequest:Post( 'search' )
	local oModelEntry   	:= EntryModel():New() 
	local hData 			:= oModelEntry:search( cSearch  )

	oController:View( "root.view", hData )
	
RETU NIL

METHOD Gobottom( oController ) CLASS RootController  

	local oModelEntry  	:= EntryModel():New()
	local hData 			:= oModelEntry:Rows( 1, 999999999999999 )

	oController:View( "root.view", hData )
	
RETU NIL

{% LoadFile( "/src/model/entry.prg" ) %}
