class EmployeeModel {
  String? createdAt;
  String? name;
  String? avatar;
  String? emailId;
  String? mobile;
  String? country;
  String? state;
  String? district;
  String? id;
  String? email;

  EmployeeModel(
      {this.createdAt,
        this.name,
        this.avatar,
        this.emailId,
        this.mobile,
        this.country,
        this.state,
        this.district,
        this.id,
        this.email});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    name = json['name'];
    avatar = json['avatar'];
    emailId = json['emailId'];
    mobile = json['mobile'];
    country = json['country'];
    state = json['state'];
    district = json['district'];
    id = json['id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['avatar'] = avatar;
    data['emailId'] = emailId;
    data['mobile'] = mobile;
    data['country'] = country;
    data['state'] = state;
    data['district'] = district;
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
