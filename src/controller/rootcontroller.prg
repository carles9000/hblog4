//----------------------------------------------------------------------------//

CLASS RootController


    data nRegGrande  init 10000000

    METHOD New( oController )			CONSTRUCTOR

    METHOD next( oController )  
    METHOD prev( oController )      
    METHOD gotop( oController ) 
    METHOD gobottom( oController )  
    METHOD search( oController )    
    METHOD go( oController )  

    METHOD default( oController )  

ENDCLASS    

//----------------------------------------------------------------------------//

METHOD New( oController ) CLASS RootController

    local cAction := oController:oRequest:Post( 'action' )

	//? 'Action => ', cAction
	
	
    do case

       case cAction == "next"   	; ::next( oController )
       case cAction == "prev"   	; ::prev( oController )
       case cAction == "gotop"   	; ::gotop( oController )
       case cAction == "gobottom"   ; ::gobottom( oController )
       case cAction == "buscar"   	; ::search( oController )       
       case cAction == "go"   		; ::go( oController )       

       otherwise
          ::Default( oController ) 		 		  
    endcase

return Self    

//----------------------------------------------------------------------------//

METHOD Default( oController ) CLASS RootController

   local oModelEntry 	:= EntryModel():New()   
   local hData 		    := oModelEntry:Rows( NIL, 5 ) 

   oController:View( "root.view", hData )

RETU nil 

METHOD Go( oController ) CLASS RootController

   local oModelEntry 	:= EntryModel():New()   
   local nRecno			:= oController:oRequest:Post( 'recno', 0, 'N' ) - 1 
   local hData 		    := oModelEntry:Rows( nRecno, 5 ) 

   oController:View( "root.view", hData )

RETU nil 

METHOD Next( oController ) CLASS RootController  

	local oModelEntry   := EntryModel():New() 
	local nRecno 		:= oController:oRequest:Post( 'recno', 0, 'N' )
	local hData 		:= oModelEntry:Rows( nRecno, 5 )

	oController:View( "root.view", hData )
	
RETU NIL

METHOD prev( oController ) CLASS RootController  

	local oModelEntry   := EntryModel():New() 
	local nRecno 		:= oController:oRequest:Post( 'recno', 0, 'N' )
	local hData 		:= oModelEntry:Rows( nRecno, -5 )

	oController:View( "root.view", hData )
	
RETU NIL


METHOD gotop( oController ) CLASS RootController  

	local oModelEntry   := EntryModel():New() 
	local nRecno 		:= 0 
	local hData 		:= oModelEntry:Rows( nRecno, 5 )

	oController:View( "root.view", hData )
	
RETU NIL

METHOD search( oController ) CLASS RootController  

	local cSearch 		:= oController:oRequest:Post( 'search' )
	local oModelEntry   := EntryModel():New() 
	local hData 		:= oModelEntry:search( cSearch  )

	oController:View( "root.view", hData )
	
RETU NIL

METHOD gobottom( oController ) CLASS RootController  

	local oModelEntry   := EntryModel():New() 
	local nRecno 		:= ::nRegGrande 
	local hData 		:= oModelEntry:Rows( nRecno, 5 )

	oController:View( "root.view", hData )
	
RETU NIL


{% LoadFile( "/src/model/entry.prg" ) %}
