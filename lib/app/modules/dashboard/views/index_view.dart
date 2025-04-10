import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexView extends GetView {
  const IndexView({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data dummy
    final List<Map<String, String>> data = [
      {
        'nama': 'Ahmad Fauzi',
        'email': 'ahmad@example.com',
        'judul': 'Perbaikan Jalan',
        'deskripsi': 'Jalan di sekitar desa butuh perbaikan segera.'
      },
      {
        'nama': 'Budi Santoso',
        'email': 'budi@example.com',
        'judul': 'Fasilitas Sekolah',
        'deskripsi': 'Fasilitas sekolah dasar perlu ditingkatkan.'
      },
      {
        'nama': 'Citra Dewi',
        'email': 'citra@example.com',
        'judul': 'Penerangan Jalan',
        'deskripsi': 'Penerangan jalan umum di malam hari sangat minim.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saran Masyarakat'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: data.isEmpty
          ? const Center(
              child: Text(
                'Belum ada saran dan masukan',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blueAccent,
                              size: 32.0,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                item['judul'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Nama: ${item['nama']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4.0),
                            Expanded(
                              child: Text(
                                item['email'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          item['deskripsi'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
