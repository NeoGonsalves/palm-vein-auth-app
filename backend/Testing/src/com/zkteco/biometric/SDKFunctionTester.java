package com.zkteco.biometric;

public class SDKFunctionTester {
    public static void main(String[] args) {
        // Step 1: Initialize SDK
        int initResult = ZKPalmService.init();
        System.out.println("SDK init(): " + initResult);

        // Step 2: Open Device
        long[] handle = new long[1];
        int openResult = ZKPalmService.openDevice(0, handle);
        System.out.println("openDevice(): " + openResult + ", handle = " + handle[0]);

        // Step 3: Create synthetic byte arrays
        byte[] imgBuffer = new byte[640 * 480]; // assume grayscale palm image
        byte[] rawTemplate = new byte[2048];    // example template buffer
        int[] cbRawTemplate = new int[] {2048};

        byte[] verTemplate = new byte[2048];
        int[] cbVerTemplate = new int[] {2048};
        int[] quality = new int[1];
        int[] palmRect = new int[4];

        // Step 4: Call a function with fake input
        int captureResult = ZKPalmService.capturePalmImageAndTemplate(
                handle[0], imgBuffer, imgBuffer.length, 1, rawTemplate,
                cbRawTemplate, verTemplate, cbVerTemplate, quality, palmRect, 0L
        );
        System.out.println("capturePalmImageAndTemplate(): " + captureResult);

        // Step 5: Close SDK
        int closeResult = ZKPalmService.closeDevice(handle[0]);
        System.out.println("closeDevice(): " + closeResult);

        ZKPalmService.terminate();
    }
}
