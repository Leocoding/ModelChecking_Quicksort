/**********************************
*	Projet de Model Checking  *
*	M1 Informatique SSI       *
*	Novembre 2021             *
*	@author : Léo Menudé      *
*/*********************************

// MACROS

// Type des éléments du tableau 
#define ELEM_TYPE byte
// Nombre de bits pour les variables de positions
#define BITS_I 3
// Nombre d'élément du tableau à trié
#define N 5
// Valeur maximal d'une valeur dans le tableau
#define RAND_MAX_VAL 255
// Arguments quicksort
#define FIRST_POS 0
#define LAST_POS 5

// ======  1 seule macro à la fois =====

// macro de vérification du tri
#define VERIFY_SORT true

// macro de vérafication de partition
#define VERIFY_PARTITION false

// =====================================

// VARIABLES

// Tableau
ELEM_TYPE tab[N]; 

// Pointeurs de cases du tableau 
unsigned i : BITS_I = 0;
unsigned j : BITS_I = 0;
unsigned pivot : BITS_I = 0;

// Zone de mémoire pour échanger les valeurs de deux variables (swap)
unsigned mem : BITS_I = 0;

// Channels
chan partRet[0];

// PATRONS DE PROCESSUS

proctype quicksort(byte l; byte h) {
	assert(l >= 0 && h >=0);
	do
		:: l < h ->
			run partition(l,h);
			
		:: else -> break;
	od
}

proctype partition(byte l; byte h) {
	pivot = tab[h];
	i = l - 1;
	j = i;
	do
		:: (j <= h) -> 
			if (pivot >= tab[j]) then
				i = i + 1;
				mem = tab[j];
				tab[j] = tab[i];
				tab[i] = mem;
			fi
			j = j + 1;
		:: else -> break;
	od
	mem = tab[h];
	tab[h] = tab[i+1];
	tab[i+1] = mem;
	partRet!i+1;
}

proctype randomizer() {
	atomic {
		byte k = 0;
		do
			:: (k < N) ->
				byte r = 0;
				do
					:: r < RAND_MAX_VAL -> r++;
					:: r > 0 -> r--;
					:: break;
				od
				tab[k] = r;
				k++;
			:: else -> break;
		od
	}
}

// INITIALISATION

init {
	run randomizer();
	run quicksort(FIRST_POS, LAST_POS);
}
