
#include <ilcplex/ilocplex.h>
  ILOSTLBEGIN                                            //a macro that is needed for portability (necessary) 

int  main ()
  { 
     cout << "Before Everything!!!" << "\n";
     IloEnv env;
     IloInt   i,j,varCount1,varCount2,varCount3,conCount;                                                    //same as “int i;”
     IloInt k,w,K,W,E,l,P,N;
     try {
        IloModel model(env);		//set up a model object

        IloNumVarArray var1(env),var2(env),var3(env);		//declare an array of variable objects, for unknowns 
	IloNumVar W_max(env, 0, 10, ILOINT);
	//var1: c_ijk_w
	//var2: X_ijk_l
        IloRangeArray con(env);		//declare an array of constraint objects
        IloNumArray2 t(env); //Traffic Demand
	cout << "HERE????" << "\n";
        //IloObjective obj;

	cout << "Here";	

	for(i=0;i<9;i++)
		for(j=0;j<9;j++){
			if(i == j)
				t[i][j] = 0;
			else if(i != j)
				t[i][j] = 3;
		}
	
	//Minimize W_max
        IloObjective obj;
	obj.setLinearCoef(W_max, 1.0);

	
	//Setting var1[] for Demands Constraints
	K = W = 10;
	//for(i=0;i<9;i++)
	//	for(j=0;j<9;j++)
	for(k=0;k<K;k++)
		for(w=0;w<W;w++)
			var1.add(IloNumVar(env, 0, 1, ILOINT));
	//c_ijk_w variables set.
	

	//Setting var2[] for Wavelength Constraints_1	
	E = 10;
	for(i=0;i<9;i++)
            	for(j=0;j<9;j++)
        	       for(k=0;k<K;k++)
               //                 for(w=0;w<E;w++)
                             var2.add(IloNumVar(env, 0, 1, ILOINT));

	for(w = 0;w < W;w++)
		var3.add(IloNumVar(env, 0, 1, ILOINT)); //Variables for u_w

	

	conCount = -1;
	for(i=0;i<9;i++)
		for(j=0;j<9;j++){
			con.add(IloRange(env, t[i][j], t[i][j]));
			conCount++;
			varCount1 = 0;
			for(k=0;k<K;k++)
				for(w=0;w<W;w++){
					con[conCount].setLinearCoef(var1[varCount1++],1.0);
				}
			
		}//Adding Demands Constraints to con

	IloInt z= 0;
	for(w=0;w<W;w++)
             for(l=0;l<E;l++){
			con.add(IloRange(env, -IloInfinity, 1));
			varCount2 = 0;
			varCount1 = 0;
			for(i=0;i<9;i++)
				for(j=0;j<9;j++)
					for(k=0;k<K;k++){
						//refer mixblend.cpp
						//IloNumVarArray e(env, K);
						//	e[k] = IloNumVar(env, var1[varCount1] * var2[varCount2], var1[varCount1] * var2[varCount2]);
						varCount1++;
						varCount2++;
						con[conCount].setLinearCoef(var1[varCount1], 1.0);
						//IloInt temp = var1[varCount1++] * var2[varCount2++];
					}
			conCount++;
		}//Adding Wavelength Constraints_1 to con
	N = 9;
	P = N * (N-1) * K;	
	varCount3=0;
	for(w=0;w<W;w++){
		con.add(IloRange(env, -IloInfinity, var3[varCount3++] * P));
		varCount1 = 0;
                for(i=0;i<9;i++)
                       for(j=0;j<9;j++)
                               for(k=0;k<K;k++){
                                      con[conCount].setLinearCoef(var1[varCount1++],1.0);
                               }
                        conCount++;

	}
	
	varCount3 = 0;
	for(w = 0;w < W ;w++){
		con.add(IloRange(env, var3[varCount3++] * (w+1) ,IloInfinity));
		con[conCount++].setLinearCoef(W_max,1.0);
	}

	
	//model.add(obj);			//add objective function into model
        model.add(IloMinimize(env,obj));
	model.add(con);			//add constraints into model
   	cout << "here\n"; 
        IloCplex cplex(model);			//create a cplex object and extract the 					//model to this cplex object
        // Optimize the problem and obtain solution.
        if ( !cplex.solve() ) {
           env.error() << "Failed to optimize LP" << endl;
           throw(-1);
        }
        IloNumVar vals(env);		//declare an array to store the outputs
				 //if 2 dimensional: IloNumArray2 vals(env);
        env.out() << "Solution status = " << cplex.getStatus() << endl;
		//return the status: Feasible/Optimal/Infeasible/Unbounded/Error/…
        env.out() << "Solution value  = " << cplex.getObjValue() << endl; 
		//return the optimal value for objective function
        //cplex.getValues(vals, W_max);			//get the variable outputs
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
