// example.cpp

#include <ilcplex/ilocplex.h>
  ILOSTLBEGIN                                            //a macro that is needed for portability (necessary) 

int  main ()
  {
     IloInt   i;                                                    //same as “int i;”
     IloEnv   env;                                              //open cplex environment - always the first operation
				//note the last operation is to close the environment
     try {
        IloModel model(env);		//set up a model object

        IloNumVarArray var(env);		//declare an array of variable objects, for unknowns
        IloRangeArray con(env);		//declare an array of constraint objects
        IloObjective obj = IloMaximize(env);	//model the objective function as max 

        var.add(IloNumVar(env, 0, 4, ILOINT));   //add the three variables to array “var” 
        var.add(IloNumVar(env, 0, 4, ILOINT));   //parameters: IloNumVar(env, lb, ub, type)
        var.add(IloNumVar(env, 0, 1, ILOINT));   //type: ILOFLOAT, ILOINT, ILOBOOL
	 //same as: IloNumVar v0 = cplex.numVar(env, 0, 4, ILOINT); var.add(v0);
//objective function: max x1+x2+x3
	for (i=0; i<3; i++)			//use a loop to write the objective function
	       obj.setLinearCoef(var[i], 1.0);            	//set coefficients of variables
	// x1 +  x3 = 2
	con.add(IloRange(env, -IloInfinity, 2.0));	//write 1st constraint - para: (env, lb, ub)
	con[0].setLinearCoef(var[0],  1.0);	//you just have to set the non-zero coef
	con[0].setLinearCoef(var[2],  1.0);
	// x1 - 3x2 = 3
	con.add(IloRange(env, -IloInfinity, 3.0));
	con[1].setLinearCoef(var[0],  1.0);
	con[1].setLinearCoef(var[1], -3.0);

	model.add(obj);			//add objective function into model
	model.add(con);			//add constraints into model
    
        IloCplex cplex(model);			//create a cplex object and extract the 					//model to this cplex object
        // Optimize the problem and obtain solution.
        if ( !cplex.solve() ) {
           env.error() << "Failed to optimize LP" << endl;
           throw(-1);
        }
        IloNumArray vals(env);		//declare an array to store the outputs
				 //if 2 dimensional: IloNumArray2 vals(env);
        env.out() << "Solution status = " << cplex.getStatus() << endl;
		//return the status: Feasible/Optimal/Infeasible/Unbounded/Error/…
        env.out() << "Solution value  = " << cplex.getObjValue() << endl; 
		//return the optimal value for objective function
        cplex.getValues(vals, var);			//get the variable outputs
        env.out() << "Values        = " << vals << endl;	//env.out() : output stream

     }
     catch (IloException& e) {
        cerr << "Concert exception caught: " << e << endl;
     }
     catch (...) {
        cerr << "Unknown exception caught" << endl;
     }
  
     env.end();				//close the CPLEX environment

     return 0;
  }  // END main
