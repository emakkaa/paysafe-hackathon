package com.cents.plugin.barcode.scanner;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.content.Intent;

import com.develop_soft.scannerandroid.BarcodeCaptureActivity;

public class BarcodeScanner extends CordovaPlugin {
    private CallbackContext mCallbackContext;

    protected void pluginInitialize() {
    }

    public boolean execute(String action, JSONArray args, CallbackContext callbackContext)  throws JSONException {
        mCallbackContext = callbackContext;
        if (action.equals("scan")) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    scan();
                }
            });

            return true;
        }

        return false;
    }

//    public Bundle onSaveInstanceState()
//    {
//
//    }
//
//    public void onRestoreStateForActivityResult(Bundle state, CallbackContext callbackContext) {
//
//    }

    private synchronized void scan() {
        try {
            Intent i = new Intent(cordova.getActivity().getApplicationContext(), com.develop_soft.scannerandroid.BarcodeCaptureActivity.class);
            //i.putExtra("key", value); //Optional parameters
            cordova.startActivityForResult(this, i, 0);
        }
        catch (Exception e)
        {
            mCallbackContext.error("Error launching scanner activity.");
        }
        /*Bitmap bm = BitmapFactory.decodeResource(cordova.getActivity().getResources(), R.drawable.icon_flash);
        String s;
        if (bm == null)
            s = "null";
        else
            s = bm.toString();

        new AlertDialog.Builder(cordova.getActivity())
    .setTitle("Android title")
    .setMessage("Android message")
    .setCancelable(false)
    .setNeutralButton(s, new AlertDialog.OnClickListener() {
      public void onClick(DialogInterface dialogInterface, int which) {
        dialogInterface.dismiss();
          mCallbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, 0));
      }
    })
    .create()
    .show();
*/
    }


    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        if (requestCode != 0) {
            mCallbackContext.error("Unknown request code: " + requestCode);
            return;
        }

        try {
            JSONObject retVal = new JSONObject();
            String result = intent.getStringExtra("result");

            retVal.put("code", resultCode);
            retVal.put("value", result);

            mCallbackContext.success(retVal);
        }
        catch (Exception e)
        {
            mCallbackContext.error(e.getMessage());
        }
    }
}