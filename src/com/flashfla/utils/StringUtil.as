/**
 * @author Jonathan (Velocity)
 */

package com.flashfla.utils {
	
	public class StringUtil {
		public static const KEY_ARRAY:Array = [
			"", "", "", "", "", "", "", "", "Backspace",
			"", "", "", "", "Enter", "", "", "Shift", "Ctrl",
			"Alt", "Pause", "Capslock", "", "", "", "", "", "",
			"Esc", "", "", "", "", "Space", "PgUp", "PgDown",
			"End", "Home", "Left", "Up", "Right", "Down", "", "",
			"", "", "Insert", "Delete", "", "0", "1", "2", "3",
			"4", "5", "6", "7", "8", "9", "", "", "", "",
			"", "", "", "A", "B", "C", "D", "E", "F", "G",
			"H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
			"R", "S", "T", "U", "V", "W", "X", "Y", "Z", "",
			"", "", "", "", "0", "1", "2", "3", "4", "5", "6",
			"7", "8", "9", "*", "+", "", "-", ".", "/", "F1",
			"F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10",
			"F11", "F12", "", "", "", "", "", "", "", "", "",
			"", "", "", "", "", "", "", "", "", "", "", "",
			"Sc Lk", "", "", "", "", "", "", "", "", "", "",
			"", "", "", "", "", "", "", "", "", "", "", "",
			 "", "", "", "", "", "", "", "", "", "", "", "",
			 "", "", "", "", "", "", ";", "=", ",", "-", ".", "/",
			 "`", "", "", "", "", "", "", "", "", "", "", "", "",
			 "", "", "", "", "", "", "", "", "", "", "", "", "",
			 "",  "", "\\", "", "'"
		];
		
		public static const STR_PAD_LEFT:String = "LeftPad";
		public static const STR_PAD_RIGHT:String = "RightPad";
		
		public static function fromCharArray(hexArray:Array):String {
			var output:String = "";
			for each (var char:uint in hexArray) {
				output += String.fromCharCode(char);
			}
			return output;
		}
		
		public static function toHex(input:String):String {
			var out:String = "";
			for (var c:uint = 0; c < input.length; c++) {
				out += "0x" + pad(Number(input.charCodeAt(c)).toString(16).toUpperCase(), 2, "0", STR_PAD_LEFT) + ",";
			}
			return out.substr(0, out.length - 1);
		}
		
		public static function pad(input:String, pad_length:uint, pad_string:String = " ", pad_type:String = null):String {
			var ret:String = input;
			
			if (pad_type == null)
				pad_type = STR_PAD_LEFT;
			
			if (pad_type == STR_PAD_LEFT)
				while (ret.length < pad_length)
					ret = pad_string + ret;
			
			else if (pad_type == STR_PAD_RIGHT)
				while (ret.length < pad_length)
					ret += pad_string;
			
			return ret;
		}
		
		public static function keyCodeChar(input:uint):String {
			return KEY_ARRAY[input] || ("[" + input.toString() + "]");
		}
	}
}
