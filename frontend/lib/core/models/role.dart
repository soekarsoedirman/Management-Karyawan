class Role {
  final int? id;
  final String? nama;
  final int? gajiPokok;
  final String? deskripsi;

  Role({this.id, this.nama, this.gajiPokok, this.deskripsi});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
    nama: json['nama']?.toString() ?? json['name']?.toString(),
    gajiPokok: json['gajiPokok'] is int
        ? json['gajiPokok'] as int
        : int.tryParse('${json['gajiPokok']}'),
    deskripsi: json['deskripsi']?.toString() ?? json['description']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (nama != null) 'nama': nama,
    if (gajiPokok != null) 'gajiPokok': gajiPokok,
    if (deskripsi != null) 'deskripsi': deskripsi,
  };
}
