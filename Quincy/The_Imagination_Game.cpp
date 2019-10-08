#include <stdio.h> 

int Jungle(){
//Begining of Jungle Story 
//printf("-------------------------------\n"); reference line for text length
printf("You and your buddy are driving through\n");
printf("Brazil on your way to the rain forest.\n");
printf("You are sitting beside your friend who is\n");
printf("driving, staring outside in awe of the \n");
printf("beautiful sights.\n");
printf("-------------------------------\n");

//First jungle branch
int j1;
printf("Options: \n");
printf("1. Keep staring outside.\n");
printf("2. Look over to your buddy.\n");
printf("Enter one number: ");
scanf("%d", &j1); 
printf("-------------------------------\n");

while (j1 >2 || j1 < 1)
{
printf("Invalid selection. Try again.\n");
printf("Enter one number: ");
scanf("%d", &j1);
} 


switch(j1){
	case 1:
	{
	printf("You continue staring as the trees and\n");
	printf("bushes pass you by. All of a sudden the\n");
	printf("trees clear and a murky green river is \n");
	printf("flowing wildly. There is a dock with a \n");
	printf("boat that you are approaching.\n");
	printf("-------------------------------\n");
	
	//choice j1_1
	int j1_1;
	printf("Options: \n");
	printf("1. Ask the driver \"Where are we headed?.\"\n");
	printf("2. Pull out your cellphone.\n");
	printf("Enter one number: ");
	scanf("%d", &j1_1); 
	printf("-------------------------------\n");

	while (j1_1 >2 || j1_1 < 1)
	{
	printf("Invalid selection. Try again.\n");
	printf("Enter one number: ");
	scanf("%d", &j1_1);
	} 
	
	
	printf("%d", j1_1);
	}
	break;
	
	case 2:
	{
	printf("You look over to your buddy. It's Daniel.\n");
	printf("He says to you \"Don't worry we'll be\n");
	printf("there soon\"\n");
	printf("-------------------------------\n");
	
	//choice j1_2
	int j1_2;
	printf("Options: \n");
	printf("1. Ask \"Be where soon?\"\n");
	printf("2. Say \"Maybe we shouldn't do this.\"\n");
	printf("Enter one number: ");
	scanf("%d", &j1_2); 
	printf("-------------------------------\n");

	while (j1_2 >2 || j1_2 < 1)
	{
	printf("Invalid selection. Try again.\n");
	printf("Enter one number: ");
	scanf("%d", &j1_2);
	} 
	
	//
	printf("%d",j1_2);
		   
	}
	break;
	
  }
}
int Desert(){
//Begining of Desert Story 
//printf("-------------------------------\n"); reference line for text length
printf("You wake up from the extreme heat \n");
printf("your experiencing. You look up to \n");
printf("clear skies with a bright ball of \n");
printf("fire shining down. You begin to  \n");
printf("feel your body begging for water.\n");
printf("You stand up and dust some sand off.\n");
printf("-------------------------------\n");

// First desert branch
int d1;
printf("Options: \n");
printf("1. Scout the area around you.\n");
printf("2. Check your pockets.\n");
printf("Enter one number: ");
scanf("%d", &d1); 
printf("-------------------------------\n");

while (d1 >2 || d1 < 1)
{
printf("Invalid selection. Try again.\n");
printf("Enter one number: ");
scanf("%d", &d1);
} 

}

int Moutain(){
}

int Islands(){
}

int Forest(){
}


int main()
{

/* Character Setup */
printf("Welcome to The Imagination Game\n");
printf("-------------------------------\n");
printf("Please choose a character name: \n");
char character[50];
gets(character);
printf("You have chosen to be: ");
puts(character);
printf("-------------------------------\n");

// Setting setup
int location;
printf("Choose location: \n");
printf("1. Jungle\n2. Desert\n3. Mountain\n4. Islands\n5. Forest\n");
printf("Enter one number: ");
scanf("%d", &location);

while (location >5 || location < 1)
{
printf("Invalid selection. Try again.\n");
printf("Enter one number: ");
scanf("%d", &location);
} 

//Location setup
switch (location){
	case 1:
	{
	printf("You have selected the Jungle!\n");
	printf("-------------------------------\n");
	Jungle();
	}
	break;

	case 2:
	{
	printf("You have selected the Desert!\n");
	printf("-------------------------------\n");
	Desert();
	}
	break;
		
	case 3:
	{
	printf("You have selected the Mountain!\n");
	printf("-------------------------------\n");
	}
	break;
	
	case 4:
	{
	printf("You have selected the Islands!\n");
	printf("-------------------------------\n");
	}
	break;
	
	case 5:
	{
	printf("You have selected the Forest!\n");
	printf("-------------------------------\n");
	}
	break;
}	 
}




