{ ... }:
{
  # Xbox One S controller (045E:02E0) over classic Bluetooth. The stock hid-microsoft
  # driver spams GET_REPORT requests the pad never answers (bluetoothd log:
  # "HIDP GET_REPORT request timed out") and the pad fails to reconnect.
  # xpadneo is the dedicated driver: clean reconnects, rumble, battery level.
  hardware.xpadneo.enable = true;

  # Answer the controller's reconnect page faster (costs a little idle power).
  hardware.bluetooth.settings.General.FastConnectable = true;
}
