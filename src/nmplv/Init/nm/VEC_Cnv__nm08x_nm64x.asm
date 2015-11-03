//------------------------------------------------------------------------
//
//  $Workfile:: Cnv08to64.as $
//
//  ��������-��������� ����������
//
//  Copyright (c) RC Module Inc.
//
//  $Revision: 1.1 $      $Date: 2004/11/22 13:50:08 $
//
//! \if file_doc
//!
//! \file   Cnv08to64.asm
//! \author ������ �������
//! \brief  ������� �������������� ��������� �������.
//!
//! \endif 
//!
//------------------------------------------------------------------------

//#include "vConvert.h"

extern vec_vsum_data_0:label;

data ".data"
    WConvert8to64: long[8*8] =  (			1hl, 0hl dup 7,	// Extract 1-st byte
								 0hl	  ,	1hl, 0hl dup 6,	// Extract 2-rd byte
								 0hl dup 2,	1hl, 0hl dup 5,	// Extract 3-rd byte
								 0hl dup 3,	1hl, 0hl dup 4,	// Extract 4-rd byte
								 0hl dup 4,	1hl, 0hl dup 3,	// Extract 5-rd byte
								 0hl dup 5,	1hl, 0hl dup 2,	// Extract 6-rd byte
								 0hl dup 6,	1hl, 0hl,		// Extract 7-rd byte
								 0hl dup 7,	1hl	     		// Extract 8-rd byte);
								 );
end ".data";


begin ".text_nmplv"
/////////////////////////////////////////////////////////////////////////////////

//! \fn void nmppsCnv_8s64s(nm8s* pSrcVec, nm64s* pDstVec, int nSize)
//!
//! \perfinclude _nmppsCnv_8s64s.html


global _nmppsCnv_8s64s:label;
<_nmppsCnv_8s64s>
.branch;
   	delayed goto JumpFromSigned;
		nb1 = 00000000h;

/////////////////////////////////////////////////////////////////////////////////

		

//! \fn void nmppsCnv_8u(nm8u* pSrcVec, nm64u* pDstVec, int nSize)
//!
//! \perfinclude _nmppsCnv_8u.html

global _nmppsCnv_8u:label;
<_nmppsCnv_8u>
.branch;
	nb1 = 80808080h;
	<JumpFromSigned>
	ar5 = WConvert8to64 set;
	sb  = 02020202h;
	rep 32 wfifo =[ar5++],ftw;//First part

	ar5 = sp - 2;
	push ar0,gr0	with gr0=false;
	push ar5,gr5	with gr0++;	
	push ar6,gr6	with gr0++;		//gr0=2

	ar0 = [--ar5]	with gr6=gr0;	// pSrcVec , gr6=2
	ar6 = [--ar5] ;					// pDstVec
	gr5 = [--ar5] ;					// nSize in 8-bit elements 
	gr7 = ar0		with gr5>>=3;
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
		
	delayed call vec_vsum_data_0;
		wtw;
		ftw;		
		
	ar6 = ar5		with gr6>>=3;	// gr6=2
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
	ar0 = gr7;
	delayed call vec_vsum_data_0;
		wtw;
		ftw;
		

	ar6 = ar5		with gr6>>=3;	// gr6=2
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
	ar0 = gr7;
	delayed call vec_vsum_data_0;
		wtw;
		ftw;

	ar6 = ar5		with gr6>>=3;	// gr6=2
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
	delayed call vec_vsum_data_0;
		ar0 = gr7;
		wtw;


	ar6 = WConvert8to64 + 2*8*4 set;//Second part
	rep 32 wfifo =[ar6++],ftw;


	ar6 = ar5		with gr6>>=3;	// gr6=2
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
	ar0 = gr7;
	delayed call vec_vsum_data_0;
		wtw;
		ftw;
		

	ar6 = ar5		with gr6>>=3;	// gr6=2
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
	ar0 = gr7;
	delayed call vec_vsum_data_0;
		wtw;
		ftw;

	ar6 = ar5		with gr6>>=3;	// gr6=2
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
	ar0 = gr7;
	delayed call vec_vsum_data_0;
		wtw;
		ftw;

	ar6 = ar5		with gr6>>=3;	// gr6=2
	ar5 = ar6+gr6	with gr6<<=3;	// gr6=16
	delayed call vec_vsum_data_0;
		ar0 = gr7;
		wtw;

	pop ar6,gr6;//End
	pop ar5,gr5;
	pop ar0,gr0;
	
	return;
.wait;
end ".text_nmplv";
