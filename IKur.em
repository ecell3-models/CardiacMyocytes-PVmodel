System System(/CELL/MEMBRANE/IKur)
{
	StepperID ODE;
#I_Kur
	Variable Variable( alpha_i )
	{
		Value	1.0; #tmp
	}

	Variable Variable( beta_i )
	{
		Value	1.0; #tmp
	}

	Process ExpressionAssignmentProcess( alpha_i )
	{
	        StepperID   PSV;
		Priority 25;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ alpha_i :.:alpha_i 1 ];

		Expression "1.0 / (21.0 + exp((V.Value - 185.0)/(-28.0)))";
	}

	Process ExpressionAssignmentProcess( beta_i )
	{
	        StepperID   PSV;
		Priority 25;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ beta_i :.:beta_i 1 ];

		Expression "exp((V.Value - 158.0)/16.0)";
	}

	Variable Variable( i_inf )
	{
		Value	0; #tmp
	}

	Variable Variable( tau_i )
	{
		Value	1.0;
	}

	Process ExpressionAssignmentProcess( i_inf )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ i_inf :.:i_inf 1 ];
		
		Expression "1.0 / (1.0 + exp((V.Value - 99.45)/27.48))";
	}

	Process ExpressionAssignmentProcess( tau_i )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ alpha_i :.:alpha_i 0 ]
			[ beta_i :.:beta_i 0 ]
	                [ tau_i :.:tau_i 1 ];

			KQ10 1.0;

		Expression "KQ10 /(alpha_i.Value + beta_i.Value)";
	}

	Variable Variable( i )
	{
		Value 9.986e-1; #0.00621 in 2006
#		Value 0.00621;
	}

	Process ExpressionFluxProcess( i )
	{
	        StepperID   ODE;
		Priority 15;

		VariableReferenceList
			[ t :/:t 0]
			[ i_inf :.:i_inf 0 ]
			[ tau_i :.:tau_i 0 ]
			[ i :.:i 1 ];
				
		Expression "(i_inf.Value - i.Value) / tau_i.Value";
	}

	Variable Variable( alpha_a )
	{
		Value	1.0; #tmp
	}

	Variable Variable( beta_a )
	{
		Value	1.0; #tmp
	}


	Process ExpressionAssignmentProcess( alpha_a )
	{
	        StepperID   PSV;
		Priority 25;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ alpha_a :.:alpha_a 1 ];

		Expression "0.65 / (exp((V.Value + 10.0)/(-8.5)) + exp((V.Value - 30.0)/(-59.0)))";
	}

	Process ExpressionAssignmentProcess( beta_a )
	{
	        StepperID   PSV;
		Priority 25;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ beta_a :.:beta_a 1 ];

		Expression "0.65 / (2.5 + exp((V.Value + 82.0)/17.0))";	
	}

	Variable Variable( a_inf )
	{
		Value	0; #tmp
	}

	Variable Variable( tau_a )
	{
		Value	1.0;
	}

	Process ExpressionAssignmentProcess( a_inf )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ a_inf :.:a_inf 1 ];

		Expression "1.0/(1.0 + exp((V.Value + 30.3)/(-9.6)))";
	}

	Process ExpressionAssignmentProcess( tau_a )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ V :..:Vm 0 ]
			[ alpha_a :.:alpha_a 0 ]
			[ beta_a :.:beta_a 0 ]
	                [ tau_a :.:tau_a 1 ];

			KQ10 1.0;

		Expression "KQ10 /(alpha_a.Value + beta_a.Value)";
	}

	Variable Variable( a )
	{
		Value 4.966e-3; #0.4712 in 2006
#		Value 0.4712;
	}

	Process ExpressionFluxProcess( a )
	{
	        StepperID   ODE;
		Priority 15;

		VariableReferenceList
			[ a_inf :.:a_inf 0 ]
			[ tau_a :.:tau_a 0 ]
			[ a :.:a 1 ];



		Expression "(a_inf.Value - a.Value) / tau_a.Value";	
	}

	Variable Variable( G_Kur )
	{
		Value   0; #tmp
	}


	Process ExpressionAssignmentProcess( G_Kur )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ V :..:Vm 0 ]
			[ G_Kur :.:G_Kur 1 ];


		Expression "0.0005 + 0.05 / (1.0 + exp((V.Value - 15.0)/(-13.0)))";
	}

	
	Variable Variable( E_K )
	{
		Value   1.0;
	}

	Process ExpressionAssignmentProcess( E_K )
	{
		StepperID PSV;
		Priority 20;

		VariableReferenceList
			[ R :/:R 0 ]
			[ T :/:T 0 ]
			[ F :/:F 0 ]
			[ K_o :/:K 0 ]
			[ K_i :../../CYTOPLASM:K 0 ]
			[ E_K :.:E_K 1 ];

		Expression "(R.Value * T.Value / F.Value )* log(K_o.Value/K_i.Value)";
	}

	Variable Variable( I )
#	Variable Variable( i_Kr )
	{
		Value	0; #tmp
	}

	Process ExpressionAssignmentProcess( i_Kur )
	#i_Kr = g_Kr * root(K_o / 5.4 {unit: millimolar}) * Xr1 * Xr2 * (V - E_K);
	{
	        StepperID   PSV;
		Priority 10;

		VariableReferenceList
			[ V :..:Vm 0 ]
			[ G_Kur :.:G_Kur 0]
			[ E_K :.:E_K 0 ]
			[ K_o :/:K 0 ]
			[ a  :.:a 0 ]
			[ i  :.:i 0 ]
	                [ i_Kur :.:I 1 ];
        
		GX 1.0;
		
		Expression "GX * G_Kur.Value * pow(a.Value,3.0) * i.Value * (V.Value - E_K.Value)";
	}

#	Process ExpressionFluxProcess( K_i )
#        {
#                Priority 5;

#                VariableReferenceList
#                        [ K_i :../../CYTOPLASM:K_i 1]
#                        [ V_c :../..:V_myo 0]
#                        [ i_Kr :.:I 0]
#                        [ F :/:F 0]
#                        [ Cm :..:Cm 0]
#                        [ V :..:Vm 0 ];

#                Expression "(-1.0 * i_Kr.Value )/( 1.0 * V_c.Value * F.Value)*Cm.Value";
#        }	

	Process ExpressionFluxProcess( V )
	{
		Priority 5;

		VariableReferenceList
			[ i_Kur :.:I 0]
	                [ V :..:Vm 1 ];

		Expression "(-1.0) * i_Kur.Value";
	}
}
