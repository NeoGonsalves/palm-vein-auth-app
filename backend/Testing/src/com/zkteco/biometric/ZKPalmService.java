package com.zkteco.biometric;


public class ZKPalmService {
    static {
		// SDK 动态库放到系统目录下
		System.loadLibrary("libzksensorcore");
		System.loadLibrary("ZKPalmCap");
		System.loadLibrary("ZKPalmAPI");
		
		//或者根据 SDK DLL实际存放的位置来加载
		//System.loadLibrary("libzksensorcore.dll");
		//System.loadLibrary("ZKPalmCap.dll");
		//System.loadLibrary("ZKPalmAPI.dll");
    }

    public native static int getVersion(byte[] version, int size);
	public native static int init();
	public native static int terminate();
	public native static int openDevice(int index,long [] handle);  
	public native static int getDeviceCount (int[] devcnt); 
	public native static int closeDevice(long handle);
	public native static int setParameter(long handle, int code, byte[] value, int size);
	public native static int getParameter(long handle, int code, byte[] value, int[] size);  
	public native static int capturePalmImageAndTemplate(long  handle, byte[] imgBuffer, int cbImgBuffer,int extractType, byte[] rawTemplate,  int[] cbRawTemplate, byte [] verTemplate,int [] cbVerTemplate,int[] quality,  int[] pZKPalmRect,  long resverd); 
	public native static int verify(long handle, byte[] regTemplate, int cbRegTemplate, byte[] verTemplate, int cbVerTemplate,int[] score);	
	public native static int verifyByID(long handle, byte[] verTemplate, int cbVerTemplate, byte[] id,int[] score);
	public native static int mergeTemplates(long handle,byte[][] rawTemplates,int mergedCount,byte[] pMergeTemplate,int[] cbMergeTemplate);	  
	public native static int dbAdd(long handle,byte[] id, byte[] pRegTemplate,int cbRegTemplate);
	public native static int dbDel(long handle,byte[] id);
	public native static int dbCount(long handle,int[] count);
	public native static int dbClear(long handle);
	public native static int dbIdentify(long handle, byte[] verTemplate, int cbVerTemplate,byte[] id,int[] score, int minScore, int maxScore);	
	
}