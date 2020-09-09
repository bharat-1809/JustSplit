class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.pictureUrl,
    this.email,
    this.defaultCurrency,
    this.registrationStatus,
    this.phoneNumber,
  });

  String id;
  String firstName;
  String lastName;
  String pictureUrl;
  String email;
  String defaultCurrency;
  String registrationStatus;
  String phoneNumber;
}

enum registrationStatus {
  registered,
  invited,
  dummy,
}
