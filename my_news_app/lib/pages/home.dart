import 'package:flutter/material.dart';
import 'package:my_news_app/backend/functions.dart';
import 'package:my_news_app/components/appbar.dart';
import 'package:my_news_app/components/newsbox.dart';
import 'package:my_news_app/utils/colors.dart';
import 'package:my_news_app/utils/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List> news;

  @override
  void initState() {
    super.initState();
    news = fetchnews();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.black,
        appBar: const appbar(),
        body: Column(
          children: [
            const SearchBar(),
            Expanded(
              child: SizedBox(
                  width: w,
                  child: FutureBuilder<List>(
                    future: fetchnews(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return NewsBox(
                                url: snapshot.data![index]['url'],
                                imageurl:
                                    snapshot.data![index]['urlToImage'] ?? Constants.imageurl,
                                title: snapshot.data![index]['title'],
                                time: snapshot.data![index]['publishedAt'],
                                description: snapshot.data![index]
                                        ['description']
                                    .toString(),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return Center(
                          child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ));
                    },
                  )),
            ),
          ],
        ));
  }
}
