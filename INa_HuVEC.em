
System System(/CELL/MEMBRANE/INaL)
{
	StepperID	ODE;

	Variable Variable( I )
	{
		Value 0;
	}

	Variable Variable( cNa )
	{
		Value -22.3740519006;
	}

	Variable Variable( cK )
	{
		Value 0.000651216154604;
	}

	
	Variable Variable( vO_TM )
	{
		Value 0;
	}

	Variable Variable( vI2_TM )
	{
		Value 0;
	}

	Variable Variable( vIs_TM )
	{
		Value 0;
	}

	Variable Variable( vO_LM )
	{
		Value 0;
	}

	Variable Variable( vI1_LM )
	{
		Value 0;
	}

	Variable Variable( vI2_LM )
	{
		Value 0;
	}

	Variable Variable( vIs_LM )
	{
		Value 0;
	}

	Variable Variable( TM_C )
	{
		Value 0.910648818;
	}

	Variable Variable( TM_Is )
	{
		Value 0.08142621;
	}

	Variable Variable( TM_O )
	{
		Value 0.00000168;
	}

	Variable Variable( TM_I2 )
	{
		Value 0.007923296;
	}
	
	Variable Variable( LM_C )
	{
		Value 0.907300722;
	}
	Variable Variable( LM_Is )
	{
		Value 0.077310046;
	}
	Variable Variable( LM_O )
	{
		Value 0.00000854;
	}
	Variable Variable( LM_I1 )
	{
		Value 0.007419003;
	}
	Variable Variable( LM_I2 )
	{
		Value 0.007961694;
	}
	
	Variable Variable( GX ){
		Value 1.0;
	}

	Variable Variable( GX_T ){
		Value 1.0;
	}

	Variable Variable( GX_L ){
		Value 1.0;
	}	

	Process INaLAssignmentProcess( pOpen ) 
	{
		StepperID  PSV;
		Priority   20;

		VariableReferenceList
			[ vO_TM    :.:vO_TM  1 ]
			[ vI2_TM   :.:vI2_TM 1 ]
			[ vIs_TM   :.:vIs_TM 1 ]
			[ vO_LM    :.:vO_LM  1 ]
			[ vI1_LM   :.:vI1_LM 1 ]
			[ vI2_LM   :.:vI2_LM 1 ]
			[ vIs_LM   :.:vIs_LM 1 ]			
			[ TM_C	   :.:TM_C   0 ]
			[ TM_Is    :.:TM_Is  0 ]
			[ TM_O     :.:TM_O   0 ]
			[ TM_I2    :.:TM_I2  0 ]
			[ LM_C     :.:LM_C   0 ]
			[ LM_Is    :.:LM_Is  0 ]
			[ LM_O     :.:LM_O   0 ]
			[ LM_I1    :.:LM_I1  0 ]
			[ LM_I2    :.:LM_I2  0 ]
			[ v        :..:Vm    0 ]
			[ GX       :.:GX     0 ]
			[ GX_T     :.:GX_T   0 ]
			[ GX_L     :.:GX_L   0 ]

			[ Nae      :/:Na      0 ]
			[ Ke       :/:K       0 ]

			[ Nai      :../../CYTOPLASM:Na     0 ]
			[ Ki       :../../CYTOPLASM:K      0 ]
			[ cNa      :.:cNa                   1 ]
			[ cK       :.:cK                    1 ]
			[ I        :.:I                     1 ];


                permeabilityNa  6.756;
                permeabilityK   0.6756;
				
	}

	Process ZeroVariableAsFluxProcess( vO_TM ) 
	{
		Priority  15;

		VariableReferenceList
			[ vO_TM    :.:vO_TM  0 ]
			[ TM_O     :.:TM_O   1 ];
	}


	Process ZeroVariableAsFluxProcess( vI2_TM ) 
	{
		Priority  15;

		VariableReferenceList
			[ vI2_TM   :.:vI2_TM 0 ]
			[ TM_I2    :.:TM_I2  1 ];
	}

	Process ZeroVariableAsFluxProcess( vIs_TM ) 
	{
		Priority  15;

		VariableReferenceList
			[ vIs_TM   :.:vIs_TM 0 ]
			[ TM_Is    :.:TM_Is  1 ];
	}

	Process ZeroVariableAsFluxProcess( vO_LM ) 
	{
		Priority  15;

		VariableReferenceList
			[ vO_LM    :.:vO_LM  0 ]
			[ LM_O     :.:LM_O   1 ];
	}		

	Process ZeroVariableAsFluxProcess( vI1_LM ) 
	{
		Priority  15;

		VariableReferenceList	
			[ vI1_LM   :.:vI1_LM 0 ]
			[ LM_I1    :.:LM_I1  1 ];
	}

	Process ZeroVariableAsFluxProcess( vI2_LM ) 
	{
		Priority  15;

		VariableReferenceList
			[ vI2_LM   :.:vI2_LM 0 ]
			[ LM_I2    :.:LM_I2  1 ];
	}

	Process ZeroVariableAsFluxProcess( vIs_LM ) 
	{
		Priority  15;

		VariableReferenceList
			[ vIs_LM   :.:vIs_LM 0 ]			
			[ LM_Is    :.:LM_Is  1 ];
	}

	@setCurrents( [ 'I' ], [ 'Na', 'cNa' ], [ 'K', 'cK' ] )

}

