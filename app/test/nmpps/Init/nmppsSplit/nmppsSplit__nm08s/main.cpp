#include "nmpp.h"
#include "minrep.h"




/////////////////////////////////////////////////////////////////////////
nm64s *L0;
nm64s *L1;
nm64s *G0;
nm64s *G1;
 int KB=1024/8;
 int SizeL0=60*KB;
 int SizeL1=60*KB;

 int SizeG0=60*KB;
 int SizeG1=60*KB;

//! \fn void nmppsSet_8s(nm8s*,char,int)

int main()
{
	

	L0=nmppsMalloc_64s(SizeL0);
	L1=nmppsMalloc_64s(SizeL1);
	G0=nmppsMalloc_64s(SizeG0);
	G1=nmppsMalloc_64s(SizeG1);
	if ((L0==0)||(L1==0)||(G0==0)||(G1==0)) return -1;


	unsigned int crc = 0;

	int	charMaxSize=2048;
	charMaxSize=MIN(charMaxSize,LONG2char(SizeL0));
	charMaxSize=MIN(charMaxSize,LONG2char(SizeG0));
//	nmppsSet_32s((nm32s*)L0,(int)0xCCCCCCCC,(SizeL0*2));
	nmppsRandUniform_32u((nm32u*)L0,SizeL0*2);

	for(int nSize=16;nSize<=charMaxSize;nSize+=16*NMPP_MIN_REP)
	{
		nmppsSplit_8s((nm8s*)L0,(nm8s*)L1,(nm8s*)G1,nSize,(nm8s*)G0);	
		nmppsCrcAcc_32u((nm32u*)L0,MIN(char2INT(nSize)+128,LONG2INT(SizeL0)),&crc);
	}

	nmppsFree(L0);
	nmppsFree(L1);
	nmppsFree(G0);
	nmppsFree(G1);

	

	return crc>>2;
}
