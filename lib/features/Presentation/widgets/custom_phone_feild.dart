// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';

// class CustomPhoneField extends StatelessWidget {
//   final String label;
//   final String hint;
//   final bool isEnabled;
//   final Function(String)? onSubmitted;
//   final Function(PhoneNumber)? onChanged;

//   const CustomPhoneField({
//     required this.label,
//     required this.hint,
//     required this.onSubmitted,
//     required this.onChanged,
//     required this.isEnabled,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10),
//         Container(
//           child: IntlPhoneField(
            
//             readOnly: isEnabled,
//             keyboardType: TextInputType.phone,
//             onSubmitted: onSubmitted,
//             onChanged: onChanged,
//             initialCountryCode: 'IN',
//             initialValue: '+91',
            
//             decoration: InputDecoration(
//               enabled: isEnabled,
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 borderSide: BorderSide(color: Colors.black, width: 1),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 borderSide: BorderSide(color: Colors.black, width: 1),
//               ),
//               disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 borderSide: BorderSide(color: Colors.black, width: 1),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                 borderSide: BorderSide(color: Colors.black, width: 1),
//               ),
//               hintText: hint,
//               contentPadding:
//                   EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
//               hintStyle: TextStyle(
//                 color: Colors.grey,
//               ),
//             ),
//             validator: (value) {
//               if (value == null || !value.isValidNumber()) {
//                 return 'Phone number is required';
//               }
//               if (!value.isValidNumber()) {
//                 return 'Please enter a valid phone number';
//               }
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
