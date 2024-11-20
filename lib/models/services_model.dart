class ServiceModel {
  final int? id;
  final String? url;
  final String? servicename;
  final String? description;
  final String? ipserver;
  final String? port;
  final String? username;
  final String? password;
  final String? createdAt;
  final String? containerName;
  final String? updatedAt;

  ServiceModel({
    this.id,
    this.url,
    this.servicename,
    this.description,
    this.ipserver,
    this.port,
    this.username,
    this.password,
    this.containerName,
    this.createdAt,
    this.updatedAt,
  });

  // Factory untuk membuat objek dari Map hasil query SQLite
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as int?,
      url: map['url'] as String?,
      servicename: map['servicename'] as String?,
      description: map['description'] as String?,
      ipserver: map['ipserver'] as String?,
      port: map['port'] as String?,
      username: map['username'] as String?,
      password: map['password'] as String?,
      containerName: map['container_name'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  // Method untuk mengonversi objek menjadi Map (untuk insert/update SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'servicename': servicename,
      'description': description,
      'ipserver': ipserver,
      'port': port,
      'username': username,
      'password': password,
      'container_name': containerName,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
