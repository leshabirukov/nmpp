	#include "fft2.h"
	#include "rpc-host.h"	

	void nmppsFFT512Inv(const nm32sc* src, nm32sc* dst, const NmppsFFTSpec* spec)
	{
		int ret;	
		int size=512;
		int k=8;
		struct aura_buffer *iobuf_src = aura_buffer_request(n, size*k);	
		struct aura_buffer *iobuf_dst = aura_buffer_request(n, size*k);	
		memcpy(iobuf_src->data,src,size*k);	
		struct aura_buffer *retbuf; 
		ret = aura_call(n, "nmppsFFT512Inv", &retbuf,  iobuf_src, iobuf_dst, spec); 
		if (ret != 0) {
			slog(0, SLOG_ERROR, "call nmppsFFT512Inv  failed, reason: %d\n", ret);
			BUG(n, "Call nmppsFFT512Inv failed!"); 
		}
		memcpy(dst,iobuf_dst->data,size*k);
		aura_buffer_release( iobuf_dst); 
		aura_buffer_release( iobuf_src); 
		aura_buffer_release( retbuf); 
		slog(0, SLOG_INFO, "ARM: Call nmppsFFT512Inv -ok"); 
	}


	int nmppsFFT512InvInitAlloc(NmppsFFTSpec** spec, const void* src,const void* dst, int settings)
	{
		struct aura_buffer *iobuf_src = aura_buffer_request(n, 512*8);	
		struct aura_buffer *iobuf_dst = aura_buffer_request(n, 512*8);	
		struct aura_buffer *retbuf; 
		int ret =  aura_call(n, "nmppsFFT512InvInitAlloc", &retbuf,  iobuf_src, iobuf_dst, settings); 
		if (ret != 0) {
			slog(0, SLOG_ERROR, "call failed, reason: %d\n", ret);
			BUG(n, "Call nmppsFFT512InvInitAlloc failed!"); 
		}
		*spec = (NmppsFFTSpec*) aura_buffer_get_u32(retbuf);
		ret   = aura_buffer_get_u32(retbuf);
		aura_buffer_release( iobuf_src); 
		aura_buffer_release( iobuf_dst); 
		aura_buffer_release( retbuf); 
		slog(0, SLOG_INFO, "ARM: Call nmppsFFT512InvInitAlloc -ok"); 
		return ret;
	}