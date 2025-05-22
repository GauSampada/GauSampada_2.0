enum UserType {
  user,
  doctor,
  farmer,
}

UserType fromStringToEnum(String value) {
  switch (value) {
    case 'user':
      return UserType.user;
    case 'doctor':
      return UserType.doctor;
    case 'farmer':
      return UserType.farmer;
    default:
      return UserType.user;
  }
}
