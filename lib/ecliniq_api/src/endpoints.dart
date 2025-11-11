class Endpoints {
  static const String localhost = 'http://192.168.1.3:3000';
  static const String prod = '';

  static String get loginOrRegisterUser =>
      '$localhost/api/auth/login-or-register';

  static String get verifyUser => '$localhost/api/auth/verify-user';

  static String get getUrl => '$localhost/api/uploads/getUploadUrl';

  static String get patientDetails => '$localhost/api/patients/create-patient-profile';
  static String get topHospitals => '$localhost/api/hospitals/top-hospitals';
  static String get topDoctors => '$localhost/api/doctors/top-doctors';
  static String hospitalDetails(String hospitalId) => '$localhost/api/hospitals/getHospitalDetailsByIdbyPatient/$hospitalId';
  static String getAllDoctorHospital(String hospitalId) => '$localhost/api/doctors/getAllDoctorsByHospitalIdForPatient/$hospitalId';
  static String get getSlotsByDate => '$localhost/api/slots/find-slots-by-doctor-and-date';
  static String get bookAppointment => '$localhost/api/appointments/book';

}
