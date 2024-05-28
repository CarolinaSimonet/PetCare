import 'package:nfc_manager/nfc_manager.dart';

void writeRFIDTag(String rfidCode) async {
  try {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);
        if (ndef == null || !ndef.isWritable) {
          print('Tag is not NDEF compatible or writable');
          return;
        }

        NdefMessage message = NdefMessage([
          NdefRecord.createText(rfidCode), // Use the provided code
        ]);

        try {
          await ndef.write(message);
          print('RFID tag written successfully with code: $rfidCode');
        } catch (e) {
          print('Error writing to RFID tag: $e');
        } finally {
          // Stop the NFC session after writing (or error)
          NfcManager.instance.stopSession(); 
        }
      });
    } else {
      print('NFC is not available on this device');
    }
  } catch (e) {
    print('Error starting NFC session: $e');
  }
}
