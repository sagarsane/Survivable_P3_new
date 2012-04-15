
#include <ilcplex/ilocplex.h>
  ILOSTLBEGIN                                            //a macro that is needed for portability (necessary) 

int  main ()
  { 
     cout << "Before Everything!!!" << "\n";
     IloEnv env;
     IloInt   i,j,varCount1,varCount2,varCount3,conCount;                                                    //same as “int i;”
     IloInt k,w,K,W,E,l,P,N;
     try {
	N = 9;
	K=W=50;
        IloModel model(env);		//set up a model object

	IloNumVarArray var1(env);// = IloNumVarArray(env,K*W*N*N);
//	IloNumVarArray var2(env);
	IloNumVarArray var3(env);// = IloNumVarArray(env,W);		//declare an array of variable objects, for unknowns 
	IloNumVar W_max(env, 0, W, ILOINT);
	//var1: c_ijk_w
	//var2: X_ijk_l
	IloRangeArray con(env);// = IloRangeArray(env,N*N + 3*w);		//declare an array of constraint objects
        IloNumArray2 t = IloNumArray2(env,9); //Traffic Demand
        IloNumArray2 e = IloNumArray2(env,9); //edge matrix
	cout << "HERE????" << "\n";
        //IloObjective obj;

	cout << "Here\n";	
	
	for(i=0;i<9;i++)	
		e[i] = IloNumArray(env,9);

	e[0][1] = e[0][2] = e[0][5] = e[0][6] = IloNum(1);
	e[1][0] = e[1][2] = e[1][4] = e[1][7] = IloNum(1);
	e[2][0] = e[2][1] = e[2][3] = e[2][8] = IloNum(1);
	e[3][2] = e[3][5] = e[3][4] = e[3][8] = IloNum(1);
	e[4][1] = e[4][3] = e[4][5] = e[4][7] = IloNum(1);
	e[5][0] = e[5][3] = e[5][4] = e[5][6] = IloNum(1);
	e[6][0] = e[6][5] = e[6][7] = e[6][8] = IloNum(1);
	e[7][1] = e[7][6] = e[7][4] = e[7][8] = IloNum(1);
	e[8][2] = e[8][4] = e[8][6] = e[8][7] = IloNum(1);
	
	for(i=0;i<9;i++){
		t[i] = IloNumArray(env,9);
		for(j=0;j<9;j++){
			if(i == j)
				t[i][j] = IloNum(0);
			else if(i != j)
				t[i][j] = IloNum((i + j)%5);
		}
	}
	
	printf("ikde\n");
	//Minimize W_max
        IloObjective obj=IloMinimize(env);
	obj.setLinearCoef(W_max, 1.0);

	cout << "here khali\n"; 
	//Setting var1[] for Demands Constraints
	for(i=0;i<9;i++)
		for(j=0;j<9;j++)
			for(k=0;k<K;k++)
				for(w=0;w<W;w++)
					var1.add(IloNumVar(env, 0, 1, ILOINT));
	//c_ijk_w variables set.
	for(i=0;i<N*N*K*W;i++)
		var1[i];

	//Setting var2[] for Wavelength Constraints_1	
	//E = 10;
	/*for(i=0;i<9;i++)
            	for(j=0;j<9;j++)
        	       for(k=0;k<K;k++)
               //                 for(w=0;w<E;w++)
                             var2.add(IloNumVar(env, 0, 1, ILOINT));*/

	for(w = 0;w < W;w++)
		var3.add(IloNumVar(env, 0, 1, ILOINT)); //Variables for u_w
	cout<<"variables ready\n";
	//IloRangeArray con1 = IloRangeArray(env, 1);
        //con1.add(IloRange(env, 0, 3));
       //con1[0].setLinearCoef(IloNumVar(env,0,1,ILOINT),1.0);
        //cout << "Dumy Set\n";
	conCount = 0;
	for(i=0;i<9;i++)
		for(j=0;j<9;j++){
			con.add(IloRange(env, 0, t[i][j]));
			varCount1 = 0;
			for(k=0;k<K;k++)
				for(w=0;w<W;w++){
					con[conCount].setLinearCoef(var1[varCount1++],1.0);
					//cout << "Before Adding Constraint\n";
					//con[1].setLinearCoef(IloNumVar(env, 0, 1, ILOINT), 1.0);
					//cout<<"coef set "<<varCount1;
				}
			conCount++;
		}//Adding Demands Constraints to con
	cout<<"1st\n";

	IloInt z= 0;
	for(w=0;w<W;w++){
		con.add(IloRange(env, -IloInfinity, 1));
		varCount1 = 0;
		for(i=0;i<9;i++)
			for(j=0;j<9;j++)
				for(k=0;k<K;k++){
					//refer mixblend.cpp
					//IloNumVarArray e(env, K);
					//	e[k] = IloNumVar(env, var1[varCount1] * var2[varCount2], var1[varCount1] * var2[varCount2]);
					con[conCount].setLinearCoef(var1[varCount1++],e[i][j]);
//					varCount1++;
					//IloInt temp = var1[varCount1++] * var2[varCount2++];
				}
		conCount++;
	}
	cout<<"2nd\n";

	//Adding Wavelength Constraints_1 to con
	P = N * (N-1) * K;	
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
	cout<<"3rd\n";
	
	varCount3 = 0;
	con.add(IloRange(env, 0, IloInfinity));
	con[conCount].setLinearCoef(W_max, 1.0);
	for(w = 0;w < W ;w++){
 		con[conCount].setLinearCoef(var3[varCount3++], -1.0 * w);
	}
	cout<<"after constraints\n";

	
	//model.add(obj);			//add objective function into model
        model.add(IloMinimize(env,obj));
	model.add(con);			//add constraints into model
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
