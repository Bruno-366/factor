#include "factor.h"

void fatal_error(char* msg, CELL tagged)
{
	fprintf(stderr,"Fatal error: %s %ld\n",msg,tagged);
	exit(1);
}

void critical_error(char* msg, CELL tagged)
{
	fprintf(stderr,"Critical error: %s %ld\n",msg,tagged);
	factorbug();
}

void early_error(CELL error)
{
	if(userenv[BREAK_ENV] == F)
	{
		/* Crash at startup */
		fprintf(stderr,"Error during startup: ");
		print_obj(error);
		fprintf(stderr,"\n");
		factorbug();
	}
}

void throw_error(CELL error, bool keep_stacks)
{
	early_error(error);

	throwing = true;
	thrown_error = error;
	thrown_keep_stacks = keep_stacks;
	thrown_ds = ds;
	thrown_rs = rs;

	/* Return to run() method */
	LONGJMP(stack_chain->toplevel,1);
}

void primitive_throw(void)
{
	throw_error(dpop(),true);
}

void primitive_die(void)
{
	factorbug();
}

void general_error(F_ERRORTYPE error, CELL arg1, CELL arg2, bool keep_stacks)
{
	throw_error(make_array_4(userenv[ERROR_ENV],
		tag_fixnum(error),arg1,arg2),keep_stacks);
}

/* It is not safe to access 'ds' from a signal handler, so we just not
touch it */
void signal_error(int signal)
{
	general_error(ERROR_SIGNAL,tag_fixnum(signal),F,false);
}

void type_error(CELL type, CELL tagged)
{
	general_error(ERROR_TYPE,tag_fixnum(type),tagged,true);
}
