System System(/CELL/MEMBRANE/IKur)
{
	StepperID ODE;
#I_Kur
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

		Expression "1.47 / exp(((V.Value + 33.2 )/(-30.6))) + exp((V.Value - 27.6) / (-30.65))";
	}

	Process ExpressionAssignmentProcess( beta_a )
	{
	        StepperID   PSV;
		Priority 25;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ beta_a :.:beta_a 1 ];

		Expression "0.42 / (exp((V.Value + 26.6)/(-30.6)) + exp((V.Value + 44.4)/20.36))";
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
		
		Expression "1.0 / (1.0 + exp((V.Value - 5.93)/(-9.9)))";
	}

	Process ExpressionAssignmentProcess( tau_a )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ alpha_a :.:alpha_a 0 ]
			[ beta_a :.:beta_a 0 ]
	                [ tau_a :.:tau_a 1 ];

		Expression "1.0 / (alpha_a.Value + beta_a.Value)";
	}

	Variable Variable( a )
	{
		Value 0; #0.00621 in 2006
#		Value 0.00621;
	}

	Process ExpressionFluxProcess( a )
	{
	        StepperID   ODE;
		Priority 15;

		VariableReferenceList
			[ t :/:t 0]
			[ a_inf :.:a_inf 0 ]
			[ tau_a :.:tau_a 0 ]
			[ a :.:a 1 ];
				
		Expression "(a_inf.Value - a.Value) / tau_a.Value";
	}

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

		Expression "1.0/(21.0 + exp((V.Value - 185.0)/(-28.0)))";
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
		Value	0;
	}

	Process ExpressionAssignmentProcess( i_inf )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ V :..:Vm 0 ]
	                [ i_inf :.:i_inf 1 ];

		Expression "1.0/(1.0 + exp((V.Value - 99.45)/27.48))";
	}

	Process ExpressionAssignmentProcess( tau_i )
	{
	        StepperID   PSV;
		Priority 20;

		VariableReferenceList
			[ V :..:Vm 0 ]
			[ alpha_i :.:alpha_i 0 ]
			[ beta_i :.:beta_i 0 ]
	                [ tau_i :.:tau_i 1 ];

		Expression "1.0 / (alpha_i.Value + beta_i.Value)";
	}

	Variable Variable( i )
	{
		Value 1.0; #0.4712 in 2006
#		Value 0.4712;
	}

	Process ExpressionFluxProcess( i )
	{
	        StepperID   ODE;
		Priority 15;

		VariableReferenceList
			[ i_inf :.:i_inf 0 ]
			[ tau_i :.:tau_i 0 ]
			[ i :.:i 1 ];
				
		Expression "(i_inf.Value - i.Value) / tau_i.Value";	
	}


	
	Variable Variable( E_K )
	{
		Value   1.0;
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
			[ E_K :.:E_K 0 ]
			[ K_o :/:K 0 ]
			[ a  :.:a 0 ]
			[ i  :.:i 0 ]
	                [ i_Kr :.:I 1 ];
        
		g_Kr 0.096; #0.153 in 2006
#		g_Kr 0.153;
		GX 1.0;
		
		Expression "GX * g_Kr * pow((K_o.Value/5.4),0.5) * a.Value * i.Value * (V.Value - E_K.Value)";
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

#	Process ExpressionFluxProcess( V )
#	{
#		Priority 5;
#
#		VariableReferenceList
#			[ i_Kr :.:I 0]
#	                [ V :..:Vm 1 ];

#		Expression "(-1.0) * i_Kr.Value ";
#	}
}
