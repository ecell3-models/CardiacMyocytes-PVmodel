#include "libecs.hpp"
#include "Process.hpp"

USE_LIBECS;

LIBECS_DM_CLASS( INaLAssignmentProcess, Process )
{

 public:

	LIBECS_DM_OBJECT( INaLAssignmentProcess, Process )
	{
		INHERIT_PROPERTIES( Process ); 


		PROPERTYSLOT_SET_GET( Real, permeabilityNa );
		PROPERTYSLOT_SET_GET( Real, permeabilityK );
	}
	
	INaLAssignmentProcess()
		:
		permeabilityNa( 6.756 ),
		permeabilityK(  0.6756 )
	{
		// do nothing
	}

	SIMPLE_SET_GET_METHOD( Real, permeabilityNa );
	SIMPLE_SET_GET_METHOD( Real, permeabilityK );
	
	virtual void initialize()
	{
		Process::initialize();
		
		vO_TM  = getVariableReference( "vO_TM" ).getVariable();
		vI2_TM  = getVariableReference( "vI2_TM" ).getVariable();
		vIs_TM  = getVariableReference( "vIs_TM" ).getVariable();

		vO_LM  = getVariableReference( "vO_LM" ).getVariable();
		vI1_LM  = getVariableReference( "vI1_LM" ).getVariable();
		vI2_LM  = getVariableReference( "vI2_LM" ).getVariable();
		vIs_LM  = getVariableReference( "vIs_LM" ).getVariable();

		TM_C  = getVariableReference( "TM_C" ).getVariable();
		TM_Is  = getVariableReference( "TM_Is" ).getVariable();
		TM_O  = getVariableReference( "TM_O" ).getVariable();
		TM_I2  = getVariableReference( "TM_I2" ).getVariable();
		LM_C  = getVariableReference( "LM_C" ).getVariable();
		LM_Is  = getVariableReference( "LM_Is" ).getVariable();
		LM_O  = getVariableReference( "LM_O" ).getVariable();
		LM_I1  = getVariableReference( "LM_I1" ).getVariable();
		LM_I2  = getVariableReference( "LM_I2" ).getVariable();

		v  = getVariableReference( "v" ).getVariable();

		Nae  = getVariableReference( "Nae" ).getVariable();
		Nai  = getVariableReference( "Nai" ).getVariable();
		Ke  = getVariableReference( "Ke" ).getVariable();
		Ki  = getVariableReference( "Ki" ).getVariable();

		GX  = getVariableReference( "GX" ).getVariable();
		GX_T  = getVariableReference( "GX_T" ).getVariable();
		GX_L  = getVariableReference( "GX_L" ).getVariable();

		cNa  = getVariableReference( "cNa" ).getVariable();
		cK  = getVariableReference( "cK" ).getVariable();

		I  = getVariableReference( "I" ).getVariable();
	}

	virtual void fire()
	{
		_Vm = v->getValue();

		Real Is_TM = TM_Is->getValue();
		Real O_TM = TM_O->getValue();
		Real I2_TM = TM_I2->getValue();
		Real Is_LM = LM_Is->getValue();
		Real O_LM = LM_O->getValue();
		Real I1_LM = LM_I1->getValue();
		Real I2_LM = LM_I2->getValue();
		
		//gating of TM
		Real kC2O_INa = 1.0 / (0.0025 * exp( _Vm / -8.0) + 0.15 * exp( _Vm / -100.0)); //common for both TM and LSM
		Real kOC_INa = 1.0 / (30.0 * exp( _Vm / 12.0) + 0.53 * exp( _Vm / 50.0)); //common for both TM and LSM
 
     		Real kOI2_TM = 1.0 / (0.0433 * exp( _Vm / -27.0) + 0.34 * exp( _Vm / -2000.0)); //'specific for TM
		Real kI2O_TM = 0.0001312; //'specific for TM
 
		Real kC2I2_TM = 0.5 / (1.0 + kI2O_TM * kOC_INa / kOI2_TM / kC2O_INa); 
		//'micro scopic reversibility is assume for the triangle (C - O - I2) with tau (1 / (kC2I2 + kI2C)) =  2 ms
		Real kI2C_TM = 0.5 - kC2I2_TM;  //'modified from tau = 2 ms
 
		Real kIsb_TM = 1.0 / (300000 * exp( _Vm / 10) + 50000.0 * exp( _Vm / 16.0)); //'backward rate, recovery from slow inactivation, Is to I2     
		Real kIsf_TM = 1.0 / (0.016 * exp( _Vm / -9.9) + 8.0 * exp( _Vm / -45.0));  //'forward rate, I2 to Is
 
		//state transitions of TM
		Real _C_TM = 1.0 - Is_TM - O_TM - I2_TM;      //'conservation in the 4 state model
		TM_C->setValue( _C_TM ) ;

		Real fC_INa = 1 / (1 + exp( (_Vm + 48.0) / -7.0));  //'instantaneous distribution between C1 and C2 states, which are included in the lumped state C
 
		Real dO_TMdt = I2_TM * kI2O_TM + fC_INa * _C_TM * kC2O_INa - O_TM * (kOC_INa + kOI2_TM);   //'rate of change of O state
		Real dI2_TMdt = fC_INa * _C_TM * kC2I2_TM + O_TM * kOI2_TM + Is_TM * kIsb_TM - I2_TM * (kI2C_TM + kI2O_TM + kIsf_TM); //rate of change of I2
		Real dIs_TMdt = I2_TM * kIsf_TM + _C_TM * kIsf_TM - Is_TM * 2 * kIsb_TM;  //'rate of change of Is

		vO_TM->setValue( dO_TMdt);
		vI2_TM->setValue( dI2_TMdt );
		vIs_TM->setValue( dIs_TMdt);
 	
		//gating of LSM
		Real sclI1I2 = 1.0;
		Real fixzero = 1.0;

		Real kI1I2 = 0.00534 * sclI1I2 * fixzero; //'voltage-independent rate, specific for LSM , can be fixed if appropriate
		Real kOI1_LM = kOI2_TM;  //'the same rate as in TM mode
		Real kI1O_LM = 0.01;     //'voltage-independent rate, specific for LSM
		Real kI1C_LM = kI2C_TM;  //'the same rate as in TM mode
		Real kC2I1_LM = kC2I2_TM;  //'the same rate as in TM mode
 
		Real kC2I2_LM = kC2I2_TM * fixzero;  
		//'when appropriate, the fast gating can be isolated from the slow inactivatio (Is + I2) using fixzero = 0
		Real kI2C_LM = kI2C_TM * fixzero;    
		//'when appropriate, the fast gating can be isolated from the slow inactivatio (Is + I2)
 
		Real kIsb_LM = kIsb_TM * fixzero; 
		//'Rate of slow inactivation is the same, the fast gating can be isolated from the slow inactivatio (Is + I2) using fixzero = 0  
		Real kIsf_LM = kIsf_TM * fixzero; 
		//'Rate of slow inactivation is the same, the fast gating can be isolated from the slow inactivatio (Is + I2) using fixzero = 0

		//state transitions of LSM
		Real _C_LSM = 1.0 - Is_LM - O_LM - I1_LM - I2_LM;  //'conservation in the 5 state model
		LM_C->setValue( _C_LSM ) ;		

		Real dO_LMdt = I1_LM * kI1O_LM + _C_LSM * fC_INa * kC2O_INa - O_LM * (kOC_INa + kOI1_LM); //'rate of change of O state
		Real dI1_LMdt = O_LM * kOI1_LM + _C_LSM * fC_INa * kC2I1_LM - I1_LM * (kI1O_LM + kI1C_LM + kI1I2);   //'rate of change of I1
		Real dI2_LMdt = _C_LSM * fC_INa * kC2I2_LM + I1_LM * kI1I2 + Is_LM * kIsb_LM - I2_LM * (kI2C_LM + kIsf_LM);  //'rate of change of I2
		Real dIs_LMdt = I2_LM * kIsf_LM + _C_LSM * kIsf_LM - Is_LM * 2 * kIsb_LM; 

		vO_TM->setValue( dO_TMdt);
		vI2_TM->setValue( dI2_TMdt );
		vIs_TM->setValue( dIs_TMdt);

		vO_LM->setValue( dO_LMdt);
		vI1_LM->setValue( dI1_LMdt );
		vI2_LM->setValue( dI2_LMdt );
		vIs_LM->setValue( dIs_LMdt);

		Real LMratio = 0.175;
		
		Real pO_INa_TM = (1 - LMratio) * O_TM;
		Real pO_INa_LM = LMratio * O_LM;
 
		Real R = 8.3143; 
		Real Faraday = 96.4867;
		Real tempK = 310;
		Real RTF = R * tempK / Faraday;

		Real B = exp(-1.0 * _Vm / RTF);
		Real C = _Vm / RTF;

		Real GHKNa = C * (Nai->getMolarConc() * 1000.0 - Nae->getMolarConc() * 1000.0 * B) / (1.0 - B);
		Real GHKK = C * (Ki->getMolarConc() * 1000.0 - Ke->getMolarConc() * 1000.0  * B) / (1.0 - B);

		Real INa_TM_Na_cyt = GX->getValue() * GX_T->getValue() * permeabilityNa * GHKNa * pO_INa_TM; //'current component carried by Na+
		Real INa_TM_K_cyt = GX->getValue() * GX_T->getValue() * permeabilityK  * GHKK * pO_INa_TM;  //'current component carried by K+
		Real INa_LSM_Na_cyt = GX->getValue() * GX_L->getValue() * permeabilityNa * GHKNa * pO_INa_LM;  //'current component carried by Na+
		Real INa_LSM_K_cyt = GX->getValue() * GX_L->getValue() * permeabilityK * GHKK * pO_INa_LM;    //'current component carried by K+
 
		cNa->setValue( INa_TM_Na_cyt + INa_LSM_Na_cyt);
		cK->setValue( INa_TM_K_cyt + INa_LSM_K_cyt);

		I->setValue( INa_TM_Na_cyt + INa_LSM_Na_cyt + INa_TM_K_cyt + INa_LSM_K_cyt);
	}

 protected:


	Variable* vO_TM;
	Variable* vI2_TM;
	Variable* vIs_TM;

	Variable* vO_LM;
	Variable* vI1_LM;
	Variable* vI2_LM;
	Variable* vIs_LM;

	Variable* TM_C;
	Variable* TM_Is;
	Variable* TM_O;
	Variable* TM_I2;
	Variable* LM_C;
	Variable* LM_Is;
	Variable* LM_O;
	Variable* LM_I1;
	Variable* LM_I2;
	
	Variable* v;

	Variable* cNa;
	Variable* cK;

	Variable* I;

	Variable* GX;
	Variable* GX_T;
	Variable* GX_L;

	Variable* Nae;
	Variable* Nai;
	Variable* Ke;
	Variable* Ki;

	Real permeabilityNa;
	Real permeabilityK;

 private:
	Real _Vm;


};

LIBECS_DM_INIT( INaLAssignmentProcess, Process );

