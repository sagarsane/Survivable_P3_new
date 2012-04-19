#include <fstream>
#include <sstream>
#include <string>
#include <ilcplex/ilocplex.h>
  ILOSTLBEGIN                                            //a macro that is needed for portability (necessary) 
typedef IloArray<IloNumArray> Xjk;
typedef IloArray<Xjk> Xijk;
typedef IloArray<Xijk> Xijkl; //xijkl[l][i][j][k]

int  main (int argc, char *argv[])
{ 
     ifstream infile;
     FILE *file;
     infile.open("Proj3_op.txt");
     if(!infile){
	cerr << "Unable to open the file\n";
	exit(1);
     }
     
     cout << "Before Everything!!!" << "\n";
     IloEnv env;
     IloInt   i,j,varCount1,varCount2,varCount3,conCount;                                                    //same as “int i;”
     IloInt k,w,K,W,E,l,P,N,L;
     IloInt tab, newline, val; //from file
     char line[2048];
     try {
	N = 4;
	K = 2;
	W = (IloInt)atoi(argv[1]);
	L = 12;
        IloModel model(env);		//set up a model object

	IloNumVarArray var1(env);// = IloNumVarArray(env,K*W*N*N);
//	IloNumVarArray var2(env);
	IloNumVarArray var3(env);// = IloNumVarArray(env,W);		//declare an array of variable objects, for unknowns 
	IloNumVar W_max(env, 0, W, ILOINT);
	//var1: c_ijk_w
	//var2: X_ijk_l
	IloRangeArray con(env);// = IloRangeArray(env,N*N + 3*w);		//declare an array of constraint objects
        IloNumArray2 t = IloNumArray2(env,N); //Traffic Demand
        IloNumArray2 e = IloNumArray2(env,N); //edge matrix
        //IloObjective obj;

	//Define the Xijk matrix
	Xijkl xijkl_m(env, L);
	for(l=0;l<L;l++){
		xijkl_m[l] = Xijk(env, N);
		for(i=0;i<N;i++){
			xijkl_m[l][i] = Xjk(env, N);
			for(j=0;j<N;j++){
				xijkl_m[l][i][j] = IloNumArray(env, K);
			}
		}
	}

	//reset everything to zero here
	for(l=0;l<L;l++)
		for(i=0;i<N;i++)
			for(j=0;j<N;j++)
				for(k=0;k<K;k++)
					xijkl_m[l][i][j][k] = 0;	

	/*L = { 0 1, 0 2, 0 3, 1 0, 1 2, 1 3, 2 0, 2 1, 2 3, 3 0, 3 1, 3 2} */
	//l = 0 , for_all i,j,k
	xijkl_m[0][0][1][0] = 1; // k = 0
	xijkl_m[0][0][2][1] = xijkl_m[0][0][3][1] = xijkl_m[0][2][1][1] = xijkl_m[0][3][1][1] = 1; // k = 1

	//l = 1
	xijkl_m[1][0][2][0] = 1; // k = 0
	xijkl_m[1][0][1][1] = xijkl_m[1][1][2][1] = xijkl_m[1][3][2][1] = 1; //k=1
	
	//l = 2
	xijkl_m[2][0][3][0] = 1; //k=0
	xijkl_m[2][1][3][1] = xijkl_m[2][2][3][1] = 1; //k=1

	//l=3
	xijkl_m[3][1][0][0] = 1; //k=0
	xijkl_m[3][1][2][1] = xijkl_m[3][1][3][1] = xijkl_m[3][2][0][1] = xijkl_m[3][3][0][1] = 1;//k = 1
	
	//l=4 
	xijkl_m[4][1][2][0] = 1;//k=0
	xijkl_m[4][0][2][1] = xijkl_m[4][1][0][1] = 1;

	//l=5
	xijkl_m[5][1][3][0] = 1;
	xijkl_m[5][0][3][1] = 1;

	//l=6
	xijkl_m[6][2][0][0] = 1;
	xijkl_m[6][1][0][1] = xijkl_m[6][2][1][1] = xijkl_m[6][2][3][1] = 1;
	
	//l=7
	xijkl_m[7][2][1][0] = 1;
	xijkl_m[7][0][1][1] = xijkl_m[7][2][0][1] = 1;

	//l=8
	xijkl_m[8][2][3][0] = 1;

	//l=9
	xijkl_m[9][3][0][0] = 1;
	xijkl_m[9][3][1][1] = xijkl_m[9][3][2][1] = 1;

	//l=10
	xijkl_m[10][3][1][0] = 1;
	xijkl_m[10][3][0][1] = 1;

	//l = 11
	xijkl_m[11][3][2][0] = 1;
	
/*	string linetmp;	
	IloInt xi,xj,xk;
	xi = xj = xk = 0;
	int path_no = 0;
	while(infile.getline(line, 2048)){
		linetmp = line;
		//cout << "Current line: " << linetmp << endl; 
		if(linetmp.find("\n") == linetmp.length()-1){
			//cout << "Line: " << linetmp << endl;
			path_no = 0;
			continue;
		}
		istringstream iss(linetmp);
		string sub_a[3];//max
		int s_cnt = 0;
		do{
			string sub;
			getline(iss, sub, '\t');
			//cout << "*" << sub;
			if(!sub.empty()){
				sub_a[s_cnt++] = sub;
			}
		}while(!iss.eof());
		//process a line
		cout << "Cnt:"  << s_cnt << endl;
		int ii;
		for(ii=0;ii<s_cnt;ii++){
			  	if(ii+1 == s_cnt)
                                        continue;

				cout << "Path: " << path_no << "\t\t";
				IloInt xi,xj;
                                int ti,tj;
                                istringstream(sub_a[ii]) >> ti;
                                istringstream(sub_a[ii+1]) >> tj;
				cout << ti << " " << tj << "\t";
                                xi = (IloInt)ti-1;
                                xj = (IloInt)tj-1;
                                xijk_matrix[xi][xj][path_no] = 1;
			
		}
		cout << "\n";
		if(path_no == 0)
			path_no = 1;
		else	
			path_no = 0;
	}
*/
	cout<<"bahre\n";
	
	/*for(i=0;i<N;i++)	
		e[i] = IloNumArray(env,N);

	e[0][1] = e[0][2] = e[0][5] = e[0][6] = IloNum(1);
	e[1][0] = e[1][2] = e[1][4] = e[1][7] = IloNum(1);
	e[2][0] = e[2][1] = e[2][3] = e[2][8] = IloNum(1);
	e[3][2] = e[3][5] = e[3][4] = e[3][8] = IloNum(1);
	e[4][1] = e[4][3] = e[4][5] = e[4][7] = IloNum(1);
	e[5][0] = e[5][3] = e[5][4] = e[5][6] = IloNum(1);
	e[6][0] = e[6][5] = e[6][7] = e[6][8] = IloNum(1);
	e[7][1] = e[7][6] = e[7][4] = e[7][8] = IloNum(1);
	e[8][2] = e[8][4] = e[8][6] = e[8][7] = IloNum(1);*/
	
	for(i=0;i<N;i++){
		t[i] = IloNumArray(env,N);
		for(j=0;j<N;j++){
			if(i == j)
				t[i][j] = IloNum(0);
			else if(i != j)
				t[i][j] = IloNum((i+j)%5);
		}
	}
	
	printf("ikde\n");
	//Minimize W_max
        IloObjective obj=IloMinimize(env);
	obj.setLinearCoef(W_max, 1.0);

	cout << "here khali\n"; 
	//Setting var1[] for Demands Constraints
	for(i=0;i<N;i++)
		for(j=0;j<N;j++)
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
		var3.add(IloNumVar(env, 0, W, ILOINT)); //Variables for u_w
	cout<<"variables ready\n";
	//IloRangeArray con1 = IloRangeArray(env, 1);
        //con1.add(IloRange(env, 0, 3));
       //con1[0].setLinearCoef(IloNumVar(env,0,1,ILOINT),1.0);
        //cout << "Dumy Set\n";
	conCount = 0;
	for(i=0;i<N;i++)
		for(j=0;j<N;j++){
			con.add(IloRange(env, t[i][j], t[i][j]));
			//varCount1 = 0;
			for(k=0;k<K;k++)
				for(w=0;w<W;w++){
					con[conCount].setLinearCoef(var1[i*N*W*K+j*W*K+k*W+w],1.0);
					//cout << "Before Adding Constraint\n";
					//con[1].setLinearCoef(IloNumVar(env, 0, 1, ILOINT), 1.0);
					//cout<<"coef set "<<varCount1;
				}
			conCount++;
		}//Adding Demands Constraints to con
	cout<<"1st\n";

	IloInt z= 0;
	for(w=0;w<W;w++){
		for(l=0;l<L;l++){		
			con.add(IloRange(env, -IloInfinity, 1));
			for(i=0;i<N;i++){
				for(j=0;j<N;j++){
					for(k=0;k<K;k++){
						con[conCount].setLinearCoef(var1[i*N*W*K+j*W*K+k*W+w],xijkl_m[l][i][j][k]);
					}
				}
			}
			conCount++;
		}
	}
	cout<<"2nd\n";

	//Adding Wavelength Constraints_1 to con
	P = N * (N-1) * K;	
	for(w=0;w<W;w++){
		con.add(IloRange(env, -IloInfinity, 0));
		varCount1 = 0;
                for(i=0;i<N;i++)
                       for(j=0;j<N;j++)
                               for(k=0;k<K;k++){
					con[conCount].setLinearCoef(var1[i*N*W*K+j*W*K+k*W+w],1.0);
                               }
		con[conCount].setLinearCoef(var3[w],-P);
                conCount++;

	}
	cout<<"3rd\n";
	
	varCount3 = 0;
	con.add(IloRange(env, 0, IloInfinity));
	con[conCount].setLinearCoef(W_max, 1.0);
	for(w = 0;w < W ;w++){
 		con[conCount].setLinearCoef(var3[w], -1.0 * w);
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
