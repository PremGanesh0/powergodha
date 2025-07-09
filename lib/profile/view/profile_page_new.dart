// import 'package:flutter/material.dart';
// import 'package:powergodha/l10n/app_localizations.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();

//   static Route<void> route() {
//     return MaterialPageRoute<void>(builder: (_) => const ProfilePage());
//   }
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();

//   // Personal details controllers
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _formNameController = TextEditingController();

//   // Address controllers
//   final _doorNumberController = TextEditingController();
//   final _pincodeController = TextEditingController();
//   final _villageController = TextEditingController();
//   final _talukaController = TextEditingController();
//   final _districtController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _countryController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localizations.accountInformation),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Personal Information Section
//                 _buildSectionHeader(context, 'Your Details'),
//                 const SizedBox(height: 16),

//                 _buildTextField(
//                   controller: _nameController,
//                   label: 'Full Name',
//                   prefixIcon: Icons.person_outline,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _phoneController,
//                   label: 'Phone Number',
//                   prefixIcon: Icons.phone_outlined,
//                   keyboardType: TextInputType.phone,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _emailController,
//                   label: 'Email',
//                   prefixIcon: Icons.email_outlined,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter your email';
//                     } else if (!_isValidEmail(value)) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _formNameController,
//                   label: 'Form Name',
//                   prefixIcon: Icons.description_outlined,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter form name' : null,
//                 ),

//                 const SizedBox(height: 32),

//                 // Address Information Section
//                 _buildSectionHeader(context, 'Your Address'),
//                 const SizedBox(height: 16),

//                 _buildTextField(
//                   controller: _doorNumberController,
//                   label: 'Door Number',
//                   prefixIcon: Icons.home_outlined,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter door number' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _pincodeController,
//                   label: 'Pincode',
//                   prefixIcon: Icons.pin_outlined,
//                   keyboardType: TextInputType.number,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter pincode' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _villageController,
//                   label: 'Village Name',
//                   prefixIcon: Icons.location_city_outlined,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter village name' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _talukaController,
//                   label: 'Taluka Name',
//                   prefixIcon: Icons.landscape_outlined,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter taluka name' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _districtController,
//                   label: 'District Name',
//                   prefixIcon: Icons.location_on_outlined,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter district name' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _stateController,
//                   label: 'State Name',
//                   prefixIcon: Icons.map_outlined,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter state name' : null,
//                 ),

//                 const SizedBox(height: 16),
//                 _buildTextField(
//                   controller: _countryController,
//                   label: 'Country Name',
//                   prefixIcon: Icons.public_outlined,
//                   validator: (value) => value == null || value.isEmpty ? 'Please enter country name' : null,
//                 ),

//                 const SizedBox(height: 32),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: _saveProfile,
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(200, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Update Profile'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Dispose personal details controllers
//     _nameController.dispose();
//     _phoneController.dispose();
//     _emailController.dispose();
//     _formNameController.dispose();

//     // Dispose address controllers
//     _doorNumberController.dispose();
//     _pincodeController.dispose();
//     _villageController.dispose();
//     _talukaController.dispose();
//     _districtController.dispose();
//     _stateController.dispose();
//     _countryController.dispose();

//     super.dispose();
//   }

//   // Helper method to build section headers
//   Widget _buildSectionHeader(BuildContext context, String title) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surfaceContainerHighest,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//           color: Theme.of(context).colorScheme.onSurfaceVariant,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   // Helper method to build text fields
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData prefixIcon,
//     required String? Function(String?) validator,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(prefixIcon),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       border: InputBorder.none,
//       filled: true,
//       fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
//       ),
//       keyboardType: keyboardType,
//       validator: validator,
//     );
//   }

//   // Helper method to validate email
//   bool _isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$');
//     return emailRegex.hasMatch(email);
//   }

//   void _saveProfile() {
//     if (_formKey.currentState!.validate()) {
//       // Save profile data - this would typically be integrated with your backend
//       // For now, just showing a success message

//       // Create a formatted string with all profile data
//       final profileData = '''
// Personal Details:
// - Name: ${_nameController.text}
// - Phone: ${_phoneController.text}
// - Email: ${_emailController.text}
// - Form Name: ${_formNameController.text}

// Address:
// - Door Number: ${_doorNumberController.text}
// - Pincode: ${_pincodeController.text}
// - Village: ${_villageController.text}
// - Taluka: ${_talukaController.text}
// - District: ${_districtController.text}
// - State: ${_stateController.text}
// - Country: ${_countryController.text}
// ''';

//       // Display a success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Profile updated successfully'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );

//       // For debugging - print the data to console
//       // In a real app, you would send this data to your backend
//       AppLogger.info(profileData);
//     }
//   }
// }
