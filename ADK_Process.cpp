#include "libecs.hpp"
#include "ContinuousProcess.hpp"

USE_LIBECS;

LIBECS_DM_CLASS( ADK_Process, ContinuousProcess )
{

 public:

	LIBECS_DM_OBJECT( ADK_Process, Process )
	{
		INHERIT_PROPERTIES( Process ); 

		PROPERTYSLOT_SET_GET( Real, KADK_AMP );
		PROPERTYSLOT_SET_GET( Real, KADK_ATP );
		PROPERTYSLOT_SET_GET( Real, KADK_ADP );
		PROPERTYSLOT_SET_GET( Real, KADK_eq );
	}
	
	ADK_Process()
	{
		// do nothing
	}

	SIMPLE_SET_GET_METHOD( Real, KADK_AMP );
	SIMPLE_SET_GET_METHOD( Real, KADK_ATP );
	SIMPLE_SET_GET_METHOD( Real, KADK_ADP );
	SIMPLE_SET_GET_METHOD( Real, KADK_eq );

	virtual void initialize()
	{
		Process::initialize();
		
		VADK_maxf  = getVariableReference( "VADK_maxf" ).getVariable();
		ADP  = getVariableReference( "ADP" ).getVariable();
		ATP  = getVariableReference( "ATP" ).getVariable();
		AMP  = getVariableReference( "AMP" ).getVariable();
		GX  = getVariableReference( "GX" ).getVariable();
	}

	virtual void fire()
	{
	  Real _SizeN_A = getSuperSystem()->getSizeN_A();

	  Real VADK_maxr = VADK_maxf->getValue() * KADK_ADP * KADK_ADP / KADK_ATP / KADK_AMP / KADK_eq;
	  //	  VADK_maxr = VADK_maxf * KADK_ADP * KADK_ADP / KADK_ATP / KADK_AMP / KADK_eq;

	  Real ADK_a = VADK_maxf->getValue() * ATP->getMolarConc()*1000.0 * AMP->getMolarConc()*1000.0 / (KADK_ATP * KADK_AMP);
	  ADK_a -= VADK_maxr * ADP->getMolarConc() * 1000.0 * ADP->getMolarConc() * 1000.0 / (KADK_ADP * KADK_ADP);
	  //	  ADK_a = VADK_maxf * ATP.getValue() * AMP.getValue() / (KADK_ATP * KADK_AMP) - VADK_maxr * ADP.getValue() * ADP.getValue() / (KADK_ADP * KADK_ADP);

	  Real ADK_b = 1.0 + ATP->getMolarConc() * 1000.0 / KADK_ATP + AMP->getMolarConc() * 1000.0 / KADK_AMP + ATP->getMolarConc() * 1000.0 * AMP->getMolarConc() * 1000.0 / (KADK_ATP * KADK_AMP);
	  ADK_b += 2.0 * ADP->getMolarConc() * 1000.0 / KADK_ADP + ADP->getMolarConc() * 1000.0 * ADP->getMolarConc() * 1000.0 / (KADK_ADP * KADK_ADP);
	  //	  ADK_b = 1 + ATP.getValue() / KADK_ATP + AMP.getValue() / KADK_AMP + ATP.getValue() * AMP.getValue() / (KADK_ATP * KADK_AMP) + 2 * ADP.getValue() / KADK_ADP + ADP.getValue() * ADP.getValue() / (KADK_ADP * KADK_ADP);
	  setFlux(GX->getValue() * _SizeN_A * ADK_a / ADK_b / 60000.0 /1000.0);
	  
	  //	  Real V_CK = 16.05 * PCr->getMolarConc()*1000.0 * ADP->getMolarConc()*1000.0 - 9.67e-6 * ATP->getMolarConc()*1000.0 * Cr->getMolarConc()*1000.0;
	  //	  setFlux(V_CK * _SizeN_A / 60000.0 / 1000.0);
	  //	  setFlux(CK_a / CK_b );
	  //V_CK.setValue(CK_a / CK_b / unit);
	  
	  // ducky

	  // T->setValue( Tt->getValue() - TCa->getValue() - TCaCB->getValue() - TCB->getValue() );
	}

 protected:

	Variable* VADK_maxf;
	Variable* AMP;
	Variable* ADP;
	Variable* ATP;
	Variable* GX;

	Real KADK_ATP;
	Real KADK_ADP;
	Real KADK_AMP;
	Real KADK_eq;

 private:


};

LIBECS_DM_INIT( ADK_Process, Process );

