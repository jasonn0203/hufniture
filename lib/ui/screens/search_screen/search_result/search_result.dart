import 'package:flutter/material.dart';
import 'package:hufniture/ui/widgets/custom_appbar/custom_appbar.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Kết Quả Tìm Kiếm'),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        'https://th.bing.com/th/id/OIP.1kX66IhgdppAV3BH_0SCAgHaHa?rs=1&pid=ImgDetMain',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SOFA',
                            style: TextStyle(fontSize: 16.0),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            '200000',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
