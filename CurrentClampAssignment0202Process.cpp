#include "libecs.hpp"
#include "Process.hpp"

USE_LIBECS;

LIBECS_DM_CLASS( CurrentClampAssignment0202Process, Process )
{

 public:

	LIBECS_DM_OBJECT( CurrentClampAssignment0202Process, Process )
	{
		INHERIT_PROPERTIES( Process ); 

		PROPERTYSLOT_SET_GET( Real, amplitude );
		PROPERTYSLOT_SET_GET( Real, onset );
		PROPERTYSLOT_SET_GET( Real, offset );
		PROPERTYSLOT_SET_GET( Real, interval );
	}
	
	CurrentClampAssignment0202Process()
		:
		amplitude( 0.0 ),
		onset( 50.0 ),
		offset( 52.0 ),
		interval( 400.0 )
	{
		// do nothing
	}

	SIMPLE_SET_GET_METHOD( Real, amplitude );
	SIMPLE_SET_GET_METHOD( Real, onset );
	SIMPLE_SET_GET_METHOD( Real, offset );
	SIMPLE_SET_GET_METHOD( Real, interval );
	
	virtual void initialize()
	{
		Process::initialize();
		
		I   = getVariableReference( "I" ).getVariable();
		Cm   = getVariableReference( "Cm" ).getVariable();
		t    = getVariableReference( "t" ).getVariable();

		if ( onset >= t->getValue() ) {
		
			_nextOnset = onset;
		
		} else {

			_nextOnset = onset + floor( ( t->getValue() - onset ) / interval ) * interval;
		}

		_nextOffset = _nextOnset + offset - onset;

	}

	virtual void fire()
	{
		_t = t->getValue();

		if ( _t >= _nextOnset && _t < _nextOffset ) {

			I->setValue( amplitude * Cm->getValue() );

		} else I->setValue( 0.0 );

		if ( _t > _nextOffset ) {
			_nextOnset  += interval;
			_nextOffset += interval;
		}
	}

 protected:

	Variable* I;
	Variable* Cm;
	Variable* t;

	Real amplitude;
	Real onset;
	Real offset;
	Real interval;

 private:
	
	Real _t;
	Real _nextOnset;
	Real _nextOffset;
};

LIBECS_DM_INIT( CurrentClampAssignment0202Process, Process );

