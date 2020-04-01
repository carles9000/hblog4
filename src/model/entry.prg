#define MAXROWS 5
//----------------------------------------------------------------------------//

CLASS EntryModel 

	DATA cAlias	

	METHOD New()             		CONSTRUCTOR
	
	METHOD Search( cSearch )
	METHOD Rows( nId, nRows )
	METHOD GetId( nId )
	METHOD Load()
	
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS EntryModel

	
	USE ( AppPathData() + 'entry.dbf' ) SHARED NEW VIA 'DBFCDX'
	SET INDEX TO 'entry.cdx'
	
	::cAlias := Alias()		

RETU SELF

//	-----------------------------------------------

METHOD Search( cSearch ) CLASS EntryModel

	LOCAL hData 	:= {=>}
	LOCAL hRows 	:= {}
	LOCAL nCount 	:= 0
	LOCAL nRecno
   
	cSearch = lower( alltrim( cSearch ) )

	( ::cAlias )->( dbgotop() )
	
	locate for ( hb_WildMatch( "*" + cSearch + "*", lower( ( ::cAlias )->titulo ) )  .or. ;
	              hb_WildMatch( "*" + cSearch + "*", lower( ( ::cAlias )->texto  ) ) ) .and. ;
				  !( ::cAlias )->( eof() ) 
				  
	hData[ 'first' ] 	:= (::cAlias)->( OrdKeyNo() )				
	hData[ 'last']		:= (::cAlias)->( OrdKeyNo() )			  

	while ( ::cAlias )->( found() )

		nRecno 			:= (::cAlias)->( Recno() )
		hData[ 'last']	:= (::cAlias)->( OrdKeyNo() )
					
		Aadd( hRows, ::Load( nRecno ) )				
	
		nCount++						
		
		continue
	end		
	
	hData[ 'rows'  ] := hRows

RETU hData

//	-----------------------------------------------

METHOD Rows( nFirst, nLast, lAvPage ) CLASS EntryModel

	LOCAL hData 	:= {=>}
	LOCAL hRows 	:= {}
	LOCAL nCount 	:= 0
	LOCAL nRecno

	DEFAULT nFirst		TO 0
	DEFAULT nLast	 	TO 0
	DEFAULT lAvPage	TO .T.

	IF nFirst == 0	 
	
		(::cAlias)->( DbGoTop() )
		
	ELSE
	
		IF lAvPage			

			(::cAlias)->( OrdKeyGoto( ++nLast ) )
			
			IF (::cAlias)->( EOF() )
				(::cAlias)->( DbGoBottom() )				
			ENDIF			
		
		ELSE

			(::cAlias)->( OrdKeyGoto( nFirst ) )			
			(::cAlias)->( DbSkip( -MAXROWS ) )
			
			IF (::cAlias)->( BOF() )
				(::cAlias)->( DbGoTop() )				
			ENDIF
			
		ENDIF		
		
	ENDIF
	
	hData[ 'first' ] 	:= (::cAlias)->( OrdKeyNo() )				
	hData[ 'last'] 		:= (::cAlias)->( OrdKeyNo() )	
	
	WHILE nCount < MAXROWS .AND. (::cAlias)->( !Eof() )
	
		nRecno 			:= (::cAlias)->( Recno() )
		hData[ 'last'] 	:= (::cAlias)->( OrdKeyNo() )	

		Aadd( hRows, ::Load( nRecno ) )
	
		nCount++						
	
		(::cAlias)->( DbSkip() )
	END				
	
	hData[ 'rows'] := hRows

RETU hData


//	-----------------------------------------------


METHOD GetId( nId ) CLASS EntryModel

	LOCAL hRow 	:= {=>}
	
	DEFAULT nId TO 0
	
	(::cAlias)->( DbGoTo( nId ) )

	hRow := ::Load( nId )

RETU hRow

//	-----------------------------------------------

METHOD Load( nId ) CLASS EntryModel

	LOCAL cTexto 	:= (::cAlias)->texto 
	LOCAL hRow 		:= { '_recno'	=> nId,;
						'id' 		=> (::cAlias)->id,;
						'fecha'		=> (::cAlias)->fecha,;
						'titulo'	=> (::cAlias)->titulo,;
						'photo'		=> alltrim( (::cAlias)->photo ),;
						'author'	=> (::cAlias)->author,;									
						'texto' 	=> substr( cTexto, 1, len(cTexto) );
						}

RETU hRow