#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<fcntl.h>
#include<math.h>
#include<stdint.h>
#include<string.h>
#include<time.h>
#include<sys/time.h>
#include<sys/resource.h>

typedef struct Edges{
	int a,b;
}edge;

edge e[5];
int ei;
int toremove(int a, int b){
	int i;
	for(i=0;i<ei;i++)
	{
		//printf("a: %d \t b: %d  E[%d].a: %d\t E[%d].b: %d\n",a,b,i,e[i].a,i,e[i].b);
		if(e[i].a == a && e[i].b == b) //we have to remove this
		{
			printf("a: %d \t b: %d  E[%d].a: %d\t E[%d].b: %d\n",a,b,i,e[i].a,i,e[i].b);
			printf("Returning 1\n");
			return 1;
		}
	}
	//printf("Returning 0\n");
	return 0;
}

int main(int argc, char *argv[]){
	FILE *file,*graph,*updated_graph;
	
	int i,j;
	char edges[128],*eptr;
	file = fopen(argv[1],"r"); //input file
	graph = fopen(argv[2],"r"); //Original Graph
	updated_graph = fopen("tempGraph.txt","w");
	fgets(edges, sizeof(edges), file);
	eptr = strtok(edges, " ");
	ei = 0;
	int ecnt = 0;
	do{
		//printf("%s ",eptr);
		//if(!isdigit(atoi(eptr)))
		//	break;
		if(ecnt == 0){
			e[ei].a = atoi(eptr);
			ecnt++;
			eptr = strtok(NULL, " ");
			continue;
		}
		else if(ecnt == 1){
			e[ei].b = atoi(eptr);
			ecnt++;
			ei++;
			eptr = strtok(NULL, " ");
			continue;
		}
		else if(ecnt == 2){
			ecnt = 0;
		}
		
		
	}while(eptr != NULL);
	
	printf("To be removed: \n");
	for(j=0;j<ei;j++)
		printf("%d %d\n",e[j].a,e[j].b);
	//put edges line parsed into edge[]
	

		
	int ti,tj,tc,tcap,nodes;
	fscanf(graph,"%d\n",&nodes);
	fprintf(updated_graph,"%d\n",nodes);
	while(fscanf(graph,"%d %d %d %d",&ti,&tj,&tc,&tcap)!=EOF){
		if(toremove(ti,tj) == 0) // edge not to be removed, so keep it as it is
		{
			fprintf(updated_graph,"%d %d %d %d\n",ti,tj,tc,tcap);
		}
	}
	fclose(updated_graph);
	
	//fgets(line, sizeof(line), file);
	//fputs(line,sizeof(line), file);
	//printf("%s\n",line);

	fclose(file);
	fclose(graph);	
	
	
}
