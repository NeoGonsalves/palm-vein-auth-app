package com.zkteco.biometric;

public class PalmTest {

    public static void main(String[] args) {
        byte[] version = new byte[64];
        int result;

        // Step 1: Get SDK Version
        result = ZKPalmService.getVersion(version, version.length);
        System.out.println("SDK getVersion(): " + result);
        System.out.println("SDK version string: " + new String(version).trim());

        // Step 2: Initialize SDK
        result = ZKPalmService.init();
        System.out.println("SDK init(): " + result);

        // Step 3: Get device count
        int[] devCount = new int[1];
        result = ZKPalmService.getDeviceCount(devCount);
        System.out.println("getDeviceCount(): " + result + ", Available Devices: " + devCount[0]);

        // Step 4: Open device
        long[] handle = new long[1];
        result = ZKPalmService.openDevice(0, handle);
        System.out.println("openDevice(): " + result + ", handle = " + handle[0]);

        // Step 5: Capture Image and Template (Mock Buffers)
        byte[] imgBuffer = new byte[1024 * 100];  // Dummy image buffer
        byte[] rawTemplate = new byte[512];
        byte[] verTemplate = new byte[512];
        int[] cbRawTemplate = new int[]{512};
        int[] cbVerTemplate = new int[]{512};
        int[] quality = new int[1];
        int[] palmRect = new int[4];

        result = ZKPalmService.capturePalmImageAndTemplate(
                handle[0], imgBuffer, imgBuffer.length, 0,
                rawTemplate, cbRawTemplate, verTemplate, cbVerTemplate,
                quality, palmRect, 0
        );
        System.out.println("capturePalmImageAndTemplate(): " + result);

        // Step 6: Add to DB
        byte[] id = "test123".getBytes();
        result = ZKPalmService.dbAdd(handle[0], id, rawTemplate, cbRawTemplate[0]);
        System.out.println("dbAdd(): " + result);

        // Step 7: DB Count
        int[] dbCount = new int[1];
        result = ZKPalmService.dbCount(handle[0], dbCount);
        System.out.println("dbCount(): " + result + ", Count = " + dbCount[0]);

        // Step 8: Verify
        int[] score = new int[1];
        result = ZKPalmService.verify(handle[0], rawTemplate, cbRawTemplate[0], verTemplate, cbVerTemplate[0], score);
        System.out.println("verify(): " + result + ", Score = " + score[0]);

        // Step 9: Identify
        result = ZKPalmService.dbIdentify(handle[0], verTemplate, cbVerTemplate[0], id, score, 40, 100);
        System.out.println("dbIdentify(): " + result + ", ID Score = " + score[0]);

        // Step 10: Delete from DB
        result = ZKPalmService.dbDel(handle[0], id);
        System.out.println("dbDel(): " + result);

        // Step 11: Clear DB
        result = ZKPalmService.dbClear(handle[0]);
        System.out.println("dbClear(): " + result);

        // Step 12: Close Device
        result = ZKPalmService.closeDevice(handle[0]);
        System.out.println("closeDevice(): " + result);

        // Step 13: Terminate SDK
        result = ZKPalmService.terminate();
        System.out.println("terminate(): " + result);
    }
}
