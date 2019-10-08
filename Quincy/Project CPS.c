#include <stdio.h>
#include <math.h>
int
main (void)
{
	int lake,beach,count;
	double i,sum,ecoli,average;
	FILE *in;
	in=fopen("aug15.data","r");
	printf("Lake      Beach                Average E-Coli Level         Recomendation\n");
	printf("----      -----                --------------------         -------------\n");
	/*Begin reading data from the input file*/
	while(!(feof(in)))
	 {
		/*Read first value*/
		fscanf(in,"%d", &lake);
		sum=0;
		average=0;
		switch(lake)
		 {
			case 1:
				printf("Ontario   ");
				/*Read second value*/
				fscanf(in,"%d", &beach);
				switch(beach) 
				{
					case 100:
						printf("Kew Beach           ");
						/*Read third value*/
						fscanf(in,"%d",&count);
						if( count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							/*Continue reading values until reaching the next set of data*/
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							/*Read sample values and find sum*/
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							/*Calculate average*/
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}	 	 	 	 	 	 
					break;
					case 101:
						printf("Sunnyside Beach     ");
						fscanf(in,"%d",&count);
						if( count>=3) 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
						else
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
					break;
					case 103:
						printf("Sandbanks           ");
						fscanf(in,"%d",&count);
						if( count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
							
					break;
					default:
						printf("invalid");
					break;
				}
				
			break;
			case 2:
				printf("Erie      ");
				fscanf(in,"%d", &beach);
				switch(beach) 
				{
					case 201:
						printf("Port Dover          ");
						if( count>=3) 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
						else
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
					break;
					case 202:
						printf("Port Burwell        ");
						fscanf(in,"%d",&count);
						if( count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
					break;
					case 203:
						printf("Crystal Beach       ");
						fscanf(in,"%d",&count);
						if( count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
						break;
					default:
						printf("invalid\n");
					break;
					}
			break;
			case 3:
				printf("Huron     ");
				fscanf(in,"%d", &beach);
				switch(beach) 
				{
					case 301:
						printf("Goderich            ");
						fscanf(in,"%d",&count);
						if( count>=3) 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
						else
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) {
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
					break;
					case 302:
						printf("Sauble Beach        ");
						fscanf(in,"%d",&count);
						if( count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
						if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
					break;
					case 303:
						printf("Kincardine          ");
						fscanf(in,"%d",&count);
						if( count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++)
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
					break;
					default:
						printf("invalid\n");
					break;
					}
			break;
			case 4:
				printf("Muskoka   ");
				fscanf(in,"%d",&beach);
				switch(beach) {
					case 401:
						printf("Muskoka Beach       ");
						fscanf(in,"%d",&count);
						if(count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
					break;
					default:
						printf("error");
					break;
				}
			break;
			case 5:
				printf("Simcoe    ");
				fscanf(in,"%d",&beach);
				switch(beach) 
				{
					case 501:
						printf("Sibbald Point       ");
						fscanf(in,"%d",&count);
						if(count<=3)
						{
							printf(" --------			    INSUFFICIENT DATA\n");
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
						}
						else 
						{
							for(i=1;i<=count;i++) 
							{
								fscanf(in,"%lf",&ecoli);
								sum=sum+ecoli;
							}
							average=sum/count;
							printf("%6.2lf            ", average);
							if(average<=50)
								printf("	    OPEN\n");
							else
								printf("	    CLOSED\n");
						}
					break;
					default:
						printf("error");
					break;
				}
			break;
			
		}
	}
	fclose (in);
	printf("\n\nReport from aug15.data generated by Mahal Mammadli."); 
	return(0);
}

