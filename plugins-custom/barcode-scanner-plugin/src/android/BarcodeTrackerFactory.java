/*
 * Copyright (C) The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.develop_soft.scannerandroid;

import android.util.Log;

import com.google.android.gms.vision.Detector;
import com.google.android.gms.vision.MultiProcessor;
import com.google.android.gms.vision.Tracker;
import com.google.android.gms.vision.barcode.Barcode;

/**
 * Factory for creating a tracker and associated graphic to be associated with a new barcode.  The
 * multi-processor uses this factory to create barcode trackers as needed -- one for each barcode.
 */
class BarcodeTrackerFactory implements MultiProcessor.Factory<Barcode> {

//    BarcodeTrackerFactory(GraphicOverlay barcodeGraphicOverlay) {
//        mGraphicOverlay = barcodeGraphicOverlay;
//    }

    private IBarcodeResult mDelegate;

    public BarcodeTrackerFactory(IBarcodeResult delegate) {
        mDelegate = delegate;
    }

    @Override
    public Tracker<Barcode> create(Barcode barcode) {
        return new MyBarcodeTracker();
    }

    class MyBarcodeTracker extends Tracker<Barcode> {
        @Override
        public void onUpdate(Detector.Detections<Barcode> detections, Barcode barcode) {
            super.onUpdate(detections, barcode);
            if (mDelegate != null)
                mDelegate.onBarcodeDetected(barcode.displayValue);
        }
    }
}

